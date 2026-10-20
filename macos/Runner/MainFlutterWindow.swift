import Cocoa
import FlutterMacOS
import CoreLocation

class MainFlutterWindow: NSWindow {
  private let wifiPermission = WifiPermissionBridge()
  private var wifiChannel: FlutterMethodChannel?
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    wifiChannel = FlutterMethodChannel(
      name: "org.homeqb/wifi", binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    wifiChannel?.setMethodCallHandler { [weak self] call, result in
      guard call.method == "requestPermission" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let self = self else { result(false); return }
      self.wifiPermission.request(result)
    }

    super.awakeFromNib()
  }
}

// Permission only: never starts location updates or reads coordinates.
private class WifiPermissionBridge: NSObject, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
  private var pending: FlutterResult?

  override init() {
    super.init()
    manager.delegate = self
  }

  func request(_ result: @escaping FlutterResult) {
    guard pending == nil else {
      result(FlutterError(code: "permission_busy", message: "Permission request already open", details: nil))
      return
    }
    let status = CLLocationManager.authorizationStatus()
    if status == .notDetermined {
      pending = result
      manager.requestWhenInUseAuthorization()
    } else {
      result(status == .authorizedAlways || status == .authorizedWhenInUse)
    }
  }

  private func complete(_ status: CLAuthorizationStatus) {
    guard status != .notDetermined, let callback = pending else { return }
    pending = nil
    callback(status == .authorizedAlways || status == .authorizedWhenInUse)
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    complete(status)
  }

  @available(macOS 11.0, *)
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    complete(manager.authorizationStatus)
  }
}
