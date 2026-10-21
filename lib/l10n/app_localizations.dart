import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('ru'),
    Locale('uk')
  ];

  /// Original: 'Не удалось прочитать защищённое хранилище профилей.'; source: lib/app_controller.dart:89
  ///
  /// In en, this message translates to:
  /// **'Could not read the protected profile storage.'**
  String get message0001;

  /// Original: 'Хранилище профилей недоступно. Изменения не сохранены; существующие данные сохранены.'; source: lib/app_controller.dart:112
  ///
  /// In en, this message translates to:
  /// **'Profile storage is unavailable. Changes were not saved; existing data was kept.'**
  String get message0002;

  /// Original: 'API-ключ нельзя сочетать с Basic auth обратного прокси: оба используют заголовок Authorization.'; source: lib/app_controller.dart:125
  ///
  /// In en, this message translates to:
  /// **'An API key cannot be combined with reverse proxy Basic auth: both use the Authorization header.'**
  String get message0003;

  /// Original: 'Вход отклонён. Проверьте данные доступа и подключитесь к серверу ещё раз.'; source: lib/app_controller.dart:197
  ///
  /// In en, this message translates to:
  /// **'Sign-in was rejected. Check your access details and reconnect to the server.'**
  String get message0004;

  /// Original: 'Выберите сервер'; source: lib/app_controller.dart:275
  ///
  /// In en, this message translates to:
  /// **'Select a server'**
  String get message0005;

  /// Original: 'Выбранный файл не является корректным .torrent. Данные не отправлены.'; source: lib/app_controller.dart:368
  ///
  /// In en, this message translates to:
  /// **'The selected file is not a valid .torrent. Data was not sent.'**
  String get message0006;

  /// Original: 'Операция не выполнена. Проверьте соединение и настройки сервера.'; source: lib/app_controller.dart:399
  ///
  /// In en, this message translates to:
  /// **'Operation failed. Check the connection and server settings.'**
  String get message0007;

  /// Original: 'The HTTP Basic username cannot contain a colon.'; source: lib/core/qb_client.dart:41
  ///
  /// In en, this message translates to:
  /// **'The HTTP Basic username cannot contain a colon.'**
  String get message0008;

  /// Original: 'Use either an API key or HTTP Basic credentials, not both.'; source: lib/core/qb_client.dart:80
  ///
  /// In en, this message translates to:
  /// **'Use either an API key or HTTP Basic credentials, not both.'**
  String get message0009;

  /// Original: 'The API key contains spaces, line breaks or other unsupported characters.'; source: lib/core/qb_client.dart:85
  ///
  /// In en, this message translates to:
  /// **'The API key contains spaces, line breaks or other unsupported characters.'**
  String get message0010;

  /// Original: 'Provide both the client certificate and its private key.'; source: lib/core/qb_client.dart:117
  ///
  /// In en, this message translates to:
  /// **'Provide both the client certificate and its private key.'**
  String get message0011;

  /// Original: 'The custom CA or client certificate could not be loaded.'; source: lib/core/qb_client.dart:142
  ///
  /// In en, this message translates to:
  /// **'The custom CA or client certificate could not be loaded.'**
  String get message0012;

  /// Original: 'Use an HTTP or HTTPS server URL without embedded credentials, query, or fragment.'; source: lib/core/qb_client.dart:164
  ///
  /// In en, this message translates to:
  /// **'Use an HTTP or HTTPS server URL without embedded credentials, query, or fragment.'**
  String get message0013;

  /// Original: 'Invalid API endpoint.'; source: lib/core/qb_client.dart:173
  ///
  /// In en, this message translates to:
  /// **'Invalid API endpoint.'**
  String get message0014;

  /// Original: 'The server connection is closed.'; source: lib/core/qb_client.dart:195
  ///
  /// In en, this message translates to:
  /// **'The server connection is closed.'**
  String get message0015;

  /// Original: 'The server did not answer the API key check. Check the server URL and WebUI access settings.'; source: lib/core/qb_client.dart:221
  ///
  /// In en, this message translates to:
  /// **'The server did not answer the API key check. Check the server URL and WebUI access settings.'**
  String get message0016;

  /// Original: 'Sign-in failed. Check the server credentials and WebUI access settings.'; source: lib/core/qb_client.dart:257
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Check the server credentials and WebUI access settings.'**
  String get message0017;

  /// Original: 'The server rejected the API key. Check the key and WebUI access settings, then reconnect.'; source: lib/core/qb_client.dart:309
  ///
  /// In en, this message translates to:
  /// **'The server rejected the API key. Check the key and WebUI access settings, then reconnect.'**
  String get message0018;

  /// Original: 'Sign-in was rejected. Check the server credentials and WebUI access settings, then reconnect.'; source: lib/core/qb_client.dart:310
  ///
  /// In en, this message translates to:
  /// **'Sign-in was rejected. Check the server credentials and WebUI access settings, then reconnect.'**
  String get message0019;

  /// Original: 'Sign in to the server first.'; source: lib/core/qb_client.dart:322
  ///
  /// In en, this message translates to:
  /// **'Sign in to the server first.'**
  String get message0020;

  /// Original: 'The server returned invalid JSON.'; source: lib/core/qb_client.dart:347
  ///
  /// In en, this message translates to:
  /// **'The server returned invalid JSON.'**
  String get message0021;

  /// Original: 'The server could not complete the action.'; source: lib/core/qb_client.dart:376
  ///
  /// In en, this message translates to:
  /// **'The server could not complete the action.'**
  String get message0022;

  /// Original: 'The server returned an invalid torrent list.'; source: lib/core/qb_client.dart:391
  ///
  /// In en, this message translates to:
  /// **'The server returned an invalid torrent list.'**
  String get message0023;

  /// Original: 'Select valid torrents first.'; source: lib/core/qb_client.dart:416
  ///
  /// In en, this message translates to:
  /// **'Select valid torrents first.'**
  String get message0024;

  /// Original: 'Enter a torrent URL or magnet link.'; source: lib/core/qb_client.dart:436
  ///
  /// In en, this message translates to:
  /// **'Enter a torrent URL or magnet link.'**
  String get message0025;

  /// Original: 'Choose a non-empty torrent file.'; source: lib/core/qb_client.dart:447
  ///
  /// In en, this message translates to:
  /// **'Choose a non-empty torrent file.'**
  String get message0026;

  /// Original: 'Choose a named torrent file.'; source: lib/core/qb_client.dart:454
  ///
  /// In en, this message translates to:
  /// **'Choose a named torrent file.'**
  String get message0027;

  /// Original: 'Invalid torrent option field.'; source: lib/core/qb_client.dart:461
  ///
  /// In en, this message translates to:
  /// **'Invalid torrent option field.'**
  String get message0028;

  /// Original: 'The server rejected the torrent file.'; source: lib/core/qb_client.dart:484
  ///
  /// In en, this message translates to:
  /// **'The server rejected the torrent file.'**
  String get message0029;

  /// Original: 'The server returned invalid torrent details.'; source: lib/core/qb_client.dart:508
  ///
  /// In en, this message translates to:
  /// **'The server returned invalid torrent details.'**
  String get message0030;

  /// Original: 'The server request timed out.'; source: lib/core/qb_client.dart:559
  ///
  /// In en, this message translates to:
  /// **'The server request timed out.'**
  String get message0031;

  /// Original: 'The server returned an invalid redirect.'; source: lib/core/qb_client.dart:604
  ///
  /// In en, this message translates to:
  /// **'The server returned an invalid redirect.'**
  String get message0032;

  /// Original: 'The server returned too many redirects.'; source: lib/core/qb_client.dart:615
  ///
  /// In en, this message translates to:
  /// **'The server returned too many redirects.'**
  String get message0033;

  /// Original: 'The server rejected the request (HTTP ${response.statusCode}).'; source: lib/core/qb_client.dart:653; expressions: ["response.statusCode"]
  ///
  /// In en, this message translates to:
  /// **'The server rejected the request (HTTP {arg1}).'**
  String message0034(String arg1);

  /// Original: 'The server response is too large.'; source: lib/core/qb_client.dart:660
  ///
  /// In en, this message translates to:
  /// **'The server response is too large.'**
  String get message0035;

  /// Original: 'Cannot reach the server. Check its address and connection.'; source: lib/core/qb_client.dart:718
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the server. Check its address and connection.'**
  String get message0036;

  /// Original: 'The server connection failed.'; source: lib/core/qb_client.dart:721
  ///
  /// In en, this message translates to:
  /// **'The server connection failed.'**
  String get message0037;

  /// Original: 'The server returned an invalid response.'; source: lib/core/qb_client.dart:723
  ///
  /// In en, this message translates to:
  /// **'The server returned an invalid response.'**
  String get message0038;

  /// Original: 'The server request failed.'; source: lib/core/qb_client.dart:725
  ///
  /// In en, this message translates to:
  /// **'The server request failed.'**
  String get message0039;

  /// Original: 'The session expired. Sign in again.'; source: lib/core/qb_client.dart:778
  ///
  /// In en, this message translates to:
  /// **'The session expired. Sign in again.'**
  String get message0040;

  /// Original: 'The server rejected the request (HTTP 403).'; source: lib/core/qb_client.dart:786
  ///
  /// In en, this message translates to:
  /// **'The server rejected the request (HTTP 403).'**
  String get message0041;

  /// Original: 'Операция не выполнена'; source: lib/features/advanced_screen.dart:31
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get message0042;

  /// Original: 'Отмена'; source: lib/features/advanced_screen.dart:77
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get message0043;

  /// Original: 'Применить'; source: lib/features/advanced_screen.dart:84
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get message0044;

  /// Original: 'Инструменты сервера'; source: lib/features/advanced_screen.dart:118
  ///
  /// In en, this message translates to:
  /// **'Server tools'**
  String get message0045;

  /// Original: 'Нет сервера'; source: lib/features/advanced_screen.dart:126
  ///
  /// In en, this message translates to:
  /// **'No server'**
  String get message0046;

  /// Original: 'Прямое подключение к вашему qBittorrent. Рекламы и аналитики нет.'; source: lib/features/advanced_screen.dart:131
  ///
  /// In en, this message translates to:
  /// **'Direct connection to your qBittorrent. No ads or analytics.'**
  String get message0047;

  /// Original: 'Поиск торрентов'; source: lib/features/advanced_screen.dart:141
  ///
  /// In en, this message translates to:
  /// **'Torrent search'**
  String get message0048;

  /// Original: 'Поисковые плагины вашего сервера'; source: lib/features/advanced_screen.dart:142
  ///
  /// In en, this message translates to:
  /// **'Your server\'s search plugins'**
  String get message0049;

  /// Original: 'RSS и правила загрузки'; source: lib/features/advanced_screen.dart:154
  ///
  /// In en, this message translates to:
  /// **'RSS and download rules'**
  String get message0050;

  /// Original: 'Ленты, статьи, автоматические правила'; source: lib/features/advanced_screen.dart:155
  ///
  /// In en, this message translates to:
  /// **'Feeds, articles, automatic rules'**
  String get message0051;

  /// Original: 'Скорость и режим лимитов'; source: lib/features/advanced_screen.dart:160
  ///
  /// In en, this message translates to:
  /// **'Speed and limit mode'**
  String get message0052;

  /// Original: 'Лимиты загрузки и отдачи в КиБ/с'; source: lib/features/advanced_screen.dart:161
  ///
  /// In en, this message translates to:
  /// **'Download and upload limits in KiB/s'**
  String get message0053;

  /// Original: 'Настройки qBittorrent'; source: lib/features/advanced_screen.dart:166
  ///
  /// In en, this message translates to:
  /// **'qBittorrent settings'**
  String get message0054;

  /// Original: 'Все доступные параметры WebUI API'; source: lib/features/advanced_screen.dart:167
  ///
  /// In en, this message translates to:
  /// **'All available WebUI API options'**
  String get message0055;

  /// Original: 'Категории и метки'; source: lib/features/advanced_screen.dart:179
  ///
  /// In en, this message translates to:
  /// **'Categories and tags'**
  String get message0056;

  /// Original: 'Создание, изменение и удаление'; source: lib/features/advanced_screen.dart:180
  ///
  /// In en, this message translates to:
  /// **'Create, edit and delete'**
  String get message0057;

  /// Original: 'Журнал сервера'; source: lib/features/advanced_screen.dart:185
  ///
  /// In en, this message translates to:
  /// **'Server log'**
  String get message0058;

  /// Original: 'Основной журнал и заблокированные пиры'; source: lib/features/advanced_screen.dart:186
  ///
  /// In en, this message translates to:
  /// **'Main log and blocked peers'**
  String get message0059;

  /// Original: 'Состояние соединения'; source: lib/features/advanced_screen.dart:193
  ///
  /// In en, this message translates to:
  /// **'Connection status'**
  String get message0060;

  /// Original: 'Скорости, переданные данные и DHT'; source: lib/features/advanced_screen.dart:194
  ///
  /// In en, this message translates to:
  /// **'Speeds, transferred data and DHT'**
  String get message0061;

  /// Original: 'Magic packet в вашей локальной сети'; source: lib/features/advanced_screen.dart:202
  ///
  /// In en, this message translates to:
  /// **'Magic packet on your local network'**
  String get message0062;

  /// Original: 'Ограничения скорости'; source: lib/features/advanced_screen.dart:229
  ///
  /// In en, this message translates to:
  /// **'Speed limits'**
  String get message0063;

  /// Original: 'Загрузка, КиБ/с (0 — без лимита)'; source: lib/features/advanced_screen.dart:230
  ///
  /// In en, this message translates to:
  /// **'Download, KiB/s (0 = no limit)'**
  String get message0064;

  /// Original: 'Отдача, КиБ/с (0 — без лимита)'; source: lib/features/advanced_screen.dart:232
  ///
  /// In en, this message translates to:
  /// **'Upload, KiB/s (0 = no limit)'**
  String get message0065;

  /// Original: 'Альтернативный режим (true/false)'; source: lib/features/advanced_screen.dart:233
  ///
  /// In en, this message translates to:
  /// **'Alternative mode (true/false)'**
  String get message0066;

  /// Original: 'Лимиты сохранены'; source: lib/features/advanced_screen.dart:245
  ///
  /// In en, this message translates to:
  /// **'Limits saved'**
  String get message0067;

  /// Original: 'MAC-адрес'; source: lib/features/advanced_screen.dart:272
  ///
  /// In en, this message translates to:
  /// **'MAC address'**
  String get message0068;

  /// Original: 'Broadcast-адрес'; source: lib/features/advanced_screen.dart:273
  ///
  /// In en, this message translates to:
  /// **'Broadcast address'**
  String get message0069;

  /// Original: 'Порт'; source: lib/features/advanced_screen.dart:274
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get message0070;

  /// Original: 'Magic packet отправлен'; source: lib/features/advanced_screen.dart:298
  ///
  /// In en, this message translates to:
  /// **'Magic packet sent'**
  String get message0071;

  /// Original: 'Настройка недоступна. Проверьте разрешения и защиту устройства.'; source: lib/features/device_settings_screen.dart:27
  ///
  /// In en, this message translates to:
  /// **'Setting unavailable. Check device permissions and security protection.'**
  String get message0072;

  /// Original: 'Настройки устройства'; source: lib/features/device_settings_screen.dart:37
  ///
  /// In en, this message translates to:
  /// **'Device settings'**
  String get message0073;

  /// Original: 'Блокировка приложения'; source: lib/features/device_settings_screen.dart:51
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get message0074;

  /// Original: 'Аутентификация средствами ОС при открытии и возвращении в приложение.'; source: lib/features/device_settings_screen.dart:53
  ///
  /// In en, this message translates to:
  /// **'OS authentication when opening and returning to the app.'**
  String get message0075;

  /// Original: 'Уведомления о завершении'; source: lib/features/device_settings_screen.dart:63
  ///
  /// In en, this message translates to:
  /// **'Completion notifications'**
  String get message0076;

  /// Original: 'Проверка при открытом приложении. Для уведомлений приложение должно работать.'; source: lib/features/device_settings_screen.dart:66
  ///
  /// In en, this message translates to:
  /// **'Checks while the app is open. The app must be running for notifications.'**
  String get message0077;

  /// Original: 'Прямой опрос qBittorrent. Фоновое выполнение ограничивается ОС; мгновенная доставка не гарантируется.'; source: lib/features/device_settings_screen.dart:67
  ///
  /// In en, this message translates to:
  /// **'Direct polling of qBittorrent. Background execution is limited by the OS; instant delivery is not guaranteed.'**
  String get message0078;

  /// Original: 'Интервал фоновой проверки'; source: lib/features/device_settings_screen.dart:77
  ///
  /// In en, this message translates to:
  /// **'Background check interval'**
  String get message0079;

  /// Original: '${DeviceServices.pollingIntervalMinutes} мин. ОС может отложить запуск.'; source: lib/features/device_settings_screen.dart:79; expressions: ["DeviceServices.pollingIntervalMinutes"]
  ///
  /// In en, this message translates to:
  /// **'{arg1} min. The OS may delay the start.'**
  String message0080(String arg1);

  /// Original: 'Интервал, минуты'; source: lib/features/device_settings_screen.dart:91
  ///
  /// In en, this message translates to:
  /// **'Interval, minutes'**
  String get message0081;

  /// Original: 'От 15 до 1440 минут'; source: lib/features/device_settings_screen.dart:96
  ///
  /// In en, this message translates to:
  /// **'From 15 to 1440 minutes'**
  String get message0082;

  /// Original: 'Сохранить'; source: lib/features/device_settings_screen.dart:111
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get message0083;

  /// Original: 'Без рекламы и аналитики'; source: lib/features/device_settings_screen.dart:130
  ///
  /// In en, this message translates to:
  /// **'No ads or analytics'**
  String get message0084;

  /// Original: 'Нет Firebase, рекламных SDK, удалённой конфигурации и регистрации у разработчика. Профили и сертификаты хранятся в защищённом хранилище ОС.'; source: lib/features/device_settings_screen.dart:132
  ///
  /// In en, this message translates to:
  /// **'No Firebase, ad SDKs, remote config, or developer registration. Profiles and certificates are stored in the OS secure storage.'**
  String get message0085;

  /// Original: 'Сетевые соединения'; source: lib/features/device_settings_screen.dart:137
  ///
  /// In en, this message translates to:
  /// **'Network connections'**
  String get message0086;

  /// Original: 'Клиент обращается к заданным вами серверам qBittorrent. Wake-on-LAN отправляет пакет на введённый локальный адрес. Поиск и RSS выполняет ваш сервер.'; source: lib/features/device_settings_screen.dart:139
  ///
  /// In en, this message translates to:
  /// **'The client connects to the qBittorrent servers you specify. Wake-on-LAN sends a packet to the local address you enter. Search and RSS are handled by your server.'**
  String get message0087;

  /// Original: 'Защита соединения'; source: lib/features/device_settings_screen.dart:144
  ///
  /// In en, this message translates to:
  /// **'Connection security'**
  String get message0088;

  /// Original: 'Для удалённого доступа используйте HTTPS или VPN. Проверка сертификата включена; собственный CA и клиентский PEM-сертификат задаются в профиле.'; source: lib/features/device_settings_screen.dart:146
  ///
  /// In en, this message translates to:
  /// **'Use HTTPS or a VPN for remote access. Certificate verification is enabled; a custom CA and client PEM certificate can be set in the profile.'**
  String get message0089;

  /// Original: 'Заполните поле'; source: lib/features/form_helpers.dart:98
  ///
  /// In en, this message translates to:
  /// **'Fill in this field'**
  String get message0090;

  /// Original: 'Подтвердить'; source: lib/features/form_helpers.dart:145
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get message0091;

  /// Original: 'Укажите целое число не меньше нуля'; source: lib/features/form_helpers.dart:153
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number, zero or greater'**
  String get message0092;

  /// Original: 'Б'; source: lib/features/form_helpers.dart:157
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get message0093;

  /// Original: 'КиБ'; source: lib/features/form_helpers.dart:157
  ///
  /// In en, this message translates to:
  /// **'KiB'**
  String get message0094;

  /// Original: 'МиБ'; source: lib/features/form_helpers.dart:157
  ///
  /// In en, this message translates to:
  /// **'MiB'**
  String get message0095;

  /// Original: 'ГиБ'; source: lib/features/form_helpers.dart:157
  ///
  /// In en, this message translates to:
  /// **'GiB'**
  String get message0096;

  /// Original: 'ТиБ'; source: lib/features/form_helpers.dart:157
  ///
  /// In en, this message translates to:
  /// **'TiB'**
  String get message0097;

  /// Original: 'Операция RSS не выполнена'; source: lib/features/rss_screen.dart:39
  ///
  /// In en, this message translates to:
  /// **'RSS operation failed'**
  String get message0098;

  /// Original: 'Обновить'; source: lib/features/rss_screen.dart:90
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get message0099;

  /// Original: 'Добавить'; source: lib/features/rss_screen.dart:96
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get message0100;

  /// Original: 'Добавить ленту'; source: lib/features/rss_screen.dart:99
  ///
  /// In en, this message translates to:
  /// **'Add feed'**
  String get message0101;

  /// Original: 'Создать папку'; source: lib/features/rss_screen.dart:100
  ///
  /// In en, this message translates to:
  /// **'Create folder'**
  String get message0102;

  /// Original: 'Добавить правило'; source: lib/features/rss_screen.dart:101
  ///
  /// In en, this message translates to:
  /// **'Add rule'**
  String get message0103;

  /// Original: 'Действия с папкой'; source: lib/features/rss_screen.dart:104
  ///
  /// In en, this message translates to:
  /// **'Folder actions'**
  String get message0104;

  /// Original: 'Статьи'; source: lib/features/rss_screen.dart:112
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get message0105;

  /// Original: 'Ленты'; source: lib/features/rss_screen.dart:113
  ///
  /// In en, this message translates to:
  /// **'Feeds'**
  String get message0106;

  /// Original: 'Правила'; source: lib/features/rss_screen.dart:114
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get message0107;

  /// Original: 'В лентах пока нет статей'; source: lib/features/rss_screen.dart:127
  ///
  /// In en, this message translates to:
  /// **'No articles in feeds yet'**
  String get message0108;

  /// Original: 'Без названия'; source: lib/features/rss_screen.dart:1
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get message0109;

  /// Original: 'Торрент добавлен'; source: lib/features/rss_screen.dart:163
  ///
  /// In en, this message translates to:
  /// **'Torrent added'**
  String get message0110;

  /// Original: 'Добавить торрент'; source: lib/features/rss_screen.dart:172
  ///
  /// In en, this message translates to:
  /// **'Add torrent'**
  String get message0111;

  /// Original: 'Отметить прочитанной'; source: lib/features/rss_screen.dart:176
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get message0112;

  /// Original: 'Добавьте первую RSS-ленту через +'; source: lib/features/rss_screen.dart:186
  ///
  /// In en, this message translates to:
  /// **'Add your first RSS feed with +'**
  String get message0113;

  /// Original: 'Обновить ленту'; source: lib/features/rss_screen.dart:202
  ///
  /// In en, this message translates to:
  /// **'Refresh feed'**
  String get message0114;

  /// Original: 'Отметить всё прочитанным'; source: lib/features/rss_screen.dart:206
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get message0115;

  /// Original: 'Переместить / переименовать'; source: lib/features/rss_screen.dart:211
  ///
  /// In en, this message translates to:
  /// **'Move / rename'**
  String get message0116;

  /// Original: 'Удалить ленту'; source: lib/features/rss_screen.dart:216
  ///
  /// In en, this message translates to:
  /// **'Delete feed'**
  String get message0117;

  /// Original: 'Нет правил автоматической загрузки'; source: lib/features/rss_screen.dart:225
  ///
  /// In en, this message translates to:
  /// **'No automatic download rules'**
  String get message0118;

  /// Original: 'Изменить'; source: lib/features/rss_screen.dart:251
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get message0119;

  /// Original: 'Переименовать'; source: lib/features/rss_screen.dart:255
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get message0120;

  /// Original: 'Подходящие статьи'; source: lib/features/rss_screen.dart:259
  ///
  /// In en, this message translates to:
  /// **'Matching articles'**
  String get message0121;

  /// Original: 'Удалить правило'; source: lib/features/rss_screen.dart:263
  ///
  /// In en, this message translates to:
  /// **'Delete rule'**
  String get message0122;

  /// Original: 'Папка RSS'; source: lib/features/rss_screen.dart:288
  ///
  /// In en, this message translates to:
  /// **'RSS folder'**
  String get message0123;

  /// Original: 'Полный путь папки'; source: lib/features/rss_screen.dart:289
  ///
  /// In en, this message translates to:
  /// **'Full folder path'**
  String get message0124;

  /// Original: 'Действие с папкой'; source: lib/features/rss_screen.dart:295
  ///
  /// In en, this message translates to:
  /// **'Folder action'**
  String get message0125;

  /// Original: 'Удалить папку'; source: lib/features/rss_screen.dart:303
  ///
  /// In en, this message translates to:
  /// **'Delete folder'**
  String get message0126;

  /// Original: 'Новая RSS-лента'; source: lib/features/rss_screen.dart:313
  ///
  /// In en, this message translates to:
  /// **'New RSS feed'**
  String get message0127;

  /// Original: 'Новая папка RSS'; source: lib/features/rss_screen.dart:313
  ///
  /// In en, this message translates to:
  /// **'New RSS folder'**
  String get message0128;

  /// Original: 'URL ленты'; source: lib/features/rss_screen.dart:316
  ///
  /// In en, this message translates to:
  /// **'Feed URL'**
  String get message0129;

  /// Original: 'Путь и имя ленты (необязательно)'; source: lib/features/rss_screen.dart:320
  ///
  /// In en, this message translates to:
  /// **'Feed path and name (optional)'**
  String get message0130;

  /// Original: 'Путь новой папки'; source: lib/features/rss_screen.dart:321
  ///
  /// In en, this message translates to:
  /// **'New folder path'**
  String get message0131;

  /// Original: 'Новый путь RSS'; source: lib/features/rss_screen.dart:337
  ///
  /// In en, this message translates to:
  /// **'New RSS path'**
  String get message0132;

  /// Original: 'Путь и новое имя'; source: lib/features/rss_screen.dart:340
  ///
  /// In en, this message translates to:
  /// **'Path and new name'**
  String get message0133;

  /// Original: 'Удалить элемент RSS?'; source: lib/features/rss_screen.dart:349
  ///
  /// In en, this message translates to:
  /// **'Delete RSS item?'**
  String get message0134;

  /// Original: 'Будет удалён «$path» и его содержимое RSS. Файлы торрентов не затрагиваются.'; source: lib/features/rss_screen.dart:350; expressions: ["path"]
  ///
  /// In en, this message translates to:
  /// **'“{arg1}” and its RSS content will be deleted. Torrent files will not be affected.'**
  String message0135(String arg1);

  /// Original: 'Удалить правило?'; source: lib/features/rss_screen.dart:380
  ///
  /// In en, this message translates to:
  /// **'Delete rule?'**
  String get message0136;

  /// Original: 'Имя правила'; source: lib/features/rss_screen.dart:383
  ///
  /// In en, this message translates to:
  /// **'Rule name'**
  String get message0137;

  /// Original: 'Новое имя'; source: lib/features/rss_screen.dart:384
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get message0138;

  /// Original: 'Подходящие статьи: $name'; source: lib/features/rss_screen.dart:396; expressions: ["name"]
  ///
  /// In en, this message translates to:
  /// **'Matching articles: {arg1}'**
  String message0139(String arg1);

  /// Original: 'Нет подходящих статей'; source: lib/features/rss_screen.dart:418
  ///
  /// In en, this message translates to:
  /// **'No matching articles'**
  String get message0140;

  /// Original: 'Закрыть'; source: lib/features/rss_screen.dart:426
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get message0141;

  /// Original: 'Новое правило RSS'; source: lib/features/rss_screen.dart:491
  ///
  /// In en, this message translates to:
  /// **'New RSS rule'**
  String get message0142;

  /// Original: 'Правило RSS'; source: lib/features/rss_screen.dart:491
  ///
  /// In en, this message translates to:
  /// **'RSS rule'**
  String get message0143;

  /// Original: 'Должно содержать'; source: lib/features/rss_screen.dart:502
  ///
  /// In en, this message translates to:
  /// **'Must contain'**
  String get message0144;

  /// Original: 'Не должно содержать'; source: lib/features/rss_screen.dart:503
  ///
  /// In en, this message translates to:
  /// **'Must not contain'**
  String get message0145;

  /// Original: 'Фильтр серий'; source: lib/features/rss_screen.dart:504
  ///
  /// In en, this message translates to:
  /// **'Episode filter'**
  String get message0146;

  /// Original: 'URL лент, каждый с новой строки'; source: lib/features/rss_screen.dart:505
  ///
  /// In en, this message translates to:
  /// **'Feed URLs, one per line'**
  String get message0147;

  /// Original: 'Категория'; source: lib/features/rss_screen.dart:506
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get message0148;

  /// Original: 'Путь сохранения'; source: lib/features/rss_screen.dart:507
  ///
  /// In en, this message translates to:
  /// **'Save path'**
  String get message0149;

  /// Original: 'Не загружать повторно, дней'; source: lib/features/rss_screen.dart:508
  ///
  /// In en, this message translates to:
  /// **'Do not re-download for, days'**
  String get message0150;

  /// Original: 'Укажите имя правила'; source: lib/features/rss_screen.dart:521
  ///
  /// In en, this message translates to:
  /// **'Enter a rule name'**
  String get message0151;

  /// Original: 'Правило включено'; source: lib/features/rss_screen.dart:531
  ///
  /// In en, this message translates to:
  /// **'Rule enabled'**
  String get message0152;

  /// Original: 'Регулярные выражения'; source: lib/features/rss_screen.dart:536
  ///
  /// In en, this message translates to:
  /// **'Regular expressions'**
  String get message0153;

  /// Original: 'Умный фильтр серий'; source: lib/features/rss_screen.dart:541
  ///
  /// In en, this message translates to:
  /// **'Smart episode filter'**
  String get message0154;

  /// Original: 'Добавлять на паузе'; source: lib/features/rss_screen.dart:546
  ///
  /// In en, this message translates to:
  /// **'Add paused'**
  String get message0155;

  /// Original: 'Поисковые плагины недоступны'; source: lib/features/search_screen.dart:42
  ///
  /// In en, this message translates to:
  /// **'Search plugins unavailable'**
  String get message0156;

  /// Original: 'Поиск на вашем сервере…'; source: lib/features/search_screen.dart:73
  ///
  /// In en, this message translates to:
  /// **'Searching your server…'**
  String get message0157;

  /// Original: '${results.length} результатов${response['status'] == 'Stopped' ? ' · завершено' : ''}'; source: lib/features/search_screen.dart:109; expressions: ["results.length", "response['status'] == 'Stopped' ? ' · завершено' : ''"]
  ///
  /// In en, this message translates to:
  /// **'{arg1, plural, one {{arg1} result} other {{arg1} results}}{arg2}'**
  String message0158(int arg1, String arg2);

  /// Original: ' · завершено'; source: lib/features/search_screen.dart:1
  ///
  /// In en, this message translates to:
  /// **' · completed'**
  String get message0159;

  /// Original: '${results.length} результатов · поиск остановлен через 2 минуты'; source: lib/features/search_screen.dart:117; expressions: ["results.length"]
  ///
  /// In en, this message translates to:
  /// **'{arg1, plural, one {{arg1} result} other {{arg1} results}} · search stopped after 2 minutes'**
  String message0160(int arg1);

  /// Original: 'Поиск не выполнен'; source: lib/features/search_screen.dart:124
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get message0161;

  /// Original: 'Не удалось остановить поиск'; source: lib/features/search_screen.dart:138
  ///
  /// In en, this message translates to:
  /// **'Could not stop the search'**
  String get message0162;

  /// Original: '${results.length} результатов · остановлено'; source: lib/features/search_screen.dart:144; expressions: ["results.length"]
  ///
  /// In en, this message translates to:
  /// **'{arg1, plural, one {{arg1} result} other {{arg1} results}} · stopped'**
  String message0163(int arg1);

  /// Original: 'Поиск на сервере'; source: lib/features/search_screen.dart:152
  ///
  /// In en, this message translates to:
  /// **'Server search'**
  String get message0164;

  /// Original: 'Плагины поиска'; source: lib/features/search_screen.dart:155
  ///
  /// In en, this message translates to:
  /// **'Search plugins'**
  String get message0165;

  /// Original: 'Название торрента'; source: lib/features/search_screen.dart:184
  ///
  /// In en, this message translates to:
  /// **'Torrent name'**
  String get message0166;

  /// Original: 'Стоп'; source: lib/features/search_screen.dart:192
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get message0167;

  /// Original: 'Найти'; source: lib/features/search_screen.dart:192
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get message0168;

  /// Original: 'Плагин'; source: lib/features/search_screen.dart:203
  ///
  /// In en, this message translates to:
  /// **'Plugin'**
  String get message0169;

  /// Original: 'Все плагины'; source: lib/features/search_screen.dart:207
  ///
  /// In en, this message translates to:
  /// **'All plugins'**
  String get message0170;

  /// Original: 'Только включённые'; source: lib/features/search_screen.dart:211
  ///
  /// In en, this message translates to:
  /// **'Enabled only'**
  String get message0171;

  /// Original: 'Все'; source: lib/features/search_screen.dart:235
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get message0172;

  /// Original: 'Книги'; source: lib/features/search_screen.dart:236
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get message0173;

  /// Original: 'Игры'; source: lib/features/search_screen.dart:237
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get message0174;

  /// Original: 'Фильмы'; source: lib/features/search_screen.dart:238
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get message0175;

  /// Original: 'Музыка'; source: lib/features/search_screen.dart:239
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get message0176;

  /// Original: 'Программы'; source: lib/features/search_screen.dart:240
  ///
  /// In en, this message translates to:
  /// **'Software'**
  String get message0177;

  /// Original: 'Сериалы'; source: lib/features/search_screen.dart:241
  ///
  /// In en, this message translates to:
  /// **'TV shows'**
  String get message0178;

  /// Original: 'Введите запрос для поиска'; source: lib/features/search_screen.dart:263
  ///
  /// In en, this message translates to:
  /// **'Enter a search query'**
  String get message0179;

  /// Original: '${humanBytes(result['fileSize'] is num ? result['fileSize'] as num : 0)} · сиды ${result['nbSeeders'] ?? 0}\n${result['siteUrl'] ?? ''}'; source: lib/features/search_screen.dart:271; expressions: ["humanBytes(result['fileSize'] is num ? result['fileSize'] as num : 0)", "result['nbSeeders'] ?? 0", "result['siteUrl'] ?? ''"]
  ///
  /// In en, this message translates to:
  /// **'{arg1} · seeds {arg2}\n{arg3}'**
  String message0180(String arg1, String arg2, String arg3);

  /// Original: 'Добавить на сервер'; source: lib/features/search_screen.dart:275
  ///
  /// In en, this message translates to:
  /// **'Add to server'**
  String get message0181;

  /// Original: 'Не удалось добавить торрент'; source: lib/features/search_screen.dart:293
  ///
  /// In en, this message translates to:
  /// **'Could not add torrent'**
  String get message0182;

  /// Original: 'Не удалось изменить плагины'; source: lib/features/search_screen.dart:336
  ///
  /// In en, this message translates to:
  /// **'Could not change plugins'**
  String get message0183;

  /// Original: 'Установить поисковый плагин'; source: lib/features/search_screen.dart:357
  ///
  /// In en, this message translates to:
  /// **'Install search plugin'**
  String get message0184;

  /// Original: 'URL файла плагина'; source: lib/features/search_screen.dart:358
  ///
  /// In en, this message translates to:
  /// **'Plugin file URL'**
  String get message0185;

  /// Original: 'Плагин будет скачан и установлен на вашем сервере qBittorrent. Указывайте доверенный источник.'; source: lib/features/search_screen.dart:359
  ///
  /// In en, this message translates to:
  /// **'The plugin will be downloaded and installed on your qBittorrent server. Use only trusted sources.'**
  String get message0186;

  /// Original: 'Поисковые плагины'; source: lib/features/search_screen.dart:369
  ///
  /// In en, this message translates to:
  /// **'Search plugins'**
  String get message0187;

  /// Original: 'Обновить плагины'; source: lib/features/search_screen.dart:372
  ///
  /// In en, this message translates to:
  /// **'Update plugins'**
  String get message0188;

  /// Original: 'Установить плагин'; source: lib/features/search_screen.dart:382
  ///
  /// In en, this message translates to:
  /// **'Install plugin'**
  String get message0189;

  /// Original: 'На сервере нет поисковых плагинов'; source: lib/features/search_screen.dart:395
  ///
  /// In en, this message translates to:
  /// **'No search plugins on the server'**
  String get message0190;

  /// Original: 'Версия ${plugin['version'] ?? '—'}'; source: lib/features/search_screen.dart:401; expressions: ["plugin['version'] ?? '—'"]
  ///
  /// In en, this message translates to:
  /// **'Version {arg1}'**
  String message0191(String arg1);

  /// Original: 'Удалить плагин'; source: lib/features/search_screen.dart:413
  ///
  /// In en, this message translates to:
  /// **'Delete plugin'**
  String get message0192;

  /// Original: 'Удалить плагин?'; source: lib/features/search_screen.dart:420
  ///
  /// In en, this message translates to:
  /// **'Delete plugin?'**
  String get message0193;

  /// Original: 'Новая категория'; source: lib/features/server_info_screen.dart:76
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get message0194;

  /// Original: 'Изменить категорию'; source: lib/features/server_info_screen.dart:76
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get message0195;

  /// Original: 'Название'; source: lib/features/server_info_screen.dart:79
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get message0196;

  /// Original: 'Папка на сервере'; source: lib/features/server_info_screen.dart:80
  ///
  /// In en, this message translates to:
  /// **'Server folder'**
  String get message0197;

  /// Original: 'Категории'; source: lib/features/server_info_screen.dart:94
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get message0198;

  /// Original: 'Удалить категорию'; source: lib/features/server_info_screen.dart:119
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get message0199;

  /// Original: 'Удалить категорию?'; source: lib/features/server_info_screen.dart:126
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get message0200;

  /// Original: '${entry.key}. Торренты и файлы сохранятся.'; source: lib/features/server_info_screen.dart:127; expressions: ["entry.key"]
  ///
  /// In en, this message translates to:
  /// **'{arg1}. Torrents and files will be kept.'**
  String message0201(String arg1);

  /// Original: 'Теги'; source: lib/features/server_info_screen.dart:138
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get message0202;

  /// Original: 'Создать теги'; source: lib/features/server_info_screen.dart:140
  ///
  /// In en, this message translates to:
  /// **'Create tags'**
  String get message0203;

  /// Original: 'Новые теги'; source: lib/features/server_info_screen.dart:145
  ///
  /// In en, this message translates to:
  /// **'New tags'**
  String get message0204;

  /// Original: 'Названия через запятую'; source: lib/features/server_info_screen.dart:148
  ///
  /// In en, this message translates to:
  /// **'Names separated by commas'**
  String get message0205;

  /// Original: 'Удалить тег'; source: lib/features/server_info_screen.dart:163
  ///
  /// In en, this message translates to:
  /// **'Delete tag'**
  String get message0206;

  /// Original: 'Удалить тег?'; source: lib/features/server_info_screen.dart:170
  ///
  /// In en, this message translates to:
  /// **'Delete tag?'**
  String get message0207;

  /// Original: '$tag. Торренты и файлы сохранятся.'; source: lib/features/server_info_screen.dart:171; expressions: ["tag"]
  ///
  /// In en, this message translates to:
  /// **'{arg1}. Torrents and files will be kept.'**
  String message0208(String arg1);

  /// Original: 'Обычный'; source: lib/features/server_info_screen.dart:182
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get message0209;

  /// Original: 'Информация'; source: lib/features/server_info_screen.dart:183
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get message0210;

  /// Original: 'Предупреждение'; source: lib/features/server_info_screen.dart:184
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get message0211;

  /// Original: 'Критический'; source: lib/features/server_info_screen.dart:185
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get message0212;

  /// Original: 'Сообщение'; source: lib/features/server_info_screen.dart:186
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message0213;

  /// Original: 'Журнал пиров'; source: lib/features/server_info_screen.dart:191
  ///
  /// In en, this message translates to:
  /// **'Peer log'**
  String get message0214;

  /// Original: 'Уровень'; source: lib/features/server_info_screen.dart:205
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get message0215;

  /// Original: 'Все сообщения'; source: lib/features/server_info_screen.dart:207
  ///
  /// In en, this message translates to:
  /// **'All messages'**
  String get message0216;

  /// Original: 'Предупреждения'; source: lib/features/server_info_screen.dart:208
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get message0217;

  /// Original: 'Критические'; source: lib/features/server_info_screen.dart:209
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get message0218;

  /// Original: 'Заблокирован'; source: lib/features/server_info_screen.dart:1
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get message0219;

  /// Original: 'Разрешён'; source: lib/features/server_info_screen.dart:1
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get message0220;

  /// Original: 'Скорость загрузки'; source: lib/features/server_info_screen.dart:249
  ///
  /// In en, this message translates to:
  /// **'Download speed'**
  String get message0221;

  /// Original: 'Скорость отдачи'; source: lib/features/server_info_screen.dart:250
  ///
  /// In en, this message translates to:
  /// **'Upload speed'**
  String get message0222;

  /// Original: 'Получено за сессию'; source: lib/features/server_info_screen.dart:251
  ///
  /// In en, this message translates to:
  /// **'Downloaded this session'**
  String get message0223;

  /// Original: 'Отдано за сессию'; source: lib/features/server_info_screen.dart:252
  ///
  /// In en, this message translates to:
  /// **'Uploaded this session'**
  String get message0224;

  /// Original: 'Лимит загрузки'; source: lib/features/server_info_screen.dart:253
  ///
  /// In en, this message translates to:
  /// **'Download limit'**
  String get message0225;

  /// Original: 'Лимит отдачи'; source: lib/features/server_info_screen.dart:254
  ///
  /// In en, this message translates to:
  /// **'Upload limit'**
  String get message0226;

  /// Original: 'Узлы DHT'; source: lib/features/server_info_screen.dart:255
  ///
  /// In en, this message translates to:
  /// **'DHT nodes'**
  String get message0227;

  /// Original: 'Соединение'; source: lib/features/server_info_screen.dart:256
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get message0228;

  /// Original: '${humanBytes((info[entry.key] as num?)?.toInt() ?? 0)}/с'; source: lib/features/server_info_screen.dart:266; expressions: ["humanBytes((info[entry.key] as num?)?.toInt() ?? 0)"]
  ///
  /// In en, this message translates to:
  /// **'{arg1}/s'**
  String message0229(String arg1);

  /// Original: 'Подключено'; source: lib/features/server_info_screen.dart:271
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get message0230;

  /// Original: 'За NAT / firewall'; source: lib/features/server_info_screen.dart:272
  ///
  /// In en, this message translates to:
  /// **'Behind NAT / firewall'**
  String get message0231;

  /// Original: 'Нет соединения'; source: lib/features/server_info_screen.dart:273
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get message0232;

  /// Original: 'Категории и теги'; source: lib/features/server_info_screen.dart:286
  ///
  /// In en, this message translates to:
  /// **'Categories and tags'**
  String get message0233;

  /// Original: 'Состояние сервера'; source: lib/features/server_info_screen.dart:288
  ///
  /// In en, this message translates to:
  /// **'Server status'**
  String get message0234;

  /// Original: 'Не удалось получить настройки'; source: lib/features/server_settings_screen.dart:33
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load settings'**
  String get message0235;

  /// Original: 'Изменить WebUI?'; source: lib/features/server_settings_screen.dart:42
  ///
  /// In en, this message translates to:
  /// **'Change WebUI?'**
  String get message0236;

  /// Original: 'Изменение адреса, порта или авторизации может разорвать подключение.'; source: lib/features/server_settings_screen.dart:43
  ///
  /// In en, this message translates to:
  /// **'Changing the address, port, or authentication may disconnect you.'**
  String get message0237;

  /// Original: 'Настройки сохранены. Если изменились адрес, порт или пароль WebUI, обновите профиль подключения.'; source: lib/features/server_settings_screen.dart:60
  ///
  /// In en, this message translates to:
  /// **'Settings saved. If the WebUI address, port, or password changed, update your connection profile.'**
  String get message0238;

  /// Original: 'Настройки сохранены'; source: lib/features/server_settings_screen.dart:61
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get message0239;

  /// Original: 'Не удалось сохранить настройки'; source: lib/features/server_settings_screen.dart:65
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save settings'**
  String get message0240;

  /// Original: 'Введите целое число'; source: lib/features/server_settings_screen.dart:103
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number'**
  String get message0241;

  /// Original: 'Порт от 1 до 65535'; source: lib/features/server_settings_screen.dart:105
  ///
  /// In en, this message translates to:
  /// **'Port must be 1–65535'**
  String get message0242;

  /// Original: 'Час от 0 до 23'; source: lib/features/server_settings_screen.dart:108
  ///
  /// In en, this message translates to:
  /// **'Hour must be 0–23'**
  String get message0243;

  /// Original: 'Минута от 0 до 59'; source: lib/features/server_settings_screen.dart:111
  ///
  /// In en, this message translates to:
  /// **'Minute must be 0–59'**
  String get message0244;

  /// Original: 'Минимум −1 (если поддерживается сервером)'; source: lib/features/server_settings_screen.dart:114
  ///
  /// In en, this message translates to:
  /// **'Minimum −1 (if supported by the server)'**
  String get message0245;

  /// Original: 'Расширенные параметры JSON'; source: lib/features/server_settings_screen.dart:132
  ///
  /// In en, this message translates to:
  /// **'Advanced JSON settings'**
  String get message0246;

  /// Original: 'Все параметры текущего сервера. Сохраняются только изменённые ключи.'; source: lib/features/server_settings_screen.dart:143
  ///
  /// In en, this message translates to:
  /// **'All settings from the current server. Only changed keys are saved.'**
  String get message0247;

  /// Original: 'Некорректный JSON параметров'; source: lib/features/server_settings_screen.dart:159
  ///
  /// In en, this message translates to:
  /// **'Invalid settings JSON'**
  String get message0248;

  /// Original: 'Загрузки'; source: lib/features/server_settings_screen.dart:191
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get message0249;

  /// Original: 'Папка сохранения'; source: lib/features/server_settings_screen.dart:192
  ///
  /// In en, this message translates to:
  /// **'Save folder'**
  String get message0250;

  /// Original: 'Папка временных файлов'; source: lib/features/server_settings_screen.dart:193
  ///
  /// In en, this message translates to:
  /// **'Temp folder'**
  String get message0251;

  /// Original: 'Использовать временную папку'; source: lib/features/server_settings_screen.dart:194
  ///
  /// In en, this message translates to:
  /// **'Use temp folder'**
  String get message0252;

  /// Original: 'Добавлять остановленными'; source: lib/features/server_settings_screen.dart:195
  ///
  /// In en, this message translates to:
  /// **'Add paused'**
  String get message0253;

  /// Original: 'Автоматическое управление'; source: lib/features/server_settings_screen.dart:196
  ///
  /// In en, this message translates to:
  /// **'Automatic torrent management'**
  String get message0254;

  /// Original: 'Выделять место заранее'; source: lib/features/server_settings_screen.dart:197
  ///
  /// In en, this message translates to:
  /// **'Pre-allocate disk space'**
  String get message0255;

  /// Original: 'Расширение для незавершённых файлов'; source: lib/features/server_settings_screen.dart:200
  ///
  /// In en, this message translates to:
  /// **'Extension for incomplete files'**
  String get message0256;

  /// Original: 'Папка экспорта .torrent'; source: lib/features/server_settings_screen.dart:202
  ///
  /// In en, this message translates to:
  /// **'.torrent export folder'**
  String get message0257;

  /// Original: 'Экспорт завершённых .torrent'; source: lib/features/server_settings_screen.dart:203
  ///
  /// In en, this message translates to:
  /// **'Export finished .torrent files'**
  String get message0258;

  /// Original: 'Входящий порт'; source: lib/features/server_settings_screen.dart:206
  ///
  /// In en, this message translates to:
  /// **'Incoming port'**
  String get message0259;

  /// Original: 'Случайный порт при запуске'; source: lib/features/server_settings_screen.dart:207
  ///
  /// In en, this message translates to:
  /// **'Random port on startup'**
  String get message0260;

  /// Original: 'Максимум соединений (-1 — без лимита)'; source: lib/features/server_settings_screen.dart:211
  ///
  /// In en, this message translates to:
  /// **'Max connections (-1 = no limit)'**
  String get message0261;

  /// Original: 'Соединений на торрент'; source: lib/features/server_settings_screen.dart:216
  ///
  /// In en, this message translates to:
  /// **'Connections per torrent'**
  String get message0262;

  /// Original: 'Слотов отдачи'; source: lib/features/server_settings_screen.dart:219
  ///
  /// In en, this message translates to:
  /// **'Upload slots'**
  String get message0263;

  /// Original: 'Адрес прокси'; source: lib/features/server_settings_screen.dart:220
  ///
  /// In en, this message translates to:
  /// **'Proxy address'**
  String get message0264;

  /// Original: 'Порт прокси'; source: lib/features/server_settings_screen.dart:221
  ///
  /// In en, this message translates to:
  /// **'Proxy port'**
  String get message0265;

  /// Original: 'Пользователь прокси'; source: lib/features/server_settings_screen.dart:222
  ///
  /// In en, this message translates to:
  /// **'Proxy username'**
  String get message0266;

  /// Original: 'Пароль прокси'; source: lib/features/server_settings_screen.dart:223
  ///
  /// In en, this message translates to:
  /// **'Proxy password'**
  String get message0267;

  /// Original: 'Скорость'; source: lib/features/server_settings_screen.dart:225
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get message0268;

  /// Original: 'Загрузка, байт/с (0 — без лимита)'; source: lib/features/server_settings_screen.dart:228
  ///
  /// In en, this message translates to:
  /// **'Download, bytes/s (0 = no limit)'**
  String get message0269;

  /// Original: 'Отдача, байт/с (0 — без лимита)'; source: lib/features/server_settings_screen.dart:233
  ///
  /// In en, this message translates to:
  /// **'Upload, bytes/s (0 = no limit)'**
  String get message0270;

  /// Original: 'Альтернативная загрузка, байт/с'; source: lib/features/server_settings_screen.dart:238
  ///
  /// In en, this message translates to:
  /// **'Alternative download, bytes/s'**
  String get message0271;

  /// Original: 'Альтернативная отдача, байт/с'; source: lib/features/server_settings_screen.dart:243
  ///
  /// In en, this message translates to:
  /// **'Alternative upload, bytes/s'**
  String get message0272;

  /// Original: 'Расписание альтернативных лимитов'; source: lib/features/server_settings_screen.dart:248
  ///
  /// In en, this message translates to:
  /// **'Alternative limits schedule'**
  String get message0273;

  /// Original: 'Начало: час'; source: lib/features/server_settings_screen.dart:250
  ///
  /// In en, this message translates to:
  /// **'Start: hour'**
  String get message0274;

  /// Original: 'Начало: минута'; source: lib/features/server_settings_screen.dart:251
  ///
  /// In en, this message translates to:
  /// **'Start: minute'**
  String get message0275;

  /// Original: 'Конец: час'; source: lib/features/server_settings_screen.dart:252
  ///
  /// In en, this message translates to:
  /// **'End: hour'**
  String get message0276;

  /// Original: 'Конец: минута'; source: lib/features/server_settings_screen.dart:253
  ///
  /// In en, this message translates to:
  /// **'End: minute'**
  String get message0277;

  /// Original: 'Учитывать служебный трафик'; source: lib/features/server_settings_screen.dart:254
  ///
  /// In en, this message translates to:
  /// **'Include protocol overhead in limits'**
  String get message0278;

  /// Original: 'Ограничивать локальных пиров'; source: lib/features/server_settings_screen.dart:255
  ///
  /// In en, this message translates to:
  /// **'Limit local peers'**
  String get message0279;

  /// Original: 'Обмен пирами (PeX)'; source: lib/features/server_settings_screen.dart:259
  ///
  /// In en, this message translates to:
  /// **'Peer exchange (PeX)'**
  String get message0280;

  /// Original: 'Обнаружение локальных пиров'; source: lib/features/server_settings_screen.dart:260
  ///
  /// In en, this message translates to:
  /// **'Local peer discovery'**
  String get message0281;

  /// Original: 'Анонимный режим'; source: lib/features/server_settings_screen.dart:261
  ///
  /// In en, this message translates to:
  /// **'Anonymous mode'**
  String get message0282;

  /// Original: 'Очередь торрентов'; source: lib/features/server_settings_screen.dart:262
  ///
  /// In en, this message translates to:
  /// **'Torrent queueing'**
  String get message0283;

  /// Original: 'Активных загрузок'; source: lib/features/server_settings_screen.dart:265
  ///
  /// In en, this message translates to:
  /// **'Active downloads'**
  String get message0284;

  /// Original: 'Активных раздач'; source: lib/features/server_settings_screen.dart:268
  ///
  /// In en, this message translates to:
  /// **'Active uploads'**
  String get message0285;

  /// Original: 'Активных торрентов'; source: lib/features/server_settings_screen.dart:271
  ///
  /// In en, this message translates to:
  /// **'Active torrents'**
  String get message0286;

  /// Original: 'Не учитывать медленные торренты'; source: lib/features/server_settings_screen.dart:276
  ///
  /// In en, this message translates to:
  /// **'Don\'t count slow torrents'**
  String get message0287;

  /// Original: 'Добавлять трекеры автоматически'; source: lib/features/server_settings_screen.dart:280
  ///
  /// In en, this message translates to:
  /// **'Add trackers automatically'**
  String get message0288;

  /// Original: 'Дополнительные трекеры'; source: lib/features/server_settings_screen.dart:282
  ///
  /// In en, this message translates to:
  /// **'Additional trackers'**
  String get message0289;

  /// Original: 'Адрес прослушивания'; source: lib/features/server_settings_screen.dart:285
  ///
  /// In en, this message translates to:
  /// **'Listening address'**
  String get message0290;

  /// Original: 'Порт WebUI'; source: lib/features/server_settings_screen.dart:286
  ///
  /// In en, this message translates to:
  /// **'WebUI port'**
  String get message0291;

  /// Original: 'Имя пользователя'; source: lib/features/server_settings_screen.dart:287
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get message0292;

  /// Original: 'Новый пароль'; source: lib/features/server_settings_screen.dart:288
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get message0293;

  /// Original: 'Авторизация localhost'; source: lib/features/server_settings_screen.dart:290
  ///
  /// In en, this message translates to:
  /// **'Localhost authentication'**
  String get message0294;

  /// Original: 'Защита CSRF'; source: lib/features/server_settings_screen.dart:291
  ///
  /// In en, this message translates to:
  /// **'CSRF protection'**
  String get message0295;

  /// Original: 'Защита от clickjacking'; source: lib/features/server_settings_screen.dart:294
  ///
  /// In en, this message translates to:
  /// **'Clickjacking protection'**
  String get message0296;

  /// Original: 'Время сессии, секунд'; source: lib/features/server_settings_screen.dart:298
  ///
  /// In en, this message translates to:
  /// **'Session timeout, seconds'**
  String get message0297;

  /// Original: 'Получать RSS-ленты'; source: lib/features/server_settings_screen.dart:303
  ///
  /// In en, this message translates to:
  /// **'Enable RSS feeds'**
  String get message0298;

  /// Original: 'Автозагрузка по правилам'; source: lib/features/server_settings_screen.dart:306
  ///
  /// In en, this message translates to:
  /// **'Auto-download by rules'**
  String get message0299;

  /// Original: 'Интервал обновления, минут'; source: lib/features/server_settings_screen.dart:310
  ///
  /// In en, this message translates to:
  /// **'Refresh interval, minutes'**
  String get message0300;

  /// Original: 'Статей в ленте'; source: lib/features/server_settings_screen.dart:315
  ///
  /// In en, this message translates to:
  /// **'Articles per feed'**
  String get message0301;

  /// Original: 'Шаблоны серий'; source: lib/features/server_settings_screen.dart:318
  ///
  /// In en, this message translates to:
  /// **'Episode filters'**
  String get message0302;

  /// Original: 'Все параметры (JSON)'; source: lib/features/server_settings_screen.dart:322
  ///
  /// In en, this message translates to:
  /// **'All settings (JSON)'**
  String get message0303;

  /// Original: 'Расширенные параметры и опции вашей версии сервера'; source: lib/features/server_settings_screen.dart:324
  ///
  /// In en, this message translates to:
  /// **'Advanced settings and options for your server version'**
  String get message0304;

  /// Original: 'Не удалось выполнить действие'; source: lib/features/torrent_tools_screen.dart:36
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t complete the action'**
  String get message0305;

  /// Original: 'Изменения применены'; source: lib/features/torrent_tools_screen.dart:45
  ///
  /// In en, this message translates to:
  /// **'Changes applied'**
  String get message0306;

  /// Original: 'Управление торрентом'; source: lib/features/torrent_tools_screen.dart:50
  ///
  /// In en, this message translates to:
  /// **'Manage torrent'**
  String get message0307;

  /// Original: 'Организация'; source: lib/features/torrent_tools_screen.dart:65
  ///
  /// In en, this message translates to:
  /// **'Organize'**
  String get message0308;

  /// Original: 'Имя торрента'; source: lib/features/torrent_tools_screen.dart:68
  ///
  /// In en, this message translates to:
  /// **'Torrent name'**
  String get message0309;

  /// Original: 'Переименовать торрент'; source: lib/features/torrent_tools_screen.dart:70
  ///
  /// In en, this message translates to:
  /// **'Rename torrent'**
  String get message0310;

  /// Original: 'Переместить файлы'; source: lib/features/torrent_tools_screen.dart:80
  ///
  /// In en, this message translates to:
  /// **'Move files'**
  String get message0311;

  /// Original: 'Новый путь на сервере'; source: lib/features/torrent_tools_screen.dart:82
  ///
  /// In en, this message translates to:
  /// **'New server path'**
  String get message0312;

  /// Original: 'Полный путь'; source: lib/features/torrent_tools_screen.dart:85
  ///
  /// In en, this message translates to:
  /// **'Full path'**
  String get message0313;

  /// Original: 'Перемещение выполняет qBittorrent на сервере'; source: lib/features/torrent_tools_screen.dart:88
  ///
  /// In en, this message translates to:
  /// **'qBittorrent moves the files on the server'**
  String get message0314;

  /// Original: 'Добавить метки'; source: lib/features/torrent_tools_screen.dart:93
  ///
  /// In en, this message translates to:
  /// **'Add tags'**
  String get message0315;

  /// Original: 'Метки через запятую'; source: lib/features/torrent_tools_screen.dart:98
  ///
  /// In en, this message translates to:
  /// **'Tags, comma-separated'**
  String get message0316;

  /// Original: 'Снять метки'; source: lib/features/torrent_tools_screen.dart:104
  ///
  /// In en, this message translates to:
  /// **'Remove tags'**
  String get message0317;

  /// Original: 'Скорость и раздача'; source: lib/features/torrent_tools_screen.dart:114
  ///
  /// In en, this message translates to:
  /// **'Speed and seeding'**
  String get message0318;

  /// Original: 'Лимиты скорости'; source: lib/features/torrent_tools_screen.dart:115
  ///
  /// In en, this message translates to:
  /// **'Speed limits'**
  String get message0319;

  /// Original: 'Условия окончания раздачи'; source: lib/features/torrent_tools_screen.dart:116
  ///
  /// In en, this message translates to:
  /// **'Seeding limits'**
  String get message0320;

  /// Original: 'Принудительный запуск'; source: lib/features/torrent_tools_screen.dart:119
  ///
  /// In en, this message translates to:
  /// **'Force start'**
  String get message0321;

  /// Original: 'Суперсидирование'; source: lib/features/torrent_tools_screen.dart:124
  ///
  /// In en, this message translates to:
  /// **'Super seeding'**
  String get message0322;

  /// Original: 'Переключить последовательную загрузку'; source: lib/features/torrent_tools_screen.dart:129
  ///
  /// In en, this message translates to:
  /// **'Toggle sequential download'**
  String get message0323;

  /// Original: 'Переключить приоритет первого и последнего фрагментов'; source: lib/features/torrent_tools_screen.dart:134
  ///
  /// In en, this message translates to:
  /// **'Toggle first/last piece priority'**
  String get message0324;

  /// Original: 'Перепроверить файлы'; source: lib/features/torrent_tools_screen.dart:137
  ///
  /// In en, this message translates to:
  /// **'Force recheck'**
  String get message0325;

  /// Original: 'Перепроверить файлы?'; source: lib/features/torrent_tools_screen.dart:140
  ///
  /// In en, this message translates to:
  /// **'Recheck files?'**
  String get message0326;

  /// Original: 'Проверка может занять время и временно приостановить передачу.'; source: lib/features/torrent_tools_screen.dart:141
  ///
  /// In en, this message translates to:
  /// **'Rechecking may take a while and temporarily pause transfers.'**
  String get message0327;

  /// Original: 'Обновить объявления трекерам'; source: lib/features/torrent_tools_screen.dart:148
  ///
  /// In en, this message translates to:
  /// **'Reannounce to trackers'**
  String get message0328;

  /// Original: 'Очередь'; source: lib/features/torrent_tools_screen.dart:152
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get message0329;

  /// Original: 'В начало очереди'; source: lib/features/torrent_tools_screen.dart:154
  ///
  /// In en, this message translates to:
  /// **'Move to top'**
  String get message0330;

  /// Original: 'Поднять выше'; source: lib/features/torrent_tools_screen.dart:155
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get message0331;

  /// Original: 'Опустить ниже'; source: lib/features/torrent_tools_screen.dart:156
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get message0332;

  /// Original: 'В конец очереди'; source: lib/features/torrent_tools_screen.dart:157
  ///
  /// In en, this message translates to:
  /// **'Move to bottom'**
  String get message0333;

  /// Original: 'Содержимое и соединения'; source: lib/features/torrent_tools_screen.dart:165
  ///
  /// In en, this message translates to:
  /// **'Content and connections'**
  String get message0334;

  /// Original: 'Экспортировать .torrent'; source: lib/features/torrent_tools_screen.dart:168
  ///
  /// In en, this message translates to:
  /// **'Export .torrent'**
  String get message0335;

  /// Original: 'Файлы и приоритеты'; source: lib/features/torrent_tools_screen.dart:171
  ///
  /// In en, this message translates to:
  /// **'Files and priorities'**
  String get message0336;

  /// Original: 'Переименовать папку'; source: lib/features/torrent_tools_screen.dart:174
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get message0337;

  /// Original: 'Текущий путь внутри торрента'; source: lib/features/torrent_tools_screen.dart:182
  ///
  /// In en, this message translates to:
  /// **'Current path within torrent'**
  String get message0338;

  /// Original: 'Новый путь внутри торрента'; source: lib/features/torrent_tools_screen.dart:187
  ///
  /// In en, this message translates to:
  /// **'New path within torrent'**
  String get message0339;

  /// Original: 'Трекеры'; source: lib/features/torrent_tools_screen.dart:197
  ///
  /// In en, this message translates to:
  /// **'Trackers'**
  String get message0340;

  /// Original: 'Пиры'; source: lib/features/torrent_tools_screen.dart:198
  ///
  /// In en, this message translates to:
  /// **'Peers'**
  String get message0341;

  /// Original: 'HTTP-источники'; source: lib/features/torrent_tools_screen.dart:199
  ///
  /// In en, this message translates to:
  /// **'HTTP sources'**
  String get message0342;

  /// Original: 'Состояние фрагментов'; source: lib/features/torrent_tools_screen.dart:200
  ///
  /// In en, this message translates to:
  /// **'Piece states'**
  String get message0343;

  /// Original: 'Без категории'; source: lib/features/torrent_tools_screen.dart:267
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get message0344;

  /// Original: 'Загрузка, КиБ/с'; source: lib/features/torrent_tools_screen.dart:292
  ///
  /// In en, this message translates to:
  /// **'Download, KiB/s'**
  String get message0345;

  /// Original: 'Отдача, КиБ/с'; source: lib/features/torrent_tools_screen.dart:299
  ///
  /// In en, this message translates to:
  /// **'Upload, KiB/s'**
  String get message0346;

  /// Original: '0 — без ограничения. 1 КиБ/с = 1024 байта/с.'; source: lib/features/torrent_tools_screen.dart:304
  ///
  /// In en, this message translates to:
  /// **'0 = no limit. 1 KiB/s = 1024 bytes/s.'**
  String get message0347;

  /// Original: 'Рейтинг'; source: lib/features/torrent_tools_screen.dart:323
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get message0348;

  /// Original: 'Укажите число'; source: lib/features/torrent_tools_screen.dart:326
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get message0349;

  /// Original: 'Время раздачи, минуты'; source: lib/features/torrent_tools_screen.dart:330
  ///
  /// In en, this message translates to:
  /// **'Seeding time, minutes'**
  String get message0350;

  /// Original: 'Укажите целое число'; source: lib/features/torrent_tools_screen.dart:334
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number'**
  String get message0351;

  /// Original: 'Время неактивной раздачи, минуты'; source: lib/features/torrent_tools_screen.dart:338
  ///
  /// In en, this message translates to:
  /// **'Inactive seeding time, minutes'**
  String get message0352;

  /// Original: '-2 — использовать настройки сервера, -1 — без ограничения.'; source: lib/features/torrent_tools_screen.dart:345
  ///
  /// In en, this message translates to:
  /// **'-2 = use server settings, -1 = no limit.'**
  String get message0353;

  /// Original: 'Включить'; source: lib/features/torrent_tools_screen.dart:358
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get message0354;

  /// Original: 'Выключить'; source: lib/features/torrent_tools_screen.dart:362
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get message0355;

  /// Original: 'Файлы'; source: lib/features/torrent_tools_screen.dart:389
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get message0356;

  /// Original: '${humanBytes(file['size'] is num ? file['size'] as num : 0)} · приоритет ${file['priority'] ?? 1}'; source: lib/features/torrent_tools_screen.dart:397; expressions: ["humanBytes(file['size'] is num ? file['size'] as num : 0)", "file['priority'] ?? 1"]
  ///
  /// In en, this message translates to:
  /// **'{arg1} · priority {arg2}'**
  String message0357(String arg1, String arg2);

  /// Original: 'Переименовать файл'; source: lib/features/torrent_tools_screen.dart:405
  ///
  /// In en, this message translates to:
  /// **'Rename file'**
  String get message0358;

  /// Original: 'Изменения применены. Откройте список заново для обновления.'; source: lib/features/torrent_tools_screen.dart:433
  ///
  /// In en, this message translates to:
  /// **'Changes applied. Reopen the list to refresh.'**
  String get message0359;

  /// Original: 'Действие не выполнено'; source: lib/features/torrent_tools_screen.dart:441
  ///
  /// In en, this message translates to:
  /// **'Action failed'**
  String get message0360;

  /// Original: 'Не скачивать'; source: lib/features/torrent_tools_screen.dart:448
  ///
  /// In en, this message translates to:
  /// **'Do not download'**
  String get message0361;

  /// Original: 'Обычный приоритет'; source: lib/features/torrent_tools_screen.dart:449
  ///
  /// In en, this message translates to:
  /// **'Normal priority'**
  String get message0362;

  /// Original: 'Высокий приоритет'; source: lib/features/torrent_tools_screen.dart:450
  ///
  /// In en, this message translates to:
  /// **'High priority'**
  String get message0363;

  /// Original: 'Максимальный приоритет'; source: lib/features/torrent_tools_screen.dart:453
  ///
  /// In en, this message translates to:
  /// **'Maximum priority'**
  String get message0364;

  /// Original: 'Изменить трекер'; source: lib/features/torrent_tools_screen.dart:487
  ///
  /// In en, this message translates to:
  /// **'Edit tracker'**
  String get message0365;

  /// Original: 'Новый URL'; source: lib/features/torrent_tools_screen.dart:491
  ///
  /// In en, this message translates to:
  /// **'New URL'**
  String get message0366;

  /// Original: 'Удалить трекер?'; source: lib/features/torrent_tools_screen.dart:506
  ///
  /// In en, this message translates to:
  /// **'Remove tracker?'**
  String get message0367;

  /// Original: 'Не удалось изменить трекер'; source: lib/features/torrent_tools_screen.dart:518
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t edit tracker'**
  String get message0368;

  /// Original: 'Удалить'; source: lib/features/torrent_tools_screen.dart:526
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get message0369;

  /// Original: 'Добавить трекеры'; source: lib/features/torrent_tools_screen.dart:534
  ///
  /// In en, this message translates to:
  /// **'Add trackers'**
  String get message0370;

  /// Original: 'URL, каждый с новой строки'; source: lib/features/torrent_tools_screen.dart:541
  ///
  /// In en, this message translates to:
  /// **'URLs, one per line'**
  String get message0371;

  /// Original: 'Не удалось добавить трекеры'; source: lib/features/torrent_tools_screen.dart:552
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add trackers'**
  String get message0372;

  /// Original: 'Нет подключённых пиров'; source: lib/features/torrent_tools_screen.dart:576
  ///
  /// In en, this message translates to:
  /// **'No connected peers'**
  String get message0373;

  /// Original: '${peer['client'] ?? ''} · ↓ ${humanBytes(peer['dl_speed'] is num ? peer['dl_speed'] as num : 0)}/с'; source: lib/features/torrent_tools_screen.dart:581; expressions: ["peer['client'] ?? ''", "humanBytes(peer['dl_speed'] is num ? peer['dl_speed'] as num : 0)"]
  ///
  /// In en, this message translates to:
  /// **'{arg1} · ↓ {arg2}/s'**
  String message0374(String arg1, String arg2);

  /// Original: 'Добавить пиров'; source: lib/features/torrent_tools_screen.dart:588
  ///
  /// In en, this message translates to:
  /// **'Add peers'**
  String get message0375;

  /// Original: 'IP:порт, разделитель |'; source: lib/features/torrent_tools_screen.dart:595
  ///
  /// In en, this message translates to:
  /// **'IP:port, separated by |'**
  String get message0376;

  /// Original: 'Не удалось добавить пиров'; source: lib/features/torrent_tools_screen.dart:605
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add peers'**
  String get message0377;

  /// Original: 'Фрагменты: ${states.length}'; source: lib/features/torrent_tools_screen.dart:627; expressions: ["states.length"]
  ///
  /// In en, this message translates to:
  /// **'{arg1, plural, one {{arg1} piece} other {{arg1} pieces}}'**
  String message0378(int arg1);

  /// Original: 'Серый — нет, синий — загружается, зелёный — готов. Показаны первые 4096 фрагментов.'; source: lib/features/torrent_tools_screen.dart:633
  ///
  /// In en, this message translates to:
  /// **'Grey: missing, blue: downloading, green: done. Showing the first 4096 pieces.'**
  String get message0379;

  /// Original: 'Фрагмент $i'; source: lib/features/torrent_tools_screen.dart:646; expressions: ["i"]
  ///
  /// In en, this message translates to:
  /// **'Piece {arg1}'**
  String message0380(String arg1);

  /// Original: 'Экспорт выполнен'; source: lib/features/torrent_tools_screen.dart:667
  ///
  /// In en, this message translates to:
  /// **'Export complete'**
  String get message0381;

  /// Original: 'Экспорт отменён'; source: lib/features/torrent_tools_screen.dart:667
  ///
  /// In en, this message translates to:
  /// **'Export cancelled'**
  String get message0382;

  /// Original: 'Укажите URL'; source: lib/features/torrent_tools_screen.dart:681
  ///
  /// In en, this message translates to:
  /// **'Enter a URL'**
  String get message0383;

  /// Original: 'URL не должен содержать пробелы, управляющие символы и «|»'; source: lib/features/torrent_tools_screen.dart:683
  ///
  /// In en, this message translates to:
  /// **'URL must not contain spaces, control characters, or \"|\"'**
  String get message0384;

  /// Original: 'Укажите адрес http:// или https:// с именем узла'; source: lib/features/torrent_tools_screen.dart:689
  ///
  /// In en, this message translates to:
  /// **'Enter an http:// or https:// address with a host name'**
  String get message0385;

  /// Original: 'Укажите хотя бы один URL'; source: lib/features/torrent_tools_screen.dart:697
  ///
  /// In en, this message translates to:
  /// **'Enter at least one URL'**
  String get message0386;

  /// Original: 'Сервер не поддерживает изменение HTTP-источников. '; source: lib/features/torrent_tools_screen.dart:716
  ///
  /// In en, this message translates to:
  /// **'The server does not support changing HTTP sources. '**
  String get message0387;

  /// Original: 'Нужен qBittorrent 5.2 или новее; доступен только просмотр.'; source: lib/features/torrent_tools_screen.dart:717
  ///
  /// In en, this message translates to:
  /// **'Requires qBittorrent 5.2 or later; view-only.'**
  String get message0388;

  /// Original: 'Не удалось загрузить HTTP-источники'; source: lib/features/torrent_tools_screen.dart:769
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load HTTP sources'**
  String get message0389;

  /// Original: 'Добавить HTTP-источники'; source: lib/features/torrent_tools_screen.dart:807
  ///
  /// In en, this message translates to:
  /// **'Add HTTP sources'**
  String get message0390;

  /// Original: 'Адреса передаёт серверу qBittorrent; приложение не обращается к ним напрямую.'; source: lib/features/torrent_tools_screen.dart:817
  ///
  /// In en, this message translates to:
  /// **'Addresses are passed to the qBittorrent server; the app does not connect to them directly.'**
  String get message0391;

  /// Original: 'Не удалось добавить HTTP-источники'; source: lib/features/torrent_tools_screen.dart:822
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add HTTP sources'**
  String get message0392;

  /// Original: 'Изменить HTTP-источник'; source: lib/features/torrent_tools_screen.dart:826
  ///
  /// In en, this message translates to:
  /// **'Edit HTTP source'**
  String get message0393;

  /// Original: 'Адрес не изменился'; source: lib/features/torrent_tools_screen.dart:838
  ///
  /// In en, this message translates to:
  /// **'Address unchanged'**
  String get message0394;

  /// Original: 'Не удалось изменить HTTP-источник'; source: lib/features/torrent_tools_screen.dart:844
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t edit HTTP source'**
  String get message0395;

  /// Original: 'Удалить HTTP-источник?'; source: lib/features/torrent_tools_screen.dart:850
  ///
  /// In en, this message translates to:
  /// **'Remove HTTP source?'**
  String get message0396;

  /// Original: 'Не удалось удалить HTTP-источник'; source: lib/features/torrent_tools_screen.dart:856
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t remove HTTP source'**
  String get message0397;

  /// Original: 'Добавить источники'; source: lib/features/torrent_tools_screen.dart:873
  ///
  /// In en, this message translates to:
  /// **'Add sources'**
  String get message0398;

  /// Original: 'Изменение HTTP-источников требует qBittorrent 5.2 или новее. '; source: lib/features/torrent_tools_screen.dart:886
  ///
  /// In en, this message translates to:
  /// **'Editing HTTP sources requires qBittorrent 5.2 or later. '**
  String get message0399;

  /// Original: 'Более ранний сервер может отклонить изменения.'; source: lib/features/torrent_tools_screen.dart:887
  ///
  /// In en, this message translates to:
  /// **'An older server may reject the changes.'**
  String get message0400;

  /// Original: 'Повторить'; source: lib/features/torrent_tools_screen.dart:904
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get message0401;

  /// Original: 'HTTP-источников нет'; source: lib/features/torrent_tools_screen.dart:914
  ///
  /// In en, this message translates to:
  /// **'No HTTP sources'**
  String get message0402;

  /// Original: 'Не удалось инициализировать защищённое хранилище.'; source: lib/main.dart:109
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t initialize secure storage.'**
  String get message0403;

  /// Original: 'Добавить входящий торрент?'; source: lib/main.dart:205
  ///
  /// In en, this message translates to:
  /// **'Add incoming torrent?'**
  String get message0404;

  /// Original: 'Сервер: ${target.name}'; source: lib/main.dart:213; expressions: ["target.name"]
  ///
  /// In en, this message translates to:
  /// **'Server: {arg1}'**
  String message0405(String arg1);

  /// Original: 'Один .torrent-файл'; source: lib/main.dart:215
  ///
  /// In en, this message translates to:
  /// **'One .torrent file'**
  String get message0406;

  /// Original: 'Одна ссылка'; source: lib/main.dart:215
  ///
  /// In en, this message translates to:
  /// **'One link'**
  String get message0407;

  /// Original: 'Файл .torrent'; source: lib/main.dart:1
  ///
  /// In en, this message translates to:
  /// **'.torrent file'**
  String get message0408;

  /// Original: 'Не удалось удалить локальные данные.'; source: lib/main.dart:272
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete local data.'**
  String get message0409;

  /// Original: 'Домашний qB заблокирован'; source: lib/main.dart:317
  ///
  /// In en, this message translates to:
  /// **'Home qB locked'**
  String get message0410;

  /// Original: 'Открыть'; source: lib/main.dart:324
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get message0411;

  /// Original: 'Сбросить локальные данные'; source: lib/main.dart:330
  ///
  /// In en, this message translates to:
  /// **'Reset local data'**
  String get message0412;

  /// Original: 'Будут удалены профили, пароли и сертификаты с этого устройства. Торренты на сервере сохранятся.'; source: lib/main.dart:336
  ///
  /// In en, this message translates to:
  /// **'Profiles, passwords, and certificates will be deleted from this device. Torrents on the server will be kept.'**
  String get message0413;

  /// Original: 'Удалить локальные данные'; source: lib/main.dart:347
  ///
  /// In en, this message translates to:
  /// **'Delete local data'**
  String get message0414;

  /// Original: 'Device settings could not be read from secure storage.'; source: lib/services/device_services.dart:95
  ///
  /// In en, this message translates to:
  /// **'Device settings could not be read from secure storage.'**
  String get message0415;

  /// Original: 'Background polling could not be scheduled on this device.'; source: lib/services/device_services.dart:106
  ///
  /// In en, this message translates to:
  /// **'Background polling could not be scheduled on this device.'**
  String get message0416;

  /// Original: 'Background polling is available on Android and iOS. Desktop notifications require the app to remain open.'; source: lib/services/device_services.dart:109
  ///
  /// In en, this message translates to:
  /// **'Background polling is available on Android and iOS. Desktop notifications require the app to remain open.'**
  String get message0417;

  /// Original: 'Notifications are not configured on this platform.'; source: lib/services/device_services.dart:118
  ///
  /// In en, this message translates to:
  /// **'Notifications are not configured on this platform.'**
  String get message0418;

  /// Original: 'System notifications are unavailable.'; source: lib/services/device_services.dart:144
  ///
  /// In en, this message translates to:
  /// **'System notifications are unavailable.'**
  String get message0419;

  /// Original: 'System notifications could not be initialized.'; source: lib/services/device_services.dart:148
  ///
  /// In en, this message translates to:
  /// **'System notifications could not be initialized.'**
  String get message0420;

  /// Original: 'Android may delay polling because of battery, network, or background restrictions.'; source: lib/services/device_services.dart:167
  ///
  /// In en, this message translates to:
  /// **'Android may delay polling because of battery, network, or background restrictions.'**
  String get message0421;

  /// Original: 'Choose a polling interval between 15 and 1440 minutes.'; source: lib/services/device_services.dart:173
  ///
  /// In en, this message translates to:
  /// **'Choose a polling interval between 15 and 1440 minutes.'**
  String get message0422;

  /// Original: 'The new interval was saved, but the background schedule could not be updated.'; source: lib/services/device_services.dart:185
  ///
  /// In en, this message translates to:
  /// **'The new interval was saved, but the background schedule could not be updated.'**
  String get message0423;

  /// Original: 'Notifications are unavailable.'; source: lib/services/device_services.dart:215
  ///
  /// In en, this message translates to:
  /// **'Notifications are unavailable.'**
  String get message0424;

  /// Original: 'Notification permission was not granted.'; source: lib/services/device_services.dart:246
  ///
  /// In en, this message translates to:
  /// **'Notification permission was not granted.'**
  String get message0425;

  /// Original: 'The background schedule could not be updated. Foreground notification checks still work.'; source: lib/services/device_services.dart:266
  ///
  /// In en, this message translates to:
  /// **'The background schedule could not be updated. Foreground notification checks still work.'**
  String get message0426;

  /// Original: 'Unlock Home qB Remote'; source: lib/services/device_services.dart:283
  ///
  /// In en, this message translates to:
  /// **'Unlock Home qB Remote'**
  String get message0427;

  /// Original: 'Device authentication was not completed.'; source: lib/services/device_services.dart:300
  ///
  /// In en, this message translates to:
  /// **'Device authentication was not completed.'**
  String get message0428;

  /// Original: 'Не удалось включить защиту снимков экрана.'; source: lib/services/device_services.dart:316
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t enable screenshot protection.'**
  String get message0429;

  /// Original: 'Не удалось удалить системные уведомления.'; source: lib/services/device_services.dart:336
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t remove system notifications.'**
  String get message0430;

  /// Original: 'Не удалось отменить фоновую проверку.'; source: lib/services/device_services.dart:342
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t cancel the background check.'**
  String get message0431;

  /// Original: 'Загрузка завершена'; source: lib/services/device_services.dart:397
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get message0432;

  /// Original: 'Загрузка завершена. Откройте приложение для просмотра.'; source: lib/services/device_services.dart:399
  ///
  /// In en, this message translates to:
  /// **'Download complete. Open the app to view it.'**
  String get message0433;

  /// Original: 'Завершение загрузок'; source: lib/services/device_services.dart:407
  ///
  /// In en, this message translates to:
  /// **'Completed downloads'**
  String get message0434;

  /// Original: 'Завершённые загрузки на ваших серверах qBittorrent'; source: lib/services/device_services.dart:409
  ///
  /// In en, this message translates to:
  /// **'Completed downloads on your qBittorrent servers'**
  String get message0435;

  /// Original: 'Background scan budget exhausted.'; source: lib/services/device_services.dart:510
  ///
  /// In en, this message translates to:
  /// **'Background scan budget exhausted.'**
  String get message0436;

  /// Original: 'Only a local .torrent document can be imported.'; source: lib/services/incoming_document_service.dart:87
  ///
  /// In en, this message translates to:
  /// **'Only a local .torrent document can be imported.'**
  String get message0437;

  /// Original: 'Document import is not supported on this platform.'; source: lib/services/incoming_document_service.dart:92
  ///
  /// In en, this message translates to:
  /// **'Document import is not supported on this platform.'**
  String get message0438;

  /// Original: 'Document import is not available in this build of the app.'; source: lib/services/incoming_document_service.dart:106
  ///
  /// In en, this message translates to:
  /// **'Document import is not available in this build of the app.'**
  String get message0439;

  /// Original: 'The document was rejected by the system.'; source: lib/services/incoming_document_service.dart:116
  ///
  /// In en, this message translates to:
  /// **'The document was rejected by the system.'**
  String get message0440;

  /// Original: 'The torrent document could not be read.'; source: lib/services/incoming_document_service.dart:117
  ///
  /// In en, this message translates to:
  /// **'The torrent document could not be read.'**
  String get message0441;

  /// Original: 'The torrent document is empty.'; source: lib/services/incoming_document_service.dart:129
  ///
  /// In en, this message translates to:
  /// **'The torrent document is empty.'**
  String get message0442;

  /// Original: 'The torrent document is larger than 16 MiB and cannot be imported.'; source: lib/services/incoming_document_service.dart:133
  ///
  /// In en, this message translates to:
  /// **'The torrent document is larger than 16 MiB and cannot be imported.'**
  String get message0443;

  /// Original: 'The document is not a valid .torrent file.'; source: lib/services/incoming_document_service.dart:138
  ///
  /// In en, this message translates to:
  /// **'The document is not a valid .torrent file.'**
  String get message0444;

  /// Original: 'Русский'; source: lib/services/locale_controller.dart:29
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get message0445;

  /// Original: 'Українська'; source: lib/services/locale_controller.dart:30
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get message0446;

  /// Original: 'Unsupported language'; source: lib/services/locale_controller.dart:106
  ///
  /// In en, this message translates to:
  /// **'Unsupported language'**
  String get message0447;

  /// Original: 'Another export is still in progress.'; source: lib/services/torrent_export_service.dart:118
  ///
  /// In en, this message translates to:
  /// **'Another export is still in progress.'**
  String get message0448;

  /// Original: 'Export is not supported on this platform.'; source: lib/services/torrent_export_service.dart:134
  ///
  /// In en, this message translates to:
  /// **'Export is not supported on this platform.'**
  String get message0449;

  /// Original: 'There is no torrent data to export.'; source: lib/services/torrent_export_service.dart:144
  ///
  /// In en, this message translates to:
  /// **'There is no torrent data to export.'**
  String get message0450;

  /// Original: 'The torrent file is larger than 16 MiB and cannot be exported.'; source: lib/services/torrent_export_service.dart:148
  ///
  /// In en, this message translates to:
  /// **'The torrent file is larger than 16 MiB and cannot be exported.'**
  String get message0451;

  /// Original: 'The torrent data is not a valid byte sequence.'; source: lib/services/torrent_export_service.dart:155
  ///
  /// In en, this message translates to:
  /// **'The torrent data is not a valid byte sequence.'**
  String get message0452;

  /// Original: 'Export is not available in this build of the app.'; source: lib/services/torrent_export_service.dart:175
  ///
  /// In en, this message translates to:
  /// **'Export is not available in this build of the app.'**
  String get message0453;

  /// Original: 'The torrent data was rejected by the system.'; source: lib/services/torrent_export_service.dart:188
  ///
  /// In en, this message translates to:
  /// **'The torrent data was rejected by the system.'**
  String get message0454;

  /// Original: 'The torrent file could not be saved.'; source: lib/services/torrent_export_service.dart:189
  ///
  /// In en, this message translates to:
  /// **'The torrent file could not be saved.'**
  String get message0455;

  /// Original: 'The save dialog could not be opened.'; source: lib/services/torrent_export_service.dart:198
  ///
  /// In en, this message translates to:
  /// **'The save dialog could not be opened.'**
  String get message0456;

  /// Original: 'The torrent file could not be written to the chosen location.'; source: lib/services/torrent_export_service.dart:206
  ///
  /// In en, this message translates to:
  /// **'The torrent file could not be written to the chosen location.'**
  String get message0457;

  /// Original: 'Введите целое число от 0'; source: lib/ui/add_torrent_dialog.dart:114
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number from 0'**
  String get message0458;

  /// Original: 'Новая загрузка'; source: lib/ui/add_torrent_dialog.dart:123
  ///
  /// In en, this message translates to:
  /// **'New download'**
  String get message0459;

  /// Original: 'Magnet-ссылки или URL'; source: lib/ui/add_torrent_dialog.dart:138
  ///
  /// In en, this message translates to:
  /// **'Magnet links or URLs'**
  String get message0460;

  /// Original: 'Каждая ссылка — с новой строки'; source: lib/ui/add_torrent_dialog.dart:139
  ///
  /// In en, this message translates to:
  /// **'One link per line'**
  String get message0461;

  /// Original: 'Выбрать .torrent-файл'; source: lib/ui/add_torrent_dialog.dart:146
  ///
  /// In en, this message translates to:
  /// **'Choose .torrent file'**
  String get message0462;

  /// Original: 'Параметры загрузки'; source: lib/ui/add_torrent_dialog.dart:150
  ///
  /// In en, this message translates to:
  /// **'Download options'**
  String get message0463;

  /// Original: 'Теги через запятую'; source: lib/ui/add_torrent_dialog.dart:166
  ///
  /// In en, this message translates to:
  /// **'Tags, comma-separated'**
  String get message0464;

  /// Original: 'Новое имя (необязательно)'; source: lib/ui/add_torrent_dialog.dart:188
  ///
  /// In en, this message translates to:
  /// **'New name (optional)'**
  String get message0465;

  /// Original: 'Лимит загрузки, КиБ/с'; source: lib/ui/add_torrent_dialog.dart:191
  ///
  /// In en, this message translates to:
  /// **'Download limit, KiB/s'**
  String get message0466;

  /// Original: '0 — без ограничения; пусто — настройка сервера'; source: lib/ui/add_torrent_dialog.dart:192
  ///
  /// In en, this message translates to:
  /// **'0 — no limit; empty — server setting'**
  String get message0467;

  /// Original: 'Лимит отдачи, КиБ/с'; source: lib/ui/add_torrent_dialog.dart:197
  ///
  /// In en, this message translates to:
  /// **'Upload limit, KiB/s'**
  String get message0468;

  /// Original: 'Структура файлов'; source: lib/ui/add_torrent_dialog.dart:205
  ///
  /// In en, this message translates to:
  /// **'File structure'**
  String get message0469;

  /// Original: 'Как в торренте'; source: lib/ui/add_torrent_dialog.dart:210
  ///
  /// In en, this message translates to:
  /// **'As in torrent'**
  String get message0470;

  /// Original: 'Создать подпапку'; source: lib/ui/add_torrent_dialog.dart:214
  ///
  /// In en, this message translates to:
  /// **'Create subfolder'**
  String get message0471;

  /// Original: 'Без подпапки'; source: lib/ui/add_torrent_dialog.dart:218
  ///
  /// In en, this message translates to:
  /// **'No subfolder'**
  String get message0472;

  /// Original: 'Добавить остановленным'; source: lib/ui/add_torrent_dialog.dart:226
  ///
  /// In en, this message translates to:
  /// **'Add paused'**
  String get message0473;

  /// Original: 'Последовательная загрузка'; source: lib/ui/add_torrent_dialog.dart:238
  ///
  /// In en, this message translates to:
  /// **'Sequential download'**
  String get message0474;

  /// Original: 'Сначала начало и конец'; source: lib/ui/add_torrent_dialog.dart:244
  ///
  /// In en, this message translates to:
  /// **'First and last pieces first'**
  String get message0475;

  /// Original: 'Пароль PKCS#12'; source: lib/ui/home_screen.dart:39
  ///
  /// In en, this message translates to:
  /// **'PKCS#12 password'**
  String get message0476;

  /// Original: 'Пароль контейнера'; source: lib/ui/home_screen.dart:45
  ///
  /// In en, this message translates to:
  /// **'Container password'**
  String get message0477;

  /// Original: 'Импортировать'; source: lib/ui/home_screen.dart:54
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get message0478;

  /// Original: 'Домашний qB'; source: lib/ui/home_screen.dart:123
  ///
  /// In en, this message translates to:
  /// **'Home qB'**
  String get message0479;

  /// Original: 'Управление серверами'; source: lib/ui/home_screen.dart:152
  ///
  /// In en, this message translates to:
  /// **'Manage servers'**
  String get message0480;

  /// Original: 'Настройки приложения'; source: lib/ui/home_screen.dart:157
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get message0481;

  /// Original: 'ВАШЕ ПОДКЛЮЧЕНИЕ'; source: lib/ui/home_screen.dart:213
  ///
  /// In en, this message translates to:
  /// **'YOUR CONNECTION'**
  String get message0482;

  /// Original: 'Сервер не выбран'; source: lib/ui/home_screen.dart:243
  ///
  /// In en, this message translates to:
  /// **'No server selected'**
  String get message0483;

  /// Original: 'Серверы'; source: lib/ui/home_screen.dart:248
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get message0484;

  /// Original: 'RSS, поиск, настройки'; source: lib/ui/home_screen.dart:254
  ///
  /// In en, this message translates to:
  /// **'RSS, search, settings'**
  String get message0485;

  /// Original: 'Загрузка'; source: lib/ui/home_screen.dart:271
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get message0486;

  /// Original: 'Раздача'; source: lib/ui/home_screen.dart:272
  ///
  /// In en, this message translates to:
  /// **'Seeding'**
  String get message0487;

  /// Original: 'Пауза'; source: lib/ui/home_screen.dart:273
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get message0488;

  /// Original: 'Ошибки'; source: lib/ui/home_screen.dart:274
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get message0489;

  /// Original: 'Все торренты'; source: lib/ui/home_screen.dart:287
  ///
  /// In en, this message translates to:
  /// **'All torrents'**
  String get message0490;

  /// Original: 'Только ваши серверы.\nБез рекламы и телеметрии.'; source: lib/ui/home_screen.dart:305
  ///
  /// In en, this message translates to:
  /// **'Only your servers.\nNo ads or telemetry.'**
  String get message0491;

  /// Original: 'Ваши загрузки — под рукой'; source: lib/ui/home_screen.dart:322
  ///
  /// In en, this message translates to:
  /// **'Your downloads, at your fingertips'**
  String get message0492;

  /// Original: 'Подключите домашний qBittorrent через Web UI.\nАдрес сервера и настройки хранятся на этом устройстве.'; source: lib/ui/home_screen.dart:323
  ///
  /// In en, this message translates to:
  /// **'Connect your home qBittorrent via Web UI.\nThe server address and settings are stored on this device.'**
  String get message0493;

  /// Original: 'Подключить сервер'; source: lib/ui/home_screen.dart:327
  ///
  /// In en, this message translates to:
  /// **'Connect server'**
  String get message0494;

  /// Original: 'Обзор загрузок'; source: lib/ui/home_screen.dart:374
  ///
  /// In en, this message translates to:
  /// **'Browse downloads'**
  String get message0495;

  /// Original: 'Текущий сервер'; source: lib/ui/home_screen.dart:382
  ///
  /// In en, this message translates to:
  /// **'Current server'**
  String get message0496;

  /// Original: '${_bytes(download)}/с'; source: lib/ui/home_screen.dart:424; expressions: ["_bytes(download)"]
  ///
  /// In en, this message translates to:
  /// **'{arg1}/s'**
  String message0497(String arg1);

  /// Original: '${_bytes(upload)}/с'; source: lib/ui/home_screen.dart:433; expressions: ["_bytes(upload)"]
  ///
  /// In en, this message translates to:
  /// **'{arg1}/s'**
  String message0498(String arg1);

  /// Original: 'Торренты'; source: lib/ui/home_screen.dart:441
  ///
  /// In en, this message translates to:
  /// **'Torrents'**
  String get message0499;

  /// Original: 'Найти торрент по имени'; source: lib/ui/home_screen.dart:454
  ///
  /// In en, this message translates to:
  /// **'Find torrent by name'**
  String get message0500;

  /// Original: 'Выбрано: ${_selected.length}'; source: lib/ui/home_screen.dart:511; expressions: ["_selected.length"]
  ///
  /// In en, this message translates to:
  /// **'Selected: {arg1}'**
  String message0501(String arg1);

  /// Original: 'Продолжить выбранные'; source: lib/ui/home_screen.dart:516
  ///
  /// In en, this message translates to:
  /// **'Resume selected'**
  String get message0502;

  /// Original: 'Приостановить выбранные'; source: lib/ui/home_screen.dart:528
  ///
  /// In en, this message translates to:
  /// **'Pause selected'**
  String get message0503;

  /// Original: 'Удалить выбранные'; source: lib/ui/home_screen.dart:540
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get message0504;

  /// Original: 'Снять выделение'; source: lib/ui/home_screen.dart:547
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get message0505;

  /// Original: 'Ничего не найдено'; source: lib/ui/home_screen.dart:565
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get message0506;

  /// Original: 'Пока нет торрентов'; source: lib/ui/home_screen.dart:566
  ///
  /// In en, this message translates to:
  /// **'No torrents yet'**
  String get message0507;

  /// Original: 'Добавьте magnet-ссылку, URL или .torrent-файл.'; source: lib/ui/home_screen.dart:567
  ///
  /// In en, this message translates to:
  /// **'Add a magnet link, URL, or .torrent file.'**
  String get message0508;

  /// Original: 'Продолжить'; source: lib/ui/home_screen.dart:676
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get message0509;

  /// Original: 'Приостановить'; source: lib/ui/home_screen.dart:676
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get message0510;

  /// Original: 'Действия'; source: lib/ui/home_screen.dart:690
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get message0511;

  /// Original: 'Подробнее'; source: lib/ui/home_screen.dart:702
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get message0512;

  /// Original: 'Удалить…'; source: lib/ui/home_screen.dart:707
  ///
  /// In en, this message translates to:
  /// **'Delete…'**
  String get message0513;

  /// Original: '↓ ${_bytes(torrent.dlspeed)}/с'; source: lib/ui/home_screen.dart:741; expressions: ["_bytes(torrent.dlspeed)"]
  ///
  /// In en, this message translates to:
  /// **'↓ {arg1}/s'**
  String message0514(String arg1);

  /// Original: '↑ ${_bytes(torrent.upspeed)}/с'; source: lib/ui/home_screen.dart:760; expressions: ["_bytes(torrent.upspeed)"]
  ///
  /// In en, this message translates to:
  /// **'↑ {arg1}/s'**
  String message0515(String arg1);

  /// Original: 'Не удалось выполнить действие. Проверьте подключение к серверу.'; source: lib/ui/home_screen.dart:842
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t complete the action. Check your server connection.'**
  String get message0516;

  /// Original: 'Мои серверы'; source: lib/ui/home_screen.dart:867
  ///
  /// In en, this message translates to:
  /// **'My servers'**
  String get message0517;

  /// Original: 'Настройки сервера'; source: lib/ui/home_screen.dart:885
  ///
  /// In en, this message translates to:
  /// **'Server settings'**
  String get message0518;

  /// Original: 'Редактировать'; source: lib/ui/home_screen.dart:891
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get message0519;

  /// Original: 'Удалить профиль'; source: lib/ui/home_screen.dart:895
  ///
  /// In en, this message translates to:
  /// **'Delete profile'**
  String get message0520;

  /// Original: 'Добавить сервер'; source: lib/ui/home_screen.dart:904
  ///
  /// In en, this message translates to:
  /// **'Add server'**
  String get message0521;

  /// Original: 'Удалить профиль?'; source: lib/ui/home_screen.dart:929
  ///
  /// In en, this message translates to:
  /// **'Delete profile?'**
  String get message0522;

  /// Original: 'Профиль «${profile.name}» будет удалён с этого устройства. Торренты на сервере сохранятся.'; source: lib/ui/home_screen.dart:931; expressions: ["profile.name"]
  ///
  /// In en, this message translates to:
  /// **'Profile “{arg1}” will be removed from this device. Torrents on the server will be kept.'**
  String message0523(String arg1);

  /// Original: 'Использовать локальный HTTP?'; source: lib/ui/home_screen.dart:962
  ///
  /// In en, this message translates to:
  /// **'Use local HTTP?'**
  String get message0524;

  /// Original: 'SSID не подтверждает подлинность сети. В другой сети с таким же именем пароль может попасть к постороннему серверу. Для защиты используйте HTTPS с проверкой сертификата или VPN.'; source: lib/ui/home_screen.dart:963
  ///
  /// In en, this message translates to:
  /// **'SSID does not verify the network\'s identity. On another network with the same name, your password could reach an unauthorized server. For protection, use HTTPS with certificate verification or a VPN.'**
  String get message0525;

  /// Original: 'Выберите .torrent-файл размером до 16 МБ.'; source: lib/ui/home_screen.dart:991
  ///
  /// In en, this message translates to:
  /// **'Choose a .torrent file up to 16 MB.'**
  String get message0526;

  /// Original: 'Не удалось открыть выбранный файл.'; source: lib/ui/home_screen.dart:1008
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the selected file.'**
  String get message0527;

  /// Original: 'Удалить торрент?'; source: lib/ui/home_screen.dart:1023
  ///
  /// In en, this message translates to:
  /// **'Delete torrent?'**
  String get message0528;

  /// Original: 'Удалить торренты (${hashes.length})?'; source: lib/ui/home_screen.dart:1024; expressions: ["hashes.length"]
  ///
  /// In en, this message translates to:
  /// **'{arg1, plural, one {Delete {arg1} torrent?} other {Delete {arg1} torrents?}}'**
  String message0529(int arg1);

  /// Original: 'По умолчанию загруженные файлы останутся на сервере.'; source: lib/ui/home_screen.dart:1030
  ///
  /// In en, this message translates to:
  /// **'By default, downloaded files will stay on the server.'**
  String get message0530;

  /// Original: 'Также удалить файлы с сервера'; source: lib/ui/home_screen.dart:1036
  ///
  /// In en, this message translates to:
  /// **'Also delete files from server'**
  String get message0531;

  /// Original: 'Это действие нельзя отменить'; source: lib/ui/home_screen.dart:1037
  ///
  /// In en, this message translates to:
  /// **'This action can\'t be undone'**
  String get message0532;

  /// Original: 'Домашний сервер'; source: lib/ui/home_screen.dart:1093
  ///
  /// In en, this message translates to:
  /// **'Home server'**
  String get message0533;

  /// Original: 'Не удалось импортировать PKCS#12. Проверьте пароль и файл (до 4 МБ).'; source: lib/ui/home_screen.dart:1173
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t import PKCS#12. Check the password and file (up to 4 MB).'**
  String get message0534;

  /// Original: 'Укажите название'; source: lib/ui/home_screen.dart:1220
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get message0535;

  /// Original: 'Адрес Web UI'; source: lib/ui/home_screen.dart:1228
  ///
  /// In en, this message translates to:
  /// **'Web UI address'**
  String get message0536;

  /// Original: 'HTTP или HTTPS, включая порт и путь'; source: lib/ui/home_screen.dart:1230
  ///
  /// In en, this message translates to:
  /// **'HTTP or HTTPS, including port and path'**
  String get message0537;

  /// Original: 'Укажите полный HTTP(S)-адрес сервера'; source: lib/ui/home_screen.dart:1237
  ///
  /// In en, this message translates to:
  /// **'Enter the full HTTP(S) server address'**
  String get message0538;

  /// Original: 'Уберите пароль, параметры и # из адреса'; source: lib/ui/home_screen.dart:1242
  ///
  /// In en, this message translates to:
  /// **'Remove password, parameters, and # from the address'**
  String get message0539;

  /// Original: 'Пароль'; source: lib/ui/home_screen.dart:1262
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get message0540;

  /// Original: 'Скрыть пароль'; source: lib/ui/home_screen.dart:1264
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get message0541;

  /// Original: 'Показать пароль'; source: lib/ui/home_screen.dart:1264
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get message0542;

  /// Original: 'API-ключ (необязательно)'; source: lib/ui/home_screen.dart:1281
  ///
  /// In en, this message translates to:
  /// **'API key (optional)'**
  String get message0543;

  /// Original: 'qBittorrent 5.2+. При заполнении используется вместо имени и пароля.'; source: lib/ui/home_screen.dart:1282
  ///
  /// In en, this message translates to:
  /// **'qBittorrent 5.2+. If filled in, it\'s used instead of username and password.'**
  String get message0544;

  /// Original: 'API-ключ нельзя сочетать с Basic auth прокси'; source: lib/ui/home_screen.dart:1290
  ///
  /// In en, this message translates to:
  /// **'API key can\'t be combined with a Basic auth proxy'**
  String get message0545;

  /// Original: 'Локальный адрес по Wi-Fi'; source: lib/ui/home_screen.dart:1298
  ///
  /// In en, this message translates to:
  /// **'Local Wi-Fi address'**
  String get message0546;

  /// Original: 'Необязательно. SSID используется только на устройстве для выбора адреса. ОС может запросить разрешение геолокации для чтения имени Wi-Fi; координаты не считываются.'; source: lib/ui/home_screen.dart:1301
  ///
  /// In en, this message translates to:
  /// **'Optional. The SSID is used only on the device to select an address. The OS may request location permission to read the Wi-Fi name; coordinates are not read.'**
  String get message0547;

  /// Original: 'Локальный URL'; source: lib/ui/home_screen.dart:1306
  ///
  /// In en, this message translates to:
  /// **'Local URL'**
  String get message0548;

  /// Original: 'Укажите HTTP(S)-адрес без пароля и параметров'; source: lib/ui/home_screen.dart:1317
  ///
  /// In en, this message translates to:
  /// **'Enter an HTTP(S) address without password or parameters'**
  String get message0549;

  /// Original: 'Домашняя Wi-Fi сеть (SSID)'; source: lib/ui/home_screen.dart:1324
  ///
  /// In en, this message translates to:
  /// **'Home Wi-Fi network (SSID)'**
  String get message0550;

  /// Original: 'SSID недоступен. Можно ввести имя сети вручную.'; source: lib/ui/home_screen.dart:1339
  ///
  /// In en, this message translates to:
  /// **'SSID unavailable. You can enter the network name manually.'**
  String get message0551;

  /// Original: 'Прочитать текущую сеть'; source: lib/ui/home_screen.dart:1346
  ///
  /// In en, this message translates to:
  /// **'Read current network'**
  String get message0552;

  /// Original: 'Прокси и сертификаты'; source: lib/ui/home_screen.dart:1352
  ///
  /// In en, this message translates to:
  /// **'Proxy and certificates'**
  String get message0553;

  /// Original: 'Basic auth для обратного прокси; PEM для HTTPS и клиентского сертификата.'; source: lib/ui/home_screen.dart:1355
  ///
  /// In en, this message translates to:
  /// **'Basic auth for reverse proxy; PEM for HTTPS and client certificate.'**
  String get message0554;

  /// Original: 'Basic auth: имя'; source: lib/ui/home_screen.dart:1362
  ///
  /// In en, this message translates to:
  /// **'Basic auth: username'**
  String get message0555;

  /// Original: 'Basic auth: пароль'; source: lib/ui/home_screen.dart:1370
  ///
  /// In en, this message translates to:
  /// **'Basic auth: password'**
  String get message0556;

  /// Original: 'Собственный CA (PEM)'; source: lib/ui/home_screen.dart:1374
  ///
  /// In en, this message translates to:
  /// **'Custom CA (PEM)'**
  String get message0557;

  /// Original: 'Клиентский сертификат (PEM)'; source: lib/ui/home_screen.dart:1375
  ///
  /// In en, this message translates to:
  /// **'Client certificate (PEM)'**
  String get message0558;

  /// Original: 'Приватный ключ (PEM)'; source: lib/ui/home_screen.dart:1376
  ///
  /// In en, this message translates to:
  /// **'Private key (PEM)'**
  String get message0559;

  /// Original: 'Импортировать PKCS#12 (.p12/.pfx)'; source: lib/ui/home_screen.dart:1381
  ///
  /// In en, this message translates to:
  /// **'Import PKCS#12 (.p12/.pfx)'**
  String get message0560;

  /// Original: 'Пароль приватного ключа'; source: lib/ui/home_screen.dart:1387
  ///
  /// In en, this message translates to:
  /// **'Private key password'**
  String get message0561;

  /// Original: 'Размер PEM-файла должен быть меньше 1 МБ.'; source: lib/ui/home_screen.dart:1459
  ///
  /// In en, this message translates to:
  /// **'PEM file must be smaller than 1 MB.'**
  String get message0562;

  /// Original: 'Не удалось прочитать PEM-файл.'; source: lib/ui/home_screen.dart:1472
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read PEM file.'**
  String get message0563;

  /// Original: 'Импортировать файл'; source: lib/ui/home_screen.dart:1479
  ///
  /// In en, this message translates to:
  /// **'Import file'**
  String get message0564;

  /// Original: 'Действия с торрентом'; source: lib/ui/home_screen.dart:1527
  ///
  /// In en, this message translates to:
  /// **'Torrent actions'**
  String get message0565;

  /// Original: 'Перепроверить'; source: lib/ui/home_screen.dart:1531
  ///
  /// In en, this message translates to:
  /// **'Recheck'**
  String get message0566;

  /// Original: 'Обновить трекеры'; source: lib/ui/home_screen.dart:1534
  ///
  /// In en, this message translates to:
  /// **'Update trackers'**
  String get message0567;

  /// Original: 'Принудительно запустить'; source: lib/ui/home_screen.dart:1538
  ///
  /// In en, this message translates to:
  /// **'Force start'**
  String get message0568;

  /// Original: 'Первый и последний фрагменты'; source: lib/ui/home_screen.dart:1546
  ///
  /// In en, this message translates to:
  /// **'First and last pieces'**
  String get message0569;

  /// Original: 'Не удалось получить сведения о торренте.'; source: lib/ui/home_screen.dart:1570
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load torrent details.'**
  String get message0570;

  /// Original: 'Обзор'; source: lib/ui/home_screen.dart:1589
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get message0571;

  /// Original: 'Список файлов пуст'; source: lib/ui/home_screen.dart:1599
  ///
  /// In en, this message translates to:
  /// **'File list is empty'**
  String get message0572;

  /// Original: 'Файл'; source: lib/ui/home_screen.dart:1
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get message0573;

  /// Original: 'Приоритет файла'; source: lib/ui/home_screen.dart:1622
  ///
  /// In en, this message translates to:
  /// **'File priority'**
  String get message0574;

  /// Original: 'Высокий'; source: lib/ui/home_screen.dart:1641
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get message0575;

  /// Original: 'Максимальный'; source: lib/ui/home_screen.dart:1645
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get message0576;

  /// Original: 'Нет трекеров'; source: lib/ui/home_screen.dart:1653
  ///
  /// In en, this message translates to:
  /// **'No trackers'**
  String get message0577;

  /// Original: 'Трекер'; source: lib/ui/home_screen.dart:1
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get message0578;

  /// Original: 'Не удалось изменить торрент.'; source: lib/ui/home_screen.dart:1694
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t change torrent.'**
  String get message0579;

  /// Original: 'Состояние'; source: lib/ui/home_screen.dart:1748
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get message0580;

  /// Original: 'Размер'; source: lib/ui/home_screen.dart:1749
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get message0581;

  /// Original: 'Готово'; source: lib/ui/home_screen.dart:1750
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get message0582;

  /// Original: 'Загружено'; source: lib/ui/home_screen.dart:1751
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get message0583;

  /// Original: 'Отдано'; source: lib/ui/home_screen.dart:1754
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get message0584;

  /// Original: 'Комментарий'; source: lib/ui/home_screen.dart:1760
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get message0585;

  /// Original: 'Хеш'; source: lib/ui/home_screen.dart:1761
  ///
  /// In en, this message translates to:
  /// **'Hash'**
  String get message0586;

  /// Original: 'КБ'; source: lib/ui/home_screen.dart:1787
  ///
  /// In en, this message translates to:
  /// **'KB'**
  String get message0587;

  /// Original: 'МБ'; source: lib/ui/home_screen.dart:1787
  ///
  /// In en, this message translates to:
  /// **'MB'**
  String get message0588;

  /// Original: 'ГБ'; source: lib/ui/home_screen.dart:1787
  ///
  /// In en, this message translates to:
  /// **'GB'**
  String get message0589;

  /// Original: 'ТБ'; source: lib/ui/home_screen.dart:1787
  ///
  /// In en, this message translates to:
  /// **'TB'**
  String get message0590;

  /// Original: 'Ошибка'; source: lib/ui/home_screen.dart:1816
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get message0591;

  /// Original: 'Проверка'; source: lib/ui/home_screen.dart:1818
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get message0592;

  /// Original: 'Перемещение'; source: lib/ui/home_screen.dart:1819
  ///
  /// In en, this message translates to:
  /// **'Moving'**
  String get message0593;

  /// Original: 'В очереди'; source: lib/ui/home_screen.dart:1820
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get message0594;

  /// Original: 'Метаданные'; source: lib/ui/home_screen.dart:1822
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get message0595;

  /// Original: 'Сервер'; source: lib/ui/home_screen.dart:1828
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get message0596;

  /// Original: 'Не опрошен'; source: lib/ui/home_screen.dart:1831
  ///
  /// In en, this message translates to:
  /// **'Not polled'**
  String get message0597;

  /// Original: 'Не работает'; source: lib/ui/home_screen.dart:1832
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get message0598;

  /// Original: 'Работает'; source: lib/ui/home_screen.dart:1833
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get message0599;

  /// Original: 'Обновление'; source: lib/ui/home_screen.dart:1834
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get message0600;

  /// Original: 'Состояние неизвестно'; source: lib/ui/home_screen.dart:1836
  ///
  /// In en, this message translates to:
  /// **'Status unknown'**
  String get message0601;

  /// Semantic integration message: Язык
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// Semantic integration message: Системный язык
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemLanguage;

  /// Semantic integration message: Использовать язык устройства
  ///
  /// In en, this message translates to:
  /// **'Follow the device language'**
  String get languageFollowSystemDescription;

  /// Semantic integration message: Не удалось изменить язык. Повторите попытку.
  ///
  /// In en, this message translates to:
  /// **'The language could not be changed. Try again.'**
  String get languageChangeFailed;

  /// Semantic integration message: Не удалось прочитать защищённое хранилище. Повторите попытку.
  ///
  /// In en, this message translates to:
  /// **'Could not read protected storage. Try again.'**
  String get startupStorageFailed;

  /// Semantic integration message: Не удалось удалить локальные данные. Повторите попытку.
  ///
  /// In en, this message translates to:
  /// **'Could not delete local data. Try again.'**
  String get localDataResetFailed;

  /// Semantic integration message: Приложение заблокировано
  ///
  /// In en, this message translates to:
  /// **'App locked'**
  String get appLocked;

  /// Semantic integration message: Открыть
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// Semantic integration message: Сбросить локальные данные
  ///
  /// In en, this message translates to:
  /// **'Reset local data'**
  String get resetLocalData;

  /// Semantic integration message: Сохранённые профили, учётные данные и настройки устройства будут удалены. Это действие нельзя отменить.
  ///
  /// In en, this message translates to:
  /// **'Saved profiles, credentials and device settings will be deleted. This cannot be undone.'**
  String get resetLocalDataWarning;

  /// Semantic integration message: Удалить локальные данные
  ///
  /// In en, this message translates to:
  /// **'Delete local data'**
  String get deleteLocalData;

  /// Semantic integration message: Отмена
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Semantic integration message: Добавить
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Semantic integration message: Добавить входящий торрент?
  ///
  /// In en, this message translates to:
  /// **'Add incoming torrent?'**
  String get incomingTorrentTitle;

  /// Semantic integration message: Сервер: {name}
  ///
  /// In en, this message translates to:
  /// **'Server: {name}'**
  String serverName(String name);

  /// Semantic integration message: Один .torrent-файл
  ///
  /// In en, this message translates to:
  /// **'One .torrent file'**
  String get incomingTorrentFile;

  /// Semantic integration message: Одна ссылка
  ///
  /// In en, this message translates to:
  /// **'One link'**
  String get incomingTorrentLink;

  /// Semantic integration message: Файл .torrent
  ///
  /// In en, this message translates to:
  /// **'Torrent file'**
  String get torrentFile;

  /// Semantic integration message: Разблокируйте Home qB Remote
  ///
  /// In en, this message translates to:
  /// **'Unlock Home qB Remote'**
  String get unlockReason;

  /// Semantic integration message: Загрузка завершена
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get downloadComplete;

  /// Semantic integration message: Загрузка завершена. Откройте приложение для просмотра.
  ///
  /// In en, this message translates to:
  /// **'Download complete. Open the app to view it.'**
  String get downloadCompletePrivate;

  /// Semantic integration message: Завершение загрузок
  ///
  /// In en, this message translates to:
  /// **'Completed downloads'**
  String get completionChannelName;

  /// Semantic integration message: Завершённые загрузки на ваших серверах qBittorrent
  ///
  /// In en, this message translates to:
  /// **'Completed downloads on your qBittorrent servers'**
  String get completionChannelDescription;

  /// No description provided for @integrationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get integrationsTitle;

  /// No description provided for @integrationsNotice.
  ///
  /// In en, this message translates to:
  /// **'Optional connections to your own servers. Search never starts a download automatically.'**
  String get integrationsNotice;

  /// No description provided for @integrationAddJackett.
  ///
  /// In en, this message translates to:
  /// **'Add Jackett'**
  String get integrationAddJackett;

  /// No description provided for @integrationAddJellyfin.
  ///
  /// In en, this message translates to:
  /// **'Add Jellyfin'**
  String get integrationAddJellyfin;

  /// No description provided for @integrationName.
  ///
  /// In en, this message translates to:
  /// **'Profile name'**
  String get integrationName;

  /// No description provided for @integrationServerUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get integrationServerUrl;

  /// No description provided for @integrationApiKey.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get integrationApiKey;

  /// No description provided for @integrationAccessToken.
  ///
  /// In en, this message translates to:
  /// **'User access token'**
  String get integrationAccessToken;

  /// No description provided for @integrationUserId.
  ///
  /// In en, this message translates to:
  /// **'Jellyfin user ID'**
  String get integrationUserId;

  /// No description provided for @integrationSave.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get integrationSave;

  /// No description provided for @integrationEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get integrationEdit;

  /// No description provided for @integrationRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove profile'**
  String get integrationRemove;

  /// No description provided for @integrationRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this connection from the app? Server data will remain unchanged.'**
  String get integrationRemoveConfirm;

  /// No description provided for @integrationCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get integrationCancel;

  /// No description provided for @integrationInvalidProfile.
  ///
  /// In en, this message translates to:
  /// **'Enter a name, a valid HTTP(S) server URL and the required credentials.'**
  String get integrationInvalidProfile;

  /// No description provided for @integrationStorageFailed.
  ///
  /// In en, this message translates to:
  /// **'Protected integration storage is unavailable. Existing profiles were preserved.'**
  String get integrationStorageFailed;

  /// No description provided for @integrationRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get integrationRetry;

  /// No description provided for @integrationHttpNotice.
  ///
  /// In en, this message translates to:
  /// **'HTTP sends credentials without encryption. Use it only on a trusted local network.'**
  String get integrationHttpNotice;

  /// No description provided for @integrationSecretNotice.
  ///
  /// In en, this message translates to:
  /// **'Credentials are stored in protected device storage and sent only to the configured service.'**
  String get integrationSecretNotice;

  /// No description provided for @integrationNoProfiles.
  ///
  /// In en, this message translates to:
  /// **'No integrations configured.'**
  String get integrationNoProfiles;

  /// No description provided for @jackettSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Jackett search'**
  String get jackettSearchTitle;

  /// No description provided for @jackettSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search configured indexers'**
  String get jackettSearchHint;

  /// No description provided for @jackettSearchAction.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get jackettSearchAction;

  /// No description provided for @jackettSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No matching results.'**
  String get jackettSearchEmpty;

  /// No description provided for @jackettSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Jackett search failed. Check the server, API key and indexer configuration.'**
  String get jackettSearchFailed;

  /// No description provided for @jackettDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not retrieve a valid torrent from the configured Jackett server.'**
  String get jackettDownloadFailed;

  /// No description provided for @jackettDownloadAction.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get jackettDownloadAction;

  /// No description provided for @jackettUnknownValue.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get jackettUnknownValue;

  /// No description provided for @jackettNoTarget.
  ///
  /// In en, this message translates to:
  /// **'Select a qBittorrent server before adding a download.'**
  String get jackettNoTarget;

  /// No description provided for @jackettAdded.
  ///
  /// In en, this message translates to:
  /// **'Download submitted. Check the torrent list for its status.'**
  String get jackettAdded;

  /// No description provided for @jellyfinLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Jellyfin library'**
  String get jellyfinLibraryTitle;

  /// No description provided for @jellyfinSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search your library'**
  String get jellyfinSearchHint;

  /// No description provided for @jellyfinSearchAction.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get jellyfinSearchAction;

  /// No description provided for @jellyfinEmptyLibrary.
  ///
  /// In en, this message translates to:
  /// **'No matching library items.'**
  String get jellyfinEmptyLibrary;

  /// No description provided for @jellyfinReadOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'Browse your existing library. Playback is not available here yet.'**
  String get jellyfinReadOnlyNotice;

  /// No description provided for @jellyfinConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to Jellyfin. Check the profile and try again.'**
  String get jellyfinConnectionFailed;

  /// No description provided for @jellyfinAuthenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Jellyfin rejected the access token or user.'**
  String get jellyfinAuthenticationFailed;

  /// No description provided for @jellyfinInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Jellyfin returned an invalid or oversized response.'**
  String get jellyfinInvalidResponse;

  /// No description provided for @jellyfinInvalidProfile.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid server URL, access token and user ID.'**
  String get jellyfinInvalidProfile;

  /// No description provided for @jellyfinRedirectBlocked.
  ///
  /// In en, this message translates to:
  /// **'Jellyfin redirected outside the configured server.'**
  String get jellyfinRedirectBlocked;

  /// No description provided for @jellyfinRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get jellyfinRetry;

  /// No description provided for @jellyfinClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get jellyfinClose;

  /// No description provided for @searchDownloadConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm download'**
  String get searchDownloadConfirmTitle;

  /// No description provided for @searchDownloadTarget.
  ///
  /// In en, this message translates to:
  /// **'Target server: {name}'**
  String searchDownloadTarget(String name);

  /// No description provided for @searchDownloadDataNotice.
  ///
  /// In en, this message translates to:
  /// **'The link and torrent metadata will be sent to this qBittorrent server. URLs may contain tracker credentials.'**
  String get searchDownloadDataNotice;

  /// No description provided for @searchResultUrlHidden.
  ///
  /// In en, this message translates to:
  /// **'Source and download URLs are hidden because they may contain credentials.'**
  String get searchResultUrlHidden;

  /// No description provided for @searchProfileChanged.
  ///
  /// In en, this message translates to:
  /// **'The selected server changed. Start a new search before downloading.'**
  String get searchProfileChanged;

  /// No description provided for @searchAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'This torrent is already on the selected server or has already been submitted.'**
  String get searchAlreadyAdded;

  /// No description provided for @searchAddOutcomeUnknown.
  ///
  /// In en, this message translates to:
  /// **'The download request may have reached the server. Check its torrent list before trying again.'**
  String get searchAddOutcomeUnknown;

  /// No description provided for @searchCheckServer.
  ///
  /// In en, this message translates to:
  /// **'Check server'**
  String get searchCheckServer;

  /// No description provided for @searchUnsupportedDownload.
  ///
  /// In en, this message translates to:
  /// **'This result has no supported download link.'**
  String get searchUnsupportedDownload;

  /// No description provided for @searchAddOptions.
  ///
  /// In en, this message translates to:
  /// **'Download options'**
  String get searchAddOptions;

  /// No description provided for @searchConfirmAdd.
  ///
  /// In en, this message translates to:
  /// **'Confirm and add'**
  String get searchConfirmAdd;

  /// No description provided for @torrentListFilterHint.
  ///
  /// In en, this message translates to:
  /// **'Filter your current torrents'**
  String get torrentListFilterHint;

  /// No description provided for @clearTorrentListFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear torrent filter'**
  String get clearTorrentListFilter;

  /// No description provided for @viewDownloads.
  ///
  /// In en, this message translates to:
  /// **'View downloads'**
  String get viewDownloads;

  /// No description provided for @torrentSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted to qBittorrent. Open downloads to check its status.'**
  String get torrentSubmitted;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'de', 'en', 'es', 'fr', 'he', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'he': return AppLocalizationsHe();
    case 'ru': return AppLocalizationsRu();
    case 'uk': return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
