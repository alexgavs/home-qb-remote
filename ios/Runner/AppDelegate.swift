import Flutter
import UIKit
import UserNotifications
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  // Contract with lib/services/torrent_export_service.dart:
  //   channel "org.homeqb/export", method "exportTorrent",
  //   arguments {"name": String, "bytes": Uint8List} -> Bool
  //   true  = an activity reported completion
  //   false = the share sheet was dismissed / cancelled
  //   FlutterError codes: invalid_export, export_busy, export_failed
  private static let exportChannelName = "org.homeqb/export"
  private static let exportMethod = "exportTorrent"
  private static let exportDirectoryPrefix = "org.homeqb.torrent-export-"
  private static let maxExportBytes = 16 * 1024 * 1024
  private static let maxExportNameLength = 140
  private static let exportExtension = ".torrent"

  // Contract with lib/services/incoming_document_service.dart (same channel):
  //   method "importTorrent", arguments {"uri": String}
  //   -> {"name": String, "bytes": Uint8List}, delivered exactly once on main.
  //   FlutterError codes: invalid_import, import_failed
  // Only a file URL naming a `.torrent` document is read: either a document
  // another app granted through a security scope, or a copy iOS placed in this
  // app's own Documents/Inbox. Nothing is ever fetched from the network.
  private static let importMethod = "importTorrent"
  private static let maxImportBytes = 16 * 1024 * 1024
  private static let maxImportURILength = 8192
  private static let importChunkSize = 64 * 1024

  private var exportChannel: FlutterMethodChannel?
  private var exportInProgress = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    WorkmanagerPlugin.registerPeriodicTask(
      withIdentifier: "org.homeqb.home_qb_remote.refresh",
      earliestBeginInSeconds: NSNumber(value: 15 * 60)
    )
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerExportChannel(with: engineBridge.pluginRegistry)
  }

  // MARK: - Torrent export channel

  private func registerExportChannel(with registry: FlutterPluginRegistry) {
    // The registrar exposes the binary messenger of the actual implicit engine,
    // the same path GeneratedPluginRegistrant uses for every plugin.
    let registrar: FlutterPluginRegistrar? = registry.registrar(forPlugin: "HomeQbTorrentExport")
    guard let registrar = registrar else { return }
    let channel = FlutterMethodChannel(
      name: AppDelegate.exportChannelName,
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] call, result in
      if call.method == AppDelegate.importMethod {
        // Read-only and stateless, so it needs no delegate instance.
        AppDelegate.importTorrent(call, result: result)
        return
      }
      guard let self = self else {
        result(FlutterError(code: "export_failed", message: "Export is unavailable", details: nil))
        return
      }
      if call.method == AppDelegate.exportMethod {
        self.exportTorrent(call, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    exportChannel = channel
    AppDelegate.removeStaleExportDirectories()
  }

  private func exportTorrent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard UIApplication.shared.applicationState == .active else {
      result(FlutterError(code: "export_failed", message: "Open the app before exporting", details: nil))
      return
    }
    let arguments = call.arguments as? [String: Any] ?? [:]
    guard let data = (arguments["bytes"] as? FlutterStandardTypedData)?.data,
      !data.isEmpty,
      data.count <= AppDelegate.maxExportBytes
    else {
      result(FlutterError(
        code: "invalid_export",
        message: "Torrent bytes are required and must be at most 16 MiB",
        details: nil
      ))
      return
    }
    if exportInProgress {
      result(FlutterError(code: "export_busy", message: "A share sheet is already open", details: nil))
      return
    }
    guard let presenter = AppDelegate.presentingViewController(fallback: window) else {
      result(FlutterError(
        code: "export_failed",
        message: "No active window can show the share sheet",
        details: nil
      ))
      return
    }

    // App-private temporary location, unique per export, never a public
    // directory. Nothing leaves the sandbox unless the user picks an activity.
    let fileName = AppDelegate.safeExportFileName(arguments["name"] as? String)
    let directory = FileManager.default.temporaryDirectory.appendingPathComponent(
      AppDelegate.exportDirectoryPrefix + UUID().uuidString,
      isDirectory: true
    )
    let fileURL = directory.appendingPathComponent(fileName, isDirectory: false)
    do {
      try FileManager.default.createDirectory(
        at: directory,
        withIntermediateDirectories: true,
        attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication]
      )
      try data.write(to: fileURL, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
    } catch {
      try? FileManager.default.removeItem(at: directory)
      result(FlutterError(
        code: "export_failed",
        message: "The torrent file could not be prepared for sharing",
        details: nil
      ))
      return
    }

    exportInProgress = true
    var delivered = false
    // Single delivery point: the temporary file stays alive until the activity
    // (AirDrop, Files, Mail, ...) finishes or the sheet is dismissed, then the
    // directory is removed and the Dart result is sent exactly once.
    let finish: (Bool) -> Void = { [weak self] completed in
      if delivered { return }
      delivered = true
      self?.exportInProgress = false
      try? FileManager.default.removeItem(at: directory)
      result(completed)
    }

    let sheet = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
    sheet.completionWithItemsHandler = { _, completed, _, error in
      finish(completed && error == nil)
    }
    if let popover = sheet.popoverPresentationController {
      // iPad requires an anchor; a centred, arrow-less popover works for any layout.
      let bounds = presenter.view.bounds
      popover.sourceView = presenter.view
      popover.sourceRect = CGRect(x: bounds.midX, y: bounds.midY, width: 1, height: 1)
      popover.permittedArrowDirections = []
    }
    presenter.present(sheet, animated: true)
  }

  /// Top-most view controller of the active scene window (scene lifecycle is
  /// managed by SceneDelegate, so `window` on the app delegate may be nil).
  private static func presentingViewController(fallback: UIWindow?) -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let ordered = scenes.filter { $0.activationState == .foregroundActive }
      + scenes.filter { $0.activationState != .foregroundActive }
    let windows = ordered.flatMap { $0.windows }
    let window = windows.first { $0.isKeyWindow } ?? windows.first ?? fallback
    guard var controller = window?.rootViewController else { return nil }
    while let presented = controller.presentedViewController, !presented.isBeingDismissed {
      controller = presented
    }
    return controller
  }

  /// Defence in depth: Dart already sanitizes, but the native side never trusts
  /// a name that could escape the temporary directory or break the sheet.
  static func safeExportFileName(_ requested: String?) -> String {
    let ext = AppDelegate.exportExtension
    var base = (requested ?? "").components(separatedBy: CharacterSet(charactersIn: "/\\")).last ?? ""
    let unsafe = CharacterSet.controlCharacters
      .union(.newlines)
      .union(.illegalCharacters)
      .union(CharacterSet(charactersIn: "<>:\"|?*"))
    var scalars = String.UnicodeScalarView()
    for scalar in base.unicodeScalars {
      scalars.append(unsafe.contains(scalar) ? "_" : scalar)
    }
    base = String(scalars).trimmingCharacters(in: .whitespacesAndNewlines)
    while base.lowercased().hasSuffix(ext) {
      base = String(base.dropLast(ext.count))
    }
    let edges = CharacterSet(charactersIn: ".").union(.whitespacesAndNewlines)
    base = base.trimmingCharacters(in: edges)
    if base.isEmpty { base = "export" }
    let maxBase = AppDelegate.maxExportNameLength - ext.count
    if base.count > maxBase {
      base = String(base.prefix(maxBase)).trimmingCharacters(in: edges)
      if base.isEmpty { base = "export" }
    }
    return base + ext
  }

  // MARK: - Incoming .torrent document import

  private enum ImportFailure: Error {
    /// The request itself is unacceptable (wrong URL, wrong type, bad size).
    case invalid(String)
    /// The document was acceptable but could not be read.
    case failed(String)

    var code: String {
      switch self {
      case .invalid: return "invalid_import"
      case .failed: return "import_failed"
      }
    }

    /// Generic, user-safe text: never a path, file name or system error.
    var message: String {
      switch self {
      case .invalid(let text), .failed(let text): return text
      }
    }
  }

  private static func importTorrent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? [String: Any] ?? [:]
    guard let url = AppDelegate.importableDocumentURL(arguments["uri"] as? String) else {
      result(FlutterError(
        code: "invalid_import",
        message: "Only a local .torrent document can be imported",
        details: nil
      ))
      return
    }
    // Single delivery point on the main queue, whatever thread the coordinator
    // or the reader finishes on and whether the read succeeded, failed or was
    // cancelled by the file coordinator.
    var delivered = false
    let deliver: (Any?) -> Void = { payload in
      DispatchQueue.main.async {
        if delivered { return }
        delivered = true
        result(payload)
      }
    }
    DispatchQueue.global(qos: .userInitiated).async {
      switch AppDelegate.readTorrentDocument(at: url) {
      case .success(let data):
        deliver([
          "name": AppDelegate.safeExportFileName(url.lastPathComponent),
          "bytes": FlutterStandardTypedData(bytes: data),
        ])
      case .failure(let failure):
        deliver(FlutterError(code: failure.code, message: failure.message, details: nil))
      }
    }
  }

  /// Accepts only a plain `file:` URL (no host, user info, port, query or
  /// fragment) whose last component is a `.torrent` document name.
  static func importableDocumentURL(_ raw: String?) -> URL? {
    guard let raw = raw,
      !raw.isEmpty,
      raw.count <= AppDelegate.maxImportURILength,
      raw.rangeOfCharacter(from: CharacterSet.controlCharacters.union(.newlines)) == nil,
      let components = URLComponents(string: raw),
      components.scheme?.lowercased() == "file",
      (components.host ?? "").isEmpty,
      components.user == nil,
      components.password == nil,
      components.port == nil,
      components.query == nil,
      components.fragment == nil
    else { return nil }
    // Encoded separators or NULs must not survive into the decoded path.
    let encodedPath = components.percentEncodedPath.lowercased()
    guard !encodedPath.isEmpty, !encodedPath.contains("%2f"), !encodedPath.contains("%5c"),
      !encodedPath.contains("%00")
    else { return nil }
    guard let url = components.url, url.isFileURL,
      !url.pathComponents.contains(where: { $0 == "." || $0 == ".." })
    else { return nil }
    let name = url.lastPathComponent
    guard url.pathExtension.lowercased() == "torrent",
      name.count > AppDelegate.exportExtension.count,
      !name.contains("/"), !name.contains("\\"), !name.contains("\0")
    else { return nil }
    return url.standardizedFileURL
  }

  /// Reads the document under a security scope (external provider) or, when no
  /// scope is granted, only when the canonical path is inside Documents/Inbox,
  /// where iOS places "Open in" copies for this app. The read is coordinated,
  /// capped at 16 MiB and never loads more than the cap plus one chunk.
  private static func readTorrentDocument(at url: URL) -> Result<Data, ImportFailure> {
    let scoped = url.startAccessingSecurityScopedResource()
    defer { if scoped { url.stopAccessingSecurityScopedResource() } }
    var outcome: Result<Data, ImportFailure> = .failure(
      .failed("The torrent document could not be read")
    )
    var coordinationError: NSError?
    NSFileCoordinator(filePresenter: nil).coordinate(
      readingItemAt: url,
      options: [.withoutChanges],
      error: &coordinationError
    ) { readURL in
      outcome = AppDelegate.readRegularFile(at: readURL, requireInbox: !scoped)
    }
    if coordinationError != nil {
      // Cancelled or refused by the provider; the accessor may not have run.
      return .failure(.failed("The torrent document could not be read"))
    }
    return outcome
  }

  private static func readRegularFile(at url: URL, requireInbox: Bool) -> Result<Data, ImportFailure> {
    let notAccessible = ImportFailure.invalid("The document is not accessible to this app")
    let unreadable = ImportFailure.failed("The torrent document could not be read")
    let badSize = ImportFailure.invalid("The torrent document is empty or larger than 16 MiB")

    // A symbolic link is never followed, whoever granted it: the grant (or the
    // Inbox location) applies to the link, not to whatever it points at.
    guard let linkValues = try? url.resourceValues(forKeys: [.isSymbolicLinkKey]),
      linkValues.isSymbolicLink != true
    else { return .failure(notAccessible) }

    // Canonical path (symlinks in every component resolved) decides whether an
    // unscoped URL is inside the Inbox; the same resolution is applied to the
    // Inbox path itself so /var vs /private/var differences cancel out.
    let resolved = url.standardizedFileURL.resolvingSymlinksInPath()
    if requireInbox {
      guard let inbox = AppDelegate.inboxDirectoryPath(),
        resolved.path.hasPrefix(inbox + "/")
      else { return .failure(notAccessible) }
    }
    let target = requireInbox ? resolved : url

    guard let values = try? target.resourceValues(forKeys: [.isRegularFileKey, .fileSizeKey]),
      values.isRegularFile == true
    else { return .failure(notAccessible) }
    if let size = values.fileSize {
      if size == 0 || size > AppDelegate.maxImportBytes { return .failure(badSize) }
    }

    guard let stream = InputStream(url: target) else { return .failure(unreadable) }
    stream.open()
    defer { stream.close() }
    var data = Data()
    var buffer = [UInt8](repeating: 0, count: AppDelegate.importChunkSize)
    while true {
      let count = stream.read(&buffer, maxLength: buffer.count)
      if count < 0 { return .failure(unreadable) }
      if count == 0 { break }
      data.append(buffer, count: count)
      // Enforced during the read as well: the size attribute is advisory and
      // the file may still be growing.
      if data.count > AppDelegate.maxImportBytes { return .failure(badSize) }
    }
    if data.isEmpty { return .failure(badSize) }
    return .success(data)
  }

  /// Canonical path of this app's Documents/Inbox, or nil when unknown.
  private static func inboxDirectoryPath() -> String? {
    guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    else { return nil }
    let inbox = documents
      .appendingPathComponent("Inbox", isDirectory: true)
      .standardizedFileURL
      .resolvingSymlinksInPath()
      .path
    if inbox.isEmpty || inbox == "/" { return nil }
    return inbox.hasSuffix("/") ? String(inbox.dropLast()) : inbox
  }

  /// Removes leftovers from exports interrupted by a crash or force-quit.
  private static func removeStaleExportDirectories() {
    DispatchQueue.global(qos: .utility).async {
      let manager = FileManager.default
      guard let entries = try? manager.contentsOfDirectory(
        at: manager.temporaryDirectory,
        includingPropertiesForKeys: [.creationDateKey],
        options: [.skipsHiddenFiles]
      ) else { return }
      for entry in entries where entry.lastPathComponent.hasPrefix(AppDelegate.exportDirectoryPrefix) {
        // Never race a newly opened share sheet while startup cleanup is queued.
        guard let created = try? entry.resourceValues(forKeys: [.creationDateKey]).creationDate,
          created < Date().addingTimeInterval(-24 * 60 * 60) else { continue }
        try? manager.removeItem(at: entry)
      }
    }
  }
}
