// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get message0001 => 'Не вдалося прочитати захищене сховище профілів.';

  @override
  String get message0002 => 'Сховище профілів недоступне. Зміни не збережено; наявні дані збережено.';

  @override
  String get message0003 => 'API-ключ не можна поєднувати з Basic-автентифікацією зворотного проксі: обидва використовують заголовок Authorization.';

  @override
  String get message0004 => 'Вхід відхилено. Перевірте дані доступу та повторно підключіться до сервера.';

  @override
  String get message0005 => 'Виберіть сервер';

  @override
  String get message0006 => 'Вибраний файл не є дійсним .torrent. Дані не надіслано.';

  @override
  String get message0007 => 'Операцію не виконано. Перевірте з\'єднання та налаштування сервера.';

  @override
  String get message0008 => 'Ім\'я користувача HTTP Basic не може містити двокрапку.';

  @override
  String get message0009 => 'Використовуйте або API-ключ, або облікові дані HTTP Basic, але не обидва.';

  @override
  String get message0010 => 'API-ключ містить пробіли, розриви рядків або інші непідтримувані символи.';

  @override
  String get message0011 => 'Укажіть і клієнтський сертифікат, і його закритий ключ.';

  @override
  String get message0012 => 'Не вдалося завантажити власний CA або клієнтський сертифікат.';

  @override
  String get message0013 => 'Використовуйте URL сервера HTTP або HTTPS без вбудованих облікових даних, запиту чи фрагмента.';

  @override
  String get message0014 => 'Недійсна кінцева точка API.';

  @override
  String get message0015 => 'З\'єднання з сервером закрито.';

  @override
  String get message0016 => 'Сервер не відповів на перевірку API-ключа. Перевірте URL сервера та налаштування доступу до WebUI.';

  @override
  String get message0017 => 'Не вдалося увійти. Перевірте облікові дані сервера та налаштування доступу до WebUI.';

  @override
  String get message0018 => 'Сервер відхилив API-ключ. Перевірте ключ і налаштування доступу до WebUI, потім підключіться повторно.';

  @override
  String get message0019 => 'Вхід відхилено. Перевірте облікові дані сервера та налаштування доступу до WebUI, потім підключіться повторно.';

  @override
  String get message0020 => 'Спочатку увійдіть на сервер.';

  @override
  String get message0021 => 'Сервер повернув некоректний JSON.';

  @override
  String get message0022 => 'Сервер не зміг виконати дію.';

  @override
  String get message0023 => 'Сервер повернув некоректний список торрентів.';

  @override
  String get message0024 => 'Спочатку виберіть дійсні торренти.';

  @override
  String get message0025 => 'Введіть URL торрента або magnet-посилання.';

  @override
  String get message0026 => 'Виберіть непорожній файл торрента.';

  @override
  String get message0027 => 'Виберіть файл торрента з назвою.';

  @override
  String get message0028 => 'Некоректне поле параметрів торрента.';

  @override
  String get message0029 => 'Сервер відхилив файл торрента.';

  @override
  String get message0030 => 'Сервер повернув некоректні відомості про торрент.';

  @override
  String get message0031 => 'Час очікування запиту до сервера минув.';

  @override
  String get message0032 => 'Сервер повернув некоректне перенаправлення.';

  @override
  String get message0033 => 'Сервер повернув забагато перенаправлень.';

  @override
  String message0034(String arg1) {
    return 'Сервер відхилив запит (HTTP $arg1).';
  }

  @override
  String get message0035 => 'Відповідь сервера занадто велика.';

  @override
  String get message0036 => 'Не вдається підключитися до сервера. Перевірте його адресу та з\'єднання.';

  @override
  String get message0037 => 'Не вдалося підключитися до сервера.';

  @override
  String get message0038 => 'Сервер повернув некоректну відповідь.';

  @override
  String get message0039 => 'Запит до сервера не вдався.';

  @override
  String get message0040 => 'Сеанс завершився. Увійдіть знову.';

  @override
  String get message0041 => 'Сервер відхилив запит (HTTP 403).';

  @override
  String get message0042 => 'Операцію не виконано';

  @override
  String get message0043 => 'Скасувати';

  @override
  String get message0044 => 'Застосувати';

  @override
  String get message0045 => 'Інструменти сервера';

  @override
  String get message0046 => 'Немає сервера';

  @override
  String get message0047 => 'Пряме з\'єднання з вашим qBittorrent. Без реклами та аналітики.';

  @override
  String get message0048 => 'Пошук торрентів';

  @override
  String get message0049 => 'Плагіни пошуку вашого сервера';

  @override
  String get message0050 => 'RSS і правила завантаження';

  @override
  String get message0051 => 'Канали, статті, автоматичні правила';

  @override
  String get message0052 => 'Режим швидкості та обмежень';

  @override
  String get message0053 => 'Обмеження завантаження й відвантаження в КіБ/с';

  @override
  String get message0054 => 'Налаштування qBittorrent';

  @override
  String get message0055 => 'Усі доступні параметри WebUI API';

  @override
  String get message0056 => 'Категорії та теги';

  @override
  String get message0057 => 'Створення, редагування та видалення';

  @override
  String get message0058 => 'Журнал сервера';

  @override
  String get message0059 => 'Основний журнал і заблоковані піри';

  @override
  String get message0060 => 'Стан з\'єднання';

  @override
  String get message0061 => 'Швидкості, передані дані та DHT';

  @override
  String get message0062 => 'Magic-пакет у вашій локальній мережі';

  @override
  String get message0063 => 'Обмеження швидкості';

  @override
  String get message0064 => 'Завантаження, КіБ/с (0 = без обмежень)';

  @override
  String get message0065 => 'Відвантаження, КіБ/с (0 = без обмежень)';

  @override
  String get message0066 => 'Альтернативний режим (true/false)';

  @override
  String get message0067 => 'Обмеження збережено';

  @override
  String get message0068 => 'MAC-адреса';

  @override
  String get message0069 => 'Адреса широкомовлення';

  @override
  String get message0070 => 'Порт';

  @override
  String get message0071 => 'Magic-пакет надіслано';

  @override
  String get message0072 => 'Налаштування недоступне. Перевірте дозволи пристрою та захист безпеки.';

  @override
  String get message0073 => 'Налаштування пристрою';

  @override
  String get message0074 => 'Блокування застосунку';

  @override
  String get message0075 => 'Автентифікація ОС під час відкриття застосунку та повернення до нього.';

  @override
  String get message0076 => 'Сповіщення про завершення';

  @override
  String get message0077 => 'Перевірки виконуються, поки застосунок відкрито. Для сповіщень застосунок має бути запущений.';

  @override
  String get message0078 => 'Пряме опитування qBittorrent. Фонове виконання обмежене ОС; миттєва доставка не гарантується.';

  @override
  String get message0079 => 'Інтервал фонової перевірки';

  @override
  String message0080(String arg1) {
    return '$arg1 хв. ОС може затримати запуск.';
  }

  @override
  String get message0081 => 'Інтервал, хвилини';

  @override
  String get message0082 => 'Від 15 до 1440 хвилин';

  @override
  String get message0083 => 'Зберегти';

  @override
  String get message0084 => 'Без реклами та аналітики';

  @override
  String get message0085 => 'Без Firebase, рекламних SDK, віддаленої конфігурації чи реєстрації розробника. Профілі та сертифікати зберігаються в захищеному сховищі ОС.';

  @override
  String get message0086 => 'Мережеві з’єднання';

  @override
  String get message0087 => 'Клієнт підключається до вказаних вами серверів qBittorrent. Wake-on-LAN надсилає пакет на введену вами локальну адресу. Пошук і RSS обробляються вашим сервером.';

  @override
  String get message0088 => 'Безпека з’єднання';

  @override
  String get message0089 => 'Для віддаленого доступу використовуйте HTTPS або VPN. Перевірка сертифікатів увімкнена; у профілі можна задати власний CA та клієнтський сертифікат PEM.';

  @override
  String get message0090 => 'Заповніть це поле';

  @override
  String get message0091 => 'Підтвердити';

  @override
  String get message0092 => 'Введіть ціле число, нуль або більше';

  @override
  String get message0093 => 'Б';

  @override
  String get message0094 => 'КіБ';

  @override
  String get message0095 => 'МіБ';

  @override
  String get message0096 => 'ГіБ';

  @override
  String get message0097 => 'ТіБ';

  @override
  String get message0098 => 'Помилка операції RSS';

  @override
  String get message0099 => 'Оновити';

  @override
  String get message0100 => 'Додати';

  @override
  String get message0101 => 'Додати стрічку';

  @override
  String get message0102 => 'Створити папку';

  @override
  String get message0103 => 'Додати правило';

  @override
  String get message0104 => 'Дії з папкою';

  @override
  String get message0105 => 'Статті';

  @override
  String get message0106 => 'Стрічки';

  @override
  String get message0107 => 'Правила';

  @override
  String get message0108 => 'У стрічках ще немає статей';

  @override
  String get message0109 => 'Без назви';

  @override
  String get message0110 => 'Торрент додано';

  @override
  String get message0111 => 'Додати торрент';

  @override
  String get message0112 => 'Позначити як прочитане';

  @override
  String get message0113 => 'Додайте першу RSS-стрічку кнопкою +';

  @override
  String get message0114 => 'Оновити стрічку';

  @override
  String get message0115 => 'Позначити все як прочитане';

  @override
  String get message0116 => 'Перемістити / перейменувати';

  @override
  String get message0117 => 'Видалити стрічку';

  @override
  String get message0118 => 'Немає правил автоматичного завантаження';

  @override
  String get message0119 => 'Редагувати';

  @override
  String get message0120 => 'Перейменувати';

  @override
  String get message0121 => 'Відповідні статті';

  @override
  String get message0122 => 'Видалити правило';

  @override
  String get message0123 => 'RSS-папка';

  @override
  String get message0124 => 'Повний шлях до папки';

  @override
  String get message0125 => 'Дія з папкою';

  @override
  String get message0126 => 'Видалити папку';

  @override
  String get message0127 => 'Нова RSS-стрічка';

  @override
  String get message0128 => 'Нова RSS-папка';

  @override
  String get message0129 => 'URL стрічки';

  @override
  String get message0130 => 'Шлях і назва стрічки (необов’язково)';

  @override
  String get message0131 => 'Шлях нової папки';

  @override
  String get message0132 => 'Новий шлях RSS';

  @override
  String get message0133 => 'Шлях і нова назва';

  @override
  String get message0134 => 'Видалити RSS-елемент?';

  @override
  String message0135(String arg1) {
    return '“$arg1” та його RSS-вміст буде видалено. Торрент-файли не зміняться.';
  }

  @override
  String get message0136 => 'Видалити правило?';

  @override
  String get message0137 => 'Назва правила';

  @override
  String get message0138 => 'Нова назва';

  @override
  String message0139(String arg1) {
    return 'Відповідні статті: $arg1';
  }

  @override
  String get message0140 => 'Немає відповідних статей';

  @override
  String get message0141 => 'Закрити';

  @override
  String get message0142 => 'Нове RSS-правило';

  @override
  String get message0143 => 'RSS-правило';

  @override
  String get message0144 => 'Має містити';

  @override
  String get message0145 => 'Не має містити';

  @override
  String get message0146 => 'Фільтр епізодів';

  @override
  String get message0147 => 'URL стрічок, по одному на рядок';

  @override
  String get message0148 => 'Категорія';

  @override
  String get message0149 => 'Шлях збереження';

  @override
  String get message0150 => 'Не завантажувати повторно протягом, днів';

  @override
  String get message0151 => 'Введіть назву правила';

  @override
  String get message0152 => 'Правило увімкнено';

  @override
  String get message0153 => 'Регулярні вирази';

  @override
  String get message0154 => 'Розумний фільтр епізодів';

  @override
  String get message0155 => 'Додавати призупиненим';

  @override
  String get message0156 => 'Пошукові плагіни недоступні';

  @override
  String get message0157 => 'Пошук на вашому сервері…';

  @override
  String message0158(int arg1, String arg2) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 результату',
      many: '$arg1 результатів',
      few: '$arg1 результати',
      one: '$arg1 результат',
    );
    return '$_temp0$arg2';
  }

  @override
  String get message0159 => ' · завершено';

  @override
  String message0160(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 результату',
      many: '$arg1 результатів',
      few: '$arg1 результати',
      one: '$arg1 результат',
    );
    return '$_temp0 · пошук зупинено через 2 хвилини';
  }

  @override
  String get message0161 => 'Помилка пошуку';

  @override
  String get message0162 => 'Не вдалося зупинити пошук';

  @override
  String message0163(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 результату',
      many: '$arg1 результатів',
      few: '$arg1 результати',
      one: '$arg1 результат',
    );
    return '$_temp0 · зупинено';
  }

  @override
  String get message0164 => 'Пошук на сервері';

  @override
  String get message0165 => 'Плагіни пошуку';

  @override
  String get message0166 => 'Назва торрента';

  @override
  String get message0167 => 'Зупинити';

  @override
  String get message0168 => 'Пошук';

  @override
  String get message0169 => 'Плагін';

  @override
  String get message0170 => 'Усі плагіни';

  @override
  String get message0171 => 'Лише увімкнені';

  @override
  String get message0172 => 'Усі';

  @override
  String get message0173 => 'Книги';

  @override
  String get message0174 => 'Ігри';

  @override
  String get message0175 => 'Фільми';

  @override
  String get message0176 => 'Музика';

  @override
  String get message0177 => 'Програмне забезпечення';

  @override
  String get message0178 => 'Телешоу';

  @override
  String get message0179 => 'Введіть пошуковий запит';

  @override
  String message0180(String arg1, String arg2, String arg3) {
    return '$arg1 · сіди $arg2\n$arg3';
  }

  @override
  String get message0181 => 'Додати на сервер';

  @override
  String get message0182 => 'Не вдалося додати торрент';

  @override
  String get message0183 => 'Не вдалося змінити плагіни';

  @override
  String get message0184 => 'Встановити плагін пошуку';

  @override
  String get message0185 => 'URL-адреса файлу плагіна';

  @override
  String get message0186 => 'Плагін буде завантажено та встановлено на ваш сервер qBittorrent. Використовуйте лише перевірені джерела.';

  @override
  String get message0187 => 'Плагіни пошуку';

  @override
  String get message0188 => 'Оновити плагіни';

  @override
  String get message0189 => 'Встановити плагін';

  @override
  String get message0190 => 'На сервері немає плагінів пошуку';

  @override
  String message0191(String arg1) {
    return 'Версія $arg1';
  }

  @override
  String get message0192 => 'Видалити плагін';

  @override
  String get message0193 => 'Видалити плагін?';

  @override
  String get message0194 => 'Нова категорія';

  @override
  String get message0195 => 'Редагувати категорію';

  @override
  String get message0196 => 'Назва';

  @override
  String get message0197 => 'Папка на сервері';

  @override
  String get message0198 => 'Категорії';

  @override
  String get message0199 => 'Видалити категорію';

  @override
  String get message0200 => 'Видалити категорію?';

  @override
  String message0201(String arg1) {
    return '$arg1. Торренти та файли буде збережено.';
  }

  @override
  String get message0202 => 'Теги';

  @override
  String get message0203 => 'Створити теги';

  @override
  String get message0204 => 'Нові теги';

  @override
  String get message0205 => 'Назви через коми';

  @override
  String get message0206 => 'Видалити тег';

  @override
  String get message0207 => 'Видалити тег?';

  @override
  String message0208(String arg1) {
    return '$arg1. Торренти та файли буде збережено.';
  }

  @override
  String get message0209 => 'Звичайний';

  @override
  String get message0210 => 'Інформація';

  @override
  String get message0211 => 'Попередження';

  @override
  String get message0212 => 'Критичний';

  @override
  String get message0213 => 'Повідомлення';

  @override
  String get message0214 => 'Журнал пірів';

  @override
  String get message0215 => 'Рівень';

  @override
  String get message0216 => 'Усі повідомлення';

  @override
  String get message0217 => 'Попередження';

  @override
  String get message0218 => 'Критичні';

  @override
  String get message0219 => 'Заблоковано';

  @override
  String get message0220 => 'Дозволено';

  @override
  String get message0221 => 'Швидкість завантаження';

  @override
  String get message0222 => 'Швидкість віддачі';

  @override
  String get message0223 => 'Завантажено за сеанс';

  @override
  String get message0224 => 'Віддано за сеанс';

  @override
  String get message0225 => 'Ліміт завантаження';

  @override
  String get message0226 => 'Ліміт віддачі';

  @override
  String get message0227 => 'Вузли DHT';

  @override
  String get message0228 => 'З\'єднання';

  @override
  String message0229(String arg1) {
    return '$arg1/с';
  }

  @override
  String get message0230 => 'Підключено';

  @override
  String get message0231 => 'За NAT / брандмауером';

  @override
  String get message0232 => 'Не підключено';

  @override
  String get message0233 => 'Категорії та теги';

  @override
  String get message0234 => 'Стан сервера';

  @override
  String get message0235 => 'Не вдалося завантажити налаштування';

  @override
  String get message0236 => 'Змінити WebUI?';

  @override
  String get message0237 => 'Зміна адреси, порту або автентифікації може призвести до відключення.';

  @override
  String get message0238 => 'Налаштування збережено. Якщо адреса, порт або пароль WebUI змінилися, оновіть свій профіль підключення.';

  @override
  String get message0239 => 'Налаштування збережено';

  @override
  String get message0240 => 'Не вдалося зберегти налаштування';

  @override
  String get message0241 => 'Введіть ціле число';

  @override
  String get message0242 => 'Порт має бути 1–65535';

  @override
  String get message0243 => 'Година має бути 0–23';

  @override
  String get message0244 => 'Хвилина має бути 0–59';

  @override
  String get message0245 => 'Мінімум −1 (якщо підтримується сервером)';

  @override
  String get message0246 => 'Розширені параметри JSON';

  @override
  String get message0247 => 'Усі параметри з поточного сервера. Зберігаються лише змінені ключі.';

  @override
  String get message0248 => 'Недійсний JSON параметрів';

  @override
  String get message0249 => 'Завантаження';

  @override
  String get message0250 => 'Папка збереження';

  @override
  String get message0251 => 'Тимчасова папка';

  @override
  String get message0252 => 'Використовувати тимчасову папку';

  @override
  String get message0253 => 'Додавати на паузі';

  @override
  String get message0254 => 'Автоматичне керування торрентами';

  @override
  String get message0255 => 'Попереднє виділення місця на диску';

  @override
  String get message0256 => 'Розширення для неповних файлів';

  @override
  String get message0257 => 'Папка експорту .torrent';

  @override
  String get message0258 => 'Експортувати завершені файли .torrent';

  @override
  String get message0259 => 'Вхідний порт';

  @override
  String get message0260 => 'Випадковий порт під час запуску';

  @override
  String get message0261 => 'Максимум з\'єднань (-1 = без обмежень)';

  @override
  String get message0262 => 'З\'єднань на торрент';

  @override
  String get message0263 => 'Слоти відвантаження';

  @override
  String get message0264 => 'Адреса проксі';

  @override
  String get message0265 => 'Порт проксі';

  @override
  String get message0266 => 'Ім\'я користувача проксі';

  @override
  String get message0267 => 'Пароль проксі';

  @override
  String get message0268 => 'Швидкість';

  @override
  String get message0269 => 'Завантаження, байт/с (0 = без обмежень)';

  @override
  String get message0270 => 'Відвантаження, байт/с (0 = без обмежень)';

  @override
  String get message0271 => 'Альтернативне завантаження, байт/с';

  @override
  String get message0272 => 'Альтернативне відвантаження, байт/с';

  @override
  String get message0273 => 'Розклад альтернативних обмежень';

  @override
  String get message0274 => 'Початок: година';

  @override
  String get message0275 => 'Початок: хвилина';

  @override
  String get message0276 => 'Кінець: година';

  @override
  String get message0277 => 'Кінець: хвилина';

  @override
  String get message0278 => 'Враховувати накладні витрати протоколу в обмеженнях';

  @override
  String get message0279 => 'Обмежувати локальні піри';

  @override
  String get message0280 => 'Обмін пірами (PeX)';

  @override
  String get message0281 => 'Виявлення локальних пірів';

  @override
  String get message0282 => 'Анонімний режим';

  @override
  String get message0283 => 'Черговість торрентів';

  @override
  String get message0284 => 'Активні завантаження';

  @override
  String get message0285 => 'Активні відвантаження';

  @override
  String get message0286 => 'Активні торренти';

  @override
  String get message0287 => 'Не враховувати повільні торренти';

  @override
  String get message0288 => 'Автоматично додавати трекери';

  @override
  String get message0289 => 'Додаткові трекери';

  @override
  String get message0290 => 'Адреса прослуховування';

  @override
  String get message0291 => 'Порт WebUI';

  @override
  String get message0292 => 'Ім\'я користувача';

  @override
  String get message0293 => 'Новий пароль';

  @override
  String get message0294 => 'Автентифікація localhost';

  @override
  String get message0295 => 'Захист від CSRF';

  @override
  String get message0296 => 'Захист від клікджекінгу';

  @override
  String get message0297 => 'Тайм-аут сеансу, секунди';

  @override
  String get message0298 => 'Увімкнути стрічки RSS';

  @override
  String get message0299 => 'Автозавантаження за правилами';

  @override
  String get message0300 => 'Інтервал оновлення, хвилини';

  @override
  String get message0301 => 'Статей у стрічці';

  @override
  String get message0302 => 'Фільтри епізодів';

  @override
  String get message0303 => 'Усі параметри (JSON)';

  @override
  String get message0304 => 'Розширені параметри для вашої версії сервера';

  @override
  String get message0305 => 'Не вдалося виконати дію';

  @override
  String get message0306 => 'Зміни застосовано';

  @override
  String get message0307 => 'Керування торрентом';

  @override
  String get message0308 => 'Упорядкування';

  @override
  String get message0309 => 'Назва торрента';

  @override
  String get message0310 => 'Перейменувати торрент';

  @override
  String get message0311 => 'Перемістити файли';

  @override
  String get message0312 => 'Новий шлях на сервері';

  @override
  String get message0313 => 'Повний шлях';

  @override
  String get message0314 => 'qBittorrent переміщує файли на сервері';

  @override
  String get message0315 => 'Додати мітки';

  @override
  String get message0316 => 'Мітки, розділені комами';

  @override
  String get message0317 => 'Видалити мітки';

  @override
  String get message0318 => 'Швидкість і роздавання';

  @override
  String get message0319 => 'Обмеження швидкості';

  @override
  String get message0320 => 'Обмеження роздавання';

  @override
  String get message0321 => 'Примусовий запуск';

  @override
  String get message0322 => 'Суперроздача';

  @override
  String get message0323 => 'Перемкнути послідовне завантаження';

  @override
  String get message0324 => 'Перемкнути пріоритет першого/останнього фрагмента';

  @override
  String get message0325 => 'Примусова перевірка';

  @override
  String get message0326 => 'Перевірити файли повторно?';

  @override
  String get message0327 => 'Перевірка може зайняти деякий час і тимчасово призупинити передачі.';

  @override
  String get message0328 => 'Повторно повідомити трекерам';

  @override
  String get message0329 => 'Черга';

  @override
  String get message0330 => 'Перемістити на початок';

  @override
  String get message0331 => 'Перемістити вгору';

  @override
  String get message0332 => 'Перемістити вниз';

  @override
  String get message0333 => 'Перемістити в кінець';

  @override
  String get message0334 => 'Вміст і з\'єднання';

  @override
  String get message0335 => 'Експортувати .torrent';

  @override
  String get message0336 => 'Файли та пріоритети';

  @override
  String get message0337 => 'Перейменувати папку';

  @override
  String get message0338 => 'Поточний шлях у торренті';

  @override
  String get message0339 => 'Новий шлях у торренті';

  @override
  String get message0340 => 'Трекери';

  @override
  String get message0341 => 'Піри';

  @override
  String get message0342 => 'HTTP-джерела';

  @override
  String get message0343 => 'Стани фрагментів';

  @override
  String get message0344 => 'Без категорії';

  @override
  String get message0345 => 'Завантаження, КіБ/с';

  @override
  String get message0346 => 'Відвантаження, КіБ/с';

  @override
  String get message0347 => '0 = без обмежень. 1 КіБ/с = 1024 байти/с.';

  @override
  String get message0348 => 'Рейтинг';

  @override
  String get message0349 => 'Введіть число';

  @override
  String get message0350 => 'Час роздачі, хвилин';

  @override
  String get message0351 => 'Введіть ціле число';

  @override
  String get message0352 => 'Час неактивної роздачі, хвилин';

  @override
  String get message0353 => '-2 = використовувати налаштування сервера, -1 = без обмежень.';

  @override
  String get message0354 => 'Увімкнути';

  @override
  String get message0355 => 'Вимкнути';

  @override
  String get message0356 => 'Файли';

  @override
  String message0357(String arg1, String arg2) {
    return '$arg1 · пріоритет $arg2';
  }

  @override
  String get message0358 => 'Перейменувати файл';

  @override
  String get message0359 => 'Зміни застосовано. Відкрийте список знову, щоб оновити.';

  @override
  String get message0360 => 'Дію не виконано';

  @override
  String get message0361 => 'Не завантажувати';

  @override
  String get message0362 => 'Звичайний пріоритет';

  @override
  String get message0363 => 'Високий пріоритет';

  @override
  String get message0364 => 'Максимальний пріоритет';

  @override
  String get message0365 => 'Редагувати трекер';

  @override
  String get message0366 => 'Нова URL-адреса';

  @override
  String get message0367 => 'Видалити трекер?';

  @override
  String get message0368 => 'Не вдалося змінити трекер';

  @override
  String get message0369 => 'Видалити';

  @override
  String get message0370 => 'Додати трекери';

  @override
  String get message0371 => 'URL-адреси, по одній на рядок';

  @override
  String get message0372 => 'Не вдалося додати трекери';

  @override
  String get message0373 => 'Немає підключених піров';

  @override
  String message0374(String arg1, String arg2) {
    return '$arg1 · ↓ $arg2/с';
  }

  @override
  String get message0375 => 'Додати піри';

  @override
  String get message0376 => 'IP:порт, розділені символом |';

  @override
  String get message0377 => 'Не вдалося додати піри';

  @override
  String message0378(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 фрагмента',
      many: '$arg1 фрагментів',
      few: '$arg1 фрагменти',
      one: '$arg1 фрагмент',
    );
    return '$_temp0';
  }

  @override
  String get message0379 => 'Сірий: відсутній, синій: завантажується, зелений: завантажено. Показано перші 4096 фрагментів.';

  @override
  String message0380(String arg1) {
    return 'Фрагмент $arg1';
  }

  @override
  String get message0381 => 'Експорт завершено';

  @override
  String get message0382 => 'Експорт скасовано';

  @override
  String get message0383 => 'Введіть URL-адресу';

  @override
  String get message0384 => 'URL не повинна містити пробіли, керувальні символи або \"|\"';

  @override
  String get message0385 => 'Введіть адресу http:// або https:// з іменем хоста';

  @override
  String get message0386 => 'Введіть принаймні одну URL-адресу';

  @override
  String get message0387 => 'Сервер не підтримує зміну HTTP-джерел. ';

  @override
  String get message0388 => 'Потрібен qBittorrent 5.2 або новіший; лише перегляд.';

  @override
  String get message0389 => 'Не вдалося завантажити HTTP-джерела';

  @override
  String get message0390 => 'Додати HTTP-джерела';

  @override
  String get message0391 => 'Адреси передаються серверу qBittorrent; застосунок не підключається до них безпосередньо.';

  @override
  String get message0392 => 'Не вдалося додати HTTP-джерела';

  @override
  String get message0393 => 'Редагувати HTTP-джерело';

  @override
  String get message0394 => 'Адресу не змінено';

  @override
  String get message0395 => 'Не вдалося змінити HTTP-джерело';

  @override
  String get message0396 => 'Видалити HTTP-джерело?';

  @override
  String get message0397 => 'Не вдалося видалити HTTP-джерело';

  @override
  String get message0398 => 'Додати джерела';

  @override
  String get message0399 => 'Для редагування HTTP-джерел потрібен qBittorrent 5.2 або новіший. ';

  @override
  String get message0400 => 'Старіший сервер може відхилити зміни.';

  @override
  String get message0401 => 'Повторити';

  @override
  String get message0402 => 'Немає джерел HTTP';

  @override
  String get message0403 => 'Не вдалося ініціалізувати захищене сховище.';

  @override
  String get message0404 => 'Додати вхідний торрент?';

  @override
  String message0405(String arg1) {
    return 'Сервер: $arg1';
  }

  @override
  String get message0406 => 'Один файл .torrent';

  @override
  String get message0407 => 'Одне посилання';

  @override
  String get message0408 => 'Файл .torrent';

  @override
  String get message0409 => 'Не вдалося видалити локальні дані.';

  @override
  String get message0410 => 'Home qB заблоковано';

  @override
  String get message0411 => 'Відкрити';

  @override
  String get message0412 => 'Скинути локальні дані';

  @override
  String get message0413 => 'Профілі, паролі та сертифікати буде видалено з цього пристрою. Торренти на сервері буде збережено.';

  @override
  String get message0414 => 'Видалити локальні дані';

  @override
  String get message0415 => 'Не вдалося прочитати налаштування пристрою із захищеного сховища.';

  @override
  String get message0416 => 'Не вдалося запланувати фонове опитування на цьому пристрої.';

  @override
  String get message0417 => 'Фонове опитування доступне на Android і iOS. Для сповіщень на комп’ютері застосунок має залишатися відкритим.';

  @override
  String get message0418 => 'Сповіщення не налаштовано на цій платформі.';

  @override
  String get message0419 => 'Системні сповіщення недоступні.';

  @override
  String get message0420 => 'Не вдалося ініціалізувати системні сповіщення.';

  @override
  String get message0421 => 'Android може затримувати опитування через обмеження батареї, мережі або фонової роботи.';

  @override
  String get message0422 => 'Виберіть інтервал опитування від 15 до 1440 хвилин.';

  @override
  String get message0423 => 'Новий інтервал збережено, але фоновий розклад не вдалося оновити.';

  @override
  String get message0424 => 'Сповіщення недоступні.';

  @override
  String get message0425 => 'Дозвіл на сповіщення не надано.';

  @override
  String get message0426 => 'Не вдалося оновити фоновий розклад. Перевірки сповіщень у відкритому застосунку все ще працюють.';

  @override
  String get message0427 => 'Розблокувати Home qB Remote';

  @override
  String get message0428 => 'Автентифікацію пристрою не завершено.';

  @override
  String get message0429 => 'Не вдалося увімкнути захист від знімків екрана.';

  @override
  String get message0430 => 'Не вдалося видалити системні сповіщення.';

  @override
  String get message0431 => 'Не вдалося скасувати фонову перевірку.';

  @override
  String get message0432 => 'Завантаження завершено';

  @override
  String get message0433 => 'Завантаження завершено. Відкрийте застосунок, щоб переглянути його.';

  @override
  String get message0434 => 'Завершені завантаження';

  @override
  String get message0435 => 'Завершені завантаження на ваших серверах qBittorrent';

  @override
  String get message0436 => 'Вичерпано бюджет фонового сканування.';

  @override
  String get message0437 => 'Можна імпортувати лише локальний документ .torrent.';

  @override
  String get message0438 => 'Імпорт документів не підтримується на цій платформі.';

  @override
  String get message0439 => 'Імпорт документів недоступний у цій збірці застосунку.';

  @override
  String get message0440 => 'Документ відхилено системою.';

  @override
  String get message0441 => 'Не вдалося прочитати документ торрента.';

  @override
  String get message0442 => 'Документ торрента порожній.';

  @override
  String get message0443 => 'Документ торрента більший за 16 МіБ і не може бути імпортований.';

  @override
  String get message0444 => 'Документ не є дійсним файлом .torrent.';

  @override
  String get message0445 => 'Російська';

  @override
  String get message0446 => 'Українська';

  @override
  String get message0447 => 'Мова не підтримується';

  @override
  String get message0448 => 'Інший експорт ще виконується.';

  @override
  String get message0449 => 'Експорт не підтримується на цій платформі.';

  @override
  String get message0450 => 'Немає даних торрента для експорту.';

  @override
  String get message0451 => 'Файл торрента більший за 16 МіБ і не може бути експортований.';

  @override
  String get message0452 => 'Дані торрента не є дійсною послідовністю байтів.';

  @override
  String get message0453 => 'Експорт недоступний у цій збірці застосунку.';

  @override
  String get message0454 => 'Дані торрента відхилено системою.';

  @override
  String get message0455 => 'Не вдалося зберегти файл торрента.';

  @override
  String get message0456 => 'Не вдалося відкрити діалог збереження.';

  @override
  String get message0457 => 'Не вдалося записати файл торрента у вибране місце.';

  @override
  String get message0458 => 'Введіть ціле число від 0';

  @override
  String get message0459 => 'Нове завантаження';

  @override
  String get message0460 => 'Магнет-посилання або URL-адреси';

  @override
  String get message0461 => 'Одне посилання в рядку';

  @override
  String get message0462 => 'Виберіть файл .torrent';

  @override
  String get message0463 => 'Параметри завантаження';

  @override
  String get message0464 => 'Теги через кому';

  @override
  String get message0465 => 'Нова назва (необов’язково)';

  @override
  String get message0466 => 'Ліміт завантаження, КіБ/с';

  @override
  String get message0467 => '0 — без обмеження; порожньо — налаштування сервера';

  @override
  String get message0468 => 'Ліміт відвантаження, КіБ/с';

  @override
  String get message0469 => 'Структура файлів';

  @override
  String get message0470 => 'Як у торренті';

  @override
  String get message0471 => 'Створити підпапку';

  @override
  String get message0472 => 'Без підпапки';

  @override
  String get message0473 => 'Додати на паузу';

  @override
  String get message0474 => 'Послідовне завантаження';

  @override
  String get message0475 => 'Спочатку перша та остання частини';

  @override
  String get message0476 => 'Пароль PKCS#12';

  @override
  String get message0477 => 'Пароль контейнера';

  @override
  String get message0478 => 'Імпорт';

  @override
  String get message0479 => 'Home qB';

  @override
  String get message0480 => 'Керування серверами';

  @override
  String get message0481 => 'Налаштування застосунку';

  @override
  String get message0482 => 'ВАШЕ З\'ЄДНАННЯ';

  @override
  String get message0483 => 'Сервер не вибрано';

  @override
  String get message0484 => 'Сервери';

  @override
  String get message0485 => 'RSS, пошук, налаштування';

  @override
  String get message0486 => 'Завантаження';

  @override
  String get message0487 => 'Роздавання';

  @override
  String get message0488 => 'Призупинено';

  @override
  String get message0489 => 'Помилки';

  @override
  String get message0490 => 'Усі торренти';

  @override
  String get message0491 => 'Лише ваші сервери.\nБез реклами й телеметрії.';

  @override
  String get message0492 => 'Ваші завантаження завжди під рукою';

  @override
  String get message0493 => 'Під\'єднайте свій домашній qBittorrent через Web UI.\nАдреса сервера та налаштування зберігаються на цьому пристрої.';

  @override
  String get message0494 => 'Під\'єднати сервер';

  @override
  String get message0495 => 'Переглянути завантаження';

  @override
  String get message0496 => 'Поточний сервер';

  @override
  String message0497(String arg1) {
    return '$arg1/с';
  }

  @override
  String message0498(String arg1) {
    return '$arg1/с';
  }

  @override
  String get message0499 => 'Торренти';

  @override
  String get message0500 => 'Знайти торрент за назвою';

  @override
  String message0501(String arg1) {
    return 'Вибрано: $arg1';
  }

  @override
  String get message0502 => 'Відновити вибрані';

  @override
  String get message0503 => 'Призупинити вибрані';

  @override
  String get message0504 => 'Видалити вибрані';

  @override
  String get message0505 => 'Скасувати вибір';

  @override
  String get message0506 => 'Нічого не знайдено';

  @override
  String get message0507 => 'Торрентів ще немає';

  @override
  String get message0508 => 'Додайте magnet-посилання, URL або файл .torrent.';

  @override
  String get message0509 => 'Відновити';

  @override
  String get message0510 => 'Призупинити';

  @override
  String get message0511 => 'Дії';

  @override
  String get message0512 => 'Деталі';

  @override
  String get message0513 => 'Видалити…';

  @override
  String message0514(String arg1) {
    return '↓ $arg1/с';
  }

  @override
  String message0515(String arg1) {
    return '↑ $arg1/с';
  }

  @override
  String get message0516 => 'Не вдалося виконати дію. Перевірте з\'єднання із сервером.';

  @override
  String get message0517 => 'Мої сервери';

  @override
  String get message0518 => 'Налаштування сервера';

  @override
  String get message0519 => 'Редагувати';

  @override
  String get message0520 => 'Видалити профіль';

  @override
  String get message0521 => 'Додати сервер';

  @override
  String get message0522 => 'Видалити профіль?';

  @override
  String message0523(String arg1) {
    return 'Профіль «$arg1» буде видалено з цього пристрою. Торренти на сервері буде збережено.';
  }

  @override
  String get message0524 => 'Використовувати локальний HTTP?';

  @override
  String get message0525 => 'SSID не підтверджує ідентичність мережі. У іншій мережі з такою самою назвою ваш пароль може потрапити на неавторизований сервер. Для захисту використовуйте HTTPS із перевіркою сертифіката або VPN.';

  @override
  String get message0526 => 'Виберіть файл .torrent розміром до 16 МБ.';

  @override
  String get message0527 => 'Не вдалося відкрити вибраний файл.';

  @override
  String get message0528 => 'Видалити торрент?';

  @override
  String message0529(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: 'Видалити $arg1 торента?',
      many: 'Видалити $arg1 торентів?',
      few: 'Видалити $arg1 торенти?',
      one: 'Видалити $arg1 торент?',
    );
    return '$_temp0';
  }

  @override
  String get message0530 => 'За замовчуванням завантажені файли залишаться на сервері.';

  @override
  String get message0531 => 'Також видалити файли з сервера';

  @override
  String get message0532 => 'Цю дію не можна скасувати';

  @override
  String get message0533 => 'Домашній сервер';

  @override
  String get message0534 => 'Не вдалося імпортувати PKCS#12. Перевірте пароль і файл (до 4 МБ).';

  @override
  String get message0535 => 'Введіть назву';

  @override
  String get message0536 => 'Адреса Web UI';

  @override
  String get message0537 => 'HTTP або HTTPS, включно з портом і шляхом';

  @override
  String get message0538 => 'Введіть повну адресу сервера HTTP(S)';

  @override
  String get message0539 => 'Видаліть із адреси пароль, параметри та #';

  @override
  String get message0540 => 'Пароль';

  @override
  String get message0541 => 'Приховати пароль';

  @override
  String get message0542 => 'Показати пароль';

  @override
  String get message0543 => 'Ключ API (необов\'язково)';

  @override
  String get message0544 => 'qBittorrent 5.2+. Якщо заповнено, використовується замість імені користувача та пароля.';

  @override
  String get message0545 => 'Ключ API не можна поєднувати із проксі Basic auth';

  @override
  String get message0546 => 'Локальна адреса Wi-Fi';

  @override
  String get message0547 => 'Необов\'язково. SSID використовується лише на пристрої для вибору адреси. ОС може запросити дозвіл на геолокацію для читання назви Wi-Fi; координати не зчитуються.';

  @override
  String get message0548 => 'Локальна URL-адреса';

  @override
  String get message0549 => 'Введіть адресу HTTP(S) без пароля та параметрів';

  @override
  String get message0550 => 'Домашня мережа Wi-Fi (SSID)';

  @override
  String get message0551 => 'SSID недоступний. Ви можете ввести назву мережі вручну.';

  @override
  String get message0552 => 'Зчитати поточну мережу';

  @override
  String get message0553 => 'Проксі та сертифікати';

  @override
  String get message0554 => 'Basic auth для зворотного проксі; PEM для HTTPS і клієнтського сертифіката.';

  @override
  String get message0555 => 'Basic auth: ім\'я користувача';

  @override
  String get message0556 => 'Basic auth: пароль';

  @override
  String get message0557 => 'Власний центр сертифікації (PEM)';

  @override
  String get message0558 => 'Клієнтський сертифікат (PEM)';

  @override
  String get message0559 => 'Закритий ключ (PEM)';

  @override
  String get message0560 => 'Імпортувати PKCS#12 (.p12/.pfx)';

  @override
  String get message0561 => 'Пароль закритого ключа';

  @override
  String get message0562 => 'Файл PEM має бути меншим за 1 МБ.';

  @override
  String get message0563 => 'Не вдалося прочитати файл PEM.';

  @override
  String get message0564 => 'Імпортувати файл';

  @override
  String get message0565 => 'Дії з торрентом';

  @override
  String get message0566 => 'Перевірити повторно';

  @override
  String get message0567 => 'Оновити трекери';

  @override
  String get message0568 => 'Примусовий запуск';

  @override
  String get message0569 => 'Перші та останні частини';

  @override
  String get message0570 => 'Не вдалося завантажити відомості про торрент.';

  @override
  String get message0571 => 'Огляд';

  @override
  String get message0572 => 'Список файлів порожній';

  @override
  String get message0573 => 'Файл';

  @override
  String get message0574 => 'Пріоритет файлу';

  @override
  String get message0575 => 'Високий';

  @override
  String get message0576 => 'Максимальний';

  @override
  String get message0577 => 'Немає трекерів';

  @override
  String get message0578 => 'Трекер';

  @override
  String get message0579 => 'Не вдалося змінити торрент.';

  @override
  String get message0580 => 'Стан';

  @override
  String get message0581 => 'Розмір';

  @override
  String get message0582 => 'Завершено';

  @override
  String get message0583 => 'Завантажено';

  @override
  String get message0584 => 'Вивантажено';

  @override
  String get message0585 => 'Коментар';

  @override
  String get message0586 => 'Хеш';

  @override
  String get message0587 => 'КБ';

  @override
  String get message0588 => 'МБ';

  @override
  String get message0589 => 'ГБ';

  @override
  String get message0590 => 'ТБ';

  @override
  String get message0591 => 'Помилка';

  @override
  String get message0592 => 'Перевірка';

  @override
  String get message0593 => 'Переміщення';

  @override
  String get message0594 => 'У черзі';

  @override
  String get message0595 => 'Метадані';

  @override
  String get message0596 => 'Сервер';

  @override
  String get message0597 => 'Не опитується';

  @override
  String get message0598 => 'Недоступний';

  @override
  String get message0599 => 'Працює';

  @override
  String get message0600 => 'Оновлення';

  @override
  String get message0601 => 'Невідомий стан';

  @override
  String get languageTitle => 'Мова';

  @override
  String get systemLanguage => 'Як у системі';

  @override
  String get languageFollowSystemDescription => 'Використовувати мову пристрою';

  @override
  String get languageChangeFailed => 'Не вдалося змінити мову. Спробуйте ще раз.';

  @override
  String get startupStorageFailed => 'Не вдалося прочитати захищене сховище. Спробуйте ще раз.';

  @override
  String get localDataResetFailed => 'Не вдалося видалити локальні дані. Спробуйте ще раз.';

  @override
  String get appLocked => 'Застосунок заблоковано';

  @override
  String get open => 'Відкрити';

  @override
  String get resetLocalData => 'Скинути локальні дані';

  @override
  String get resetLocalDataWarning => 'Збережені профілі, облікові дані та налаштування пристрою буде видалено. Цю дію неможливо скасувати.';

  @override
  String get deleteLocalData => 'Видалити локальні дані';

  @override
  String get cancel => 'Скасувати';

  @override
  String get add => 'Додати';

  @override
  String get incomingTorrentTitle => 'Додати вхідний торрент?';

  @override
  String serverName(String name) {
    return 'Сервер: $name';
  }

  @override
  String get incomingTorrentFile => 'Один файл .torrent';

  @override
  String get incomingTorrentLink => 'Одне посилання';

  @override
  String get torrentFile => 'Файл торрента';

  @override
  String get unlockReason => 'Розблокувати Home qB Remote';

  @override
  String get downloadComplete => 'Завантаження завершено';

  @override
  String get downloadCompletePrivate => 'Завантаження завершено. Відкрийте застосунок, щоб переглянути його.';

  @override
  String get completionChannelName => 'Завершені завантаження';

  @override
  String get completionChannelDescription => 'Завершені завантаження на ваших серверах qBittorrent';

  @override
  String get integrationsTitle => 'Інтеграції';

  @override
  String get integrationsNotice => 'Необов\'язкові підключення до ваших серверів. Пошук ніколи не запускає завантаження автоматично.';

  @override
  String get integrationAddJackett => 'Додати Jackett';

  @override
  String get integrationAddJellyfin => 'Додати Jellyfin';

  @override
  String get integrationName => 'Назва профілю';

  @override
  String get integrationServerUrl => 'URL сервера';

  @override
  String get integrationApiKey => 'API-ключ';

  @override
  String get integrationAccessToken => 'Токен доступу користувача';

  @override
  String get integrationUserId => 'ID користувача Jellyfin';

  @override
  String get integrationSave => 'Зберегти профіль';

  @override
  String get integrationEdit => 'Редагувати профіль';

  @override
  String get integrationRemove => 'Видалити профіль';

  @override
  String get integrationRemoveConfirm => 'Видалити це підключення з застосунку? Дані на сервері не зміняться.';

  @override
  String get integrationCancel => 'Скасувати';

  @override
  String get integrationInvalidProfile => 'Введіть назву, коректний URL сервера HTTP(S) і необхідні облікові дані.';

  @override
  String get integrationStorageFailed => 'Захищене сховище інтеграцій недоступне. Наявні профілі збережено.';

  @override
  String get integrationRetry => 'Повторити';

  @override
  String get integrationHttpNotice => 'HTTP передає облікові дані без шифрування. Використовуйте його лише в надійній локальній мережі.';

  @override
  String get integrationSecretNotice => 'Облікові дані зберігаються в захищеному сховищі пристрою і надсилаються лише налаштованій службі.';

  @override
  String get integrationNoProfiles => 'Інтеграції не налаштовано.';

  @override
  String get jackettSearchTitle => 'Пошук Jackett';

  @override
  String get jackettSearchHint => 'Пошук у налаштованих індексаторах';

  @override
  String get jackettSearchAction => 'Знайти';

  @override
  String get jackettSearchEmpty => 'Відповідних результатів немає.';

  @override
  String get jackettSearchFailed => 'Не вдалося виконати пошук у Jackett. Перевірте сервер, API-ключ і налаштування індексаторів.';

  @override
  String get jackettDownloadFailed => 'Не вдалося отримати коректний торрент із налаштованого сервера Jackett.';

  @override
  String get jackettDownloadAction => 'Завантажити';

  @override
  String get jackettUnknownValue => 'Невідомо';

  @override
  String get jackettNoTarget => 'Виберіть сервер qBittorrent перед додаванням завантаження.';

  @override
  String get jackettAdded => 'Завантаження надіслано. Статус можна перевірити у списку торентів.';

  @override
  String get jellyfinLibraryTitle => 'Медіатека Jellyfin';

  @override
  String get jellyfinSearchHint => 'Пошук у медіатеці';

  @override
  String get jellyfinSearchAction => 'Знайти';

  @override
  String get jellyfinEmptyLibrary => 'Відповідних елементів у медіатеці немає.';

  @override
  String get jellyfinReadOnlyNotice => 'Перегляд наявної медіатеки. Відтворення поки що недоступне.';

  @override
  String get jellyfinConnectionFailed => 'Не вдалося підключитися до Jellyfin. Перевірте профіль і спробуйте знову.';

  @override
  String get jellyfinAuthenticationFailed => 'Jellyfin відхилив токен доступу або користувача.';

  @override
  String get jellyfinInvalidResponse => 'Jellyfin повернув некоректну або завелику відповідь.';

  @override
  String get jellyfinInvalidProfile => 'Введіть коректний URL сервера, токен доступу та ID користувача.';

  @override
  String get jellyfinRedirectBlocked => 'Jellyfin перенаправив запит за межі налаштованого сервера.';

  @override
  String get jellyfinRetry => 'Повторити';

  @override
  String get jellyfinClose => 'Закрити';

  @override
  String get searchDownloadConfirmTitle => 'Підтвердіть завантаження';

  @override
  String searchDownloadTarget(String name) {
    return 'Цільовий сервер: $name';
  }

  @override
  String get searchDownloadDataNotice => 'Посилання та метадані торрента буде надіслано на цей сервер qBittorrent. URL можуть містити облікові дані трекера.';

  @override
  String get searchResultUrlHidden => 'Адреси джерела та завантаження приховано, оскільки вони можуть містити облікові дані.';

  @override
  String get searchProfileChanged => 'Вибраний сервер змінився. Почніть новий пошук перед завантаженням.';

  @override
  String get searchAlreadyAdded => 'Цей торрент уже є на вибраному сервері або вже був надісланий.';

  @override
  String get searchAddOutcomeUnknown => 'Запит на завантаження міг дійти до сервера. Перевірте список торентів, перш ніж повторювати спробу.';

  @override
  String get searchCheckServer => 'Перевірити сервер';

  @override
  String get searchUnsupportedDownload => 'Для цього результату немає підтримуваного посилання для завантаження.';

  @override
  String get searchAddOptions => 'Параметри завантаження';

  @override
  String get searchConfirmAdd => 'Підтвердити і додати';

  @override
  String get torrentListFilterHint => 'Фільтр поточних торентів';

  @override
  String get clearTorrentListFilter => 'Скинути фільтр торентів';
}
