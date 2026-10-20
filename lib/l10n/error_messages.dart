import 'package:flutter/widgets.dart';

import 'l10n.dart';

/// A user-visible message resolved against the current [AppLocalizations].
///
/// Screens keep this closure in state instead of a finished String, so a
/// language switch retranslates messages that are already on screen.
typedef LocalizedText = String Function(AppLocalizations l10n);

/// English catalog for non-UI callers (pure validation, tests) that have no
/// BuildContext. Never use this for widgets; they must use context.l10n.
AppLocalizations englishL10n() => lookupAppLocalizations(const Locale('en'));

/// Keeps the raw safe backend identifier in state and falls back to [fallback]
/// only when the controller reported no error. Mirrors `c.error ?? fallback`.
LocalizedText backendFailure(String? raw, LocalizedText fallback) =>
    raw == null ? fallback : (l10n) => localizeError(l10n, raw);

final RegExp _httpStatusMessage = RegExp(
  r'^The server rejected the request \(HTTP (\d{3})\)\.$',
);

/// Maps a safe backend/controller error identifier to a localized message.
///
/// Only identifiers from the explicit whitelist below are translated. Any
/// unknown or raw text yields the localized generic failure, so untranslated
/// server or protocol text never reaches the screen. The HTTP status is shown
/// only when it parses to a valid 3-digit code.
String localizeError(AppLocalizations l10n, String? message) {
  if (message == null) return l10n.message0007;
  switch (message) {
    // Controller messages (Russian literals kept as stable identifiers).
    case 'Не удалось прочитать защищённое хранилище профилей.':
      return l10n.message0001;
    case 'Хранилище профилей недоступно. Изменения не сохранены; существующие данные сохранены.':
      return l10n.message0002;
    case 'API-ключ нельзя сочетать с Basic auth обратного прокси: оба используют заголовок Authorization.':
      return l10n.message0003;
    case 'Вход отклонён. Проверьте данные доступа и подключитесь к серверу ещё раз.':
      return l10n.message0004;
    case 'Выберите сервер':
      return l10n.message0005;
    case 'Выбранный файл не является корректным .torrent. Данные не отправлены.':
      return l10n.message0006;
    case 'Операция не выполнена. Проверьте соединение и настройки сервера.':
      return l10n.message0007;
    // Core protocol identifiers (English, from core/qb_client.dart).
    case 'The HTTP Basic username cannot contain a colon.':
      return l10n.message0008;
    case 'Use either an API key or HTTP Basic credentials, not both.':
      return l10n.message0009;
    case 'The API key contains spaces, line breaks or other unsupported characters.':
      return l10n.message0010;
    case 'Provide both the client certificate and its private key.':
      return l10n.message0011;
    case 'The custom CA or client certificate could not be loaded.':
      return l10n.message0012;
    case 'Use an HTTP or HTTPS server URL without embedded credentials, query, or fragment.':
      return l10n.message0013;
    case 'Invalid API endpoint.':
      return l10n.message0014;
    case 'The server connection is closed.':
      return l10n.message0015;
    case 'The server did not answer the API key check. Check the server URL and WebUI access settings.':
      return l10n.message0016;
    case 'Sign-in failed. Check the server credentials and WebUI access settings.':
      return l10n.message0017;
    case 'The server rejected the API key. Check the key and WebUI access settings, then reconnect.':
      return l10n.message0018;
    case 'Sign-in was rejected. Check the server credentials and WebUI access settings, then reconnect.':
      return l10n.message0019;
    case 'Sign in to the server first.':
      return l10n.message0020;
    case 'The server returned invalid JSON.':
      return l10n.message0021;
    case 'The server could not complete the action.':
      return l10n.message0022;
    case 'The server returned an invalid torrent list.':
      return l10n.message0023;
    case 'Select valid torrents first.':
      return l10n.message0024;
    case 'Enter a torrent URL or magnet link.':
      return l10n.message0025;
    case 'Choose a non-empty torrent file.':
      return l10n.message0026;
    case 'Choose a named torrent file.':
      return l10n.message0027;
    case 'Invalid torrent option field.':
      return l10n.message0028;
    case 'The server rejected the torrent file.':
      return l10n.message0029;
    case 'The server returned invalid torrent details.':
      return l10n.message0030;
    case 'The server request timed out.':
      return l10n.message0031;
    case 'The server returned an invalid redirect.':
      return l10n.message0032;
    case 'The server returned too many redirects.':
      return l10n.message0033;
    case 'The server response is too large.':
      return l10n.message0035;
    case 'Cannot reach the server. Check its address and connection.':
      return l10n.message0036;
    case 'The server connection failed.':
      return l10n.message0037;
    case 'The server returned an invalid response.':
      return l10n.message0038;
    case 'The server request failed.':
      return l10n.message0039;
    case 'The session expired. Sign in again.':
      return l10n.message0040;
    case 'The server rejected the request (HTTP 403).':
      return l10n.message0041;
    case "Device settings could not be read from secure storage.":
      return l10n.message0415;
    case "Background polling could not be scheduled on this device.":
      return l10n.message0416;
    case "Background polling is available on Android and iOS. Desktop notifications require the app to remain open.":
      return l10n.message0417;
    case "Notifications are not configured on this platform.":
      return l10n.message0418;
    case "System notifications are unavailable.":
      return l10n.message0419;
    case "System notifications could not be initialized.":
      return l10n.message0420;
    case "Android may delay polling because of battery, network, or background restrictions.":
      return l10n.message0421;
    case "Choose a polling interval between 15 and 1440 minutes.":
      return l10n.message0422;
    case "The new interval was saved, but the background schedule could not be updated.":
      return l10n.message0423;
    case "Notifications are unavailable.":
      return l10n.message0424;
    case "Notification permission was not granted.":
      return l10n.message0425;
    case "The background schedule could not be updated. Foreground notification checks still work.":
      return l10n.message0426;
    case "Unlock Home qB Remote":
      return l10n.message0427;
    case "Device authentication was not completed.":
      return l10n.message0428;
    case "Не удалось включить защиту снимков экрана.":
      return l10n.message0429;
    case "Не удалось удалить системные уведомления.":
      return l10n.message0430;
    case "Не удалось отменить фоновую проверку.":
      return l10n.message0431;
    case "Загрузка завершена":
      return l10n.message0432;
    case "Загрузка завершена. Откройте приложение для просмотра.":
      return l10n.message0433;
    case "Завершение загрузок":
      return l10n.message0434;
    case "Завершённые загрузки на ваших серверах qBittorrent":
      return l10n.message0435;
    case "Background scan budget exhausted.":
      return l10n.message0436;
    case "Only a local .torrent document can be imported.":
      return l10n.message0437;
    case "Document import is not supported on this platform.":
      return l10n.message0438;
    case "Document import is not available in this build of the app.":
      return l10n.message0439;
    case "The document was rejected by the system.":
      return l10n.message0440;
    case "The torrent document could not be read.":
      return l10n.message0441;
    case "The torrent document is empty.":
      return l10n.message0442;
    case "The torrent document is larger than 16 MiB and cannot be imported.":
      return l10n.message0443;
    case "The document is not a valid .torrent file.":
      return l10n.message0444;
    case "Русский":
      return l10n.message0445;
    case "Українська":
      return l10n.message0446;
    case "Unsupported language":
      return l10n.message0447;
    case "Another export is still in progress.":
      return l10n.message0448;
    case "Export is not supported on this platform.":
      return l10n.message0449;
    case "There is no torrent data to export.":
      return l10n.message0450;
    case "The torrent file is larger than 16 MiB and cannot be exported.":
      return l10n.message0451;
    case "The torrent data is not a valid byte sequence.":
      return l10n.message0452;
    case "Export is not available in this build of the app.":
      return l10n.message0453;
    case "The torrent data was rejected by the system.":
      return l10n.message0454;
    case "The torrent file could not be saved.":
      return l10n.message0455;
    case "The save dialog could not be opened.":
      return l10n.message0456;
    case "The torrent file could not be written to the chosen location.":
      return l10n.message0457;
  }
  final match = _httpStatusMessage.firstMatch(message);
  if (match != null) {
    final status = int.parse(match.group(1)!);
    if (status >= 100 && status <= 599) {
      return l10n.message0034('$status');
    }
  }
  // Unknown or unsafe-to-show text: never display raw identifiers.
  return l10n.message0007;
}
