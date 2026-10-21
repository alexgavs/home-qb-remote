// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get message0001 => 'Не удалось прочитать защищённое хранилище профилей.';

  @override
  String get message0002 => 'Хранилище профилей недоступно. Изменения не сохранены; существующие данные сохранены.';

  @override
  String get message0003 => 'API-ключ нельзя сочетать с Basic auth обратного прокси: оба используют заголовок Authorization.';

  @override
  String get message0004 => 'Вход отклонён. Проверьте данные доступа и подключитесь к серверу ещё раз.';

  @override
  String get message0005 => 'Выберите сервер';

  @override
  String get message0006 => 'Выбранный файл не является корректным .torrent. Данные не отправлены.';

  @override
  String get message0007 => 'Операция не выполнена. Проверьте соединение и настройки сервера.';

  @override
  String get message0008 => 'Имя пользователя HTTP Basic не может содержать двоеточие.';

  @override
  String get message0009 => 'Используйте либо API-ключ, либо учетные данные HTTP Basic, но не оба сразу.';

  @override
  String get message0010 => 'API-ключ содержит пробелы, переносы строк или недопустимые символы.';

  @override
  String get message0011 => 'Укажите и клиентский сертификат, и его закрытый ключ.';

  @override
  String get message0012 => 'Не удалось загрузить пользовательский CA или клиентский сертификат.';

  @override
  String get message0013 => 'Укажите URL сервера HTTP или HTTPS без встроенных учетных данных, параметров запроса и фрагмента.';

  @override
  String get message0014 => 'Недопустимый адрес API.';

  @override
  String get message0015 => 'Соединение с сервером закрыто.';

  @override
  String get message0016 => 'Сервер не ответил на проверку API-ключа. Проверьте URL сервера и настройки доступа к WebUI.';

  @override
  String get message0017 => 'Не удалось войти. Проверьте учетные данные сервера и настройки доступа к WebUI.';

  @override
  String get message0018 => 'Сервер отклонил API-ключ. Проверьте ключ и настройки доступа к WebUI, затем подключитесь снова.';

  @override
  String get message0019 => 'Вход отклонен. Проверьте учетные данные сервера и настройки доступа к WebUI, затем подключитесь снова.';

  @override
  String get message0020 => 'Сначала войдите на сервер.';

  @override
  String get message0021 => 'Сервер вернул некорректный JSON.';

  @override
  String get message0022 => 'Сервер не смог выполнить действие.';

  @override
  String get message0023 => 'Сервер вернул некорректный список торрентов.';

  @override
  String get message0024 => 'Сначала выберите корректные торренты.';

  @override
  String get message0025 => 'Введите URL торрента или magnet-ссылку.';

  @override
  String get message0026 => 'Выберите непустой торрент-файл.';

  @override
  String get message0027 => 'Выберите торрент-файл с именем.';

  @override
  String get message0028 => 'Некорректное поле параметров торрента.';

  @override
  String get message0029 => 'Сервер отклонил торрент-файл.';

  @override
  String get message0030 => 'Сервер вернул некорректные сведения о торренте.';

  @override
  String get message0031 => 'Истекло время ожидания ответа сервера.';

  @override
  String get message0032 => 'Сервер вернул некорректное перенаправление.';

  @override
  String get message0033 => 'Сервер вернул слишком много перенаправлений.';

  @override
  String message0034(String arg1) {
    return 'Сервер отклонил запрос (HTTP $arg1).';
  }

  @override
  String get message0035 => 'Ответ сервера слишком большой.';

  @override
  String get message0036 => 'Не удается подключиться к серверу. Проверьте его адрес и подключение.';

  @override
  String get message0037 => 'Не удалось подключиться к серверу.';

  @override
  String get message0038 => 'Сервер вернул некорректный ответ.';

  @override
  String get message0039 => 'Ошибка запроса к серверу.';

  @override
  String get message0040 => 'Сеанс истек. Войдите снова.';

  @override
  String get message0041 => 'Сервер отклонил запрос (HTTP 403).';

  @override
  String get message0042 => 'Операция не выполнена';

  @override
  String get message0043 => 'Отмена';

  @override
  String get message0044 => 'Применить';

  @override
  String get message0045 => 'Инструменты сервера';

  @override
  String get message0046 => 'Нет сервера';

  @override
  String get message0047 => 'Прямое подключение к вашему qBittorrent. Рекламы и аналитики нет.';

  @override
  String get message0048 => 'Поиск торрентов';

  @override
  String get message0049 => 'Поисковые плагины вашего сервера';

  @override
  String get message0050 => 'RSS и правила загрузки';

  @override
  String get message0051 => 'Ленты, статьи, автоматические правила';

  @override
  String get message0052 => 'Скорость и режим лимитов';

  @override
  String get message0053 => 'Лимиты загрузки и отдачи в КиБ/с';

  @override
  String get message0054 => 'Настройки qBittorrent';

  @override
  String get message0055 => 'Все доступные параметры WebUI API';

  @override
  String get message0056 => 'Категории и метки';

  @override
  String get message0057 => 'Создание, изменение и удаление';

  @override
  String get message0058 => 'Журнал сервера';

  @override
  String get message0059 => 'Основной журнал и заблокированные пиры';

  @override
  String get message0060 => 'Состояние соединения';

  @override
  String get message0061 => 'Скорости, переданные данные и DHT';

  @override
  String get message0062 => 'Magic packet в вашей локальной сети';

  @override
  String get message0063 => 'Ограничения скорости';

  @override
  String get message0064 => 'Загрузка, КиБ/с (0 — без лимита)';

  @override
  String get message0065 => 'Отдача, КиБ/с (0 — без лимита)';

  @override
  String get message0066 => 'Альтернативный режим (true/false)';

  @override
  String get message0067 => 'Лимиты сохранены';

  @override
  String get message0068 => 'MAC-адрес';

  @override
  String get message0069 => 'Broadcast-адрес';

  @override
  String get message0070 => 'Порт';

  @override
  String get message0071 => 'Magic packet отправлен';

  @override
  String get message0072 => 'Настройка недоступна. Проверьте разрешения и защиту устройства.';

  @override
  String get message0073 => 'Настройки устройства';

  @override
  String get message0074 => 'Блокировка приложения';

  @override
  String get message0075 => 'Аутентификация средствами ОС при открытии и возвращении в приложение.';

  @override
  String get message0076 => 'Уведомления о завершении';

  @override
  String get message0077 => 'Проверка при открытом приложении. Для уведомлений приложение должно работать.';

  @override
  String get message0078 => 'Прямой опрос qBittorrent. Фоновое выполнение ограничивается ОС; мгновенная доставка не гарантируется.';

  @override
  String get message0079 => 'Интервал фоновой проверки';

  @override
  String message0080(String arg1) {
    return '$arg1 мин. ОС может отложить запуск.';
  }

  @override
  String get message0081 => 'Интервал, минуты';

  @override
  String get message0082 => 'От 15 до 1440 минут';

  @override
  String get message0083 => 'Сохранить';

  @override
  String get message0084 => 'Без рекламы и аналитики';

  @override
  String get message0085 => 'Нет Firebase, рекламных SDK, удалённой конфигурации и регистрации у разработчика. Профили и сертификаты хранятся в защищённом хранилище ОС.';

  @override
  String get message0086 => 'Сетевые соединения';

  @override
  String get message0087 => 'Клиент обращается к заданным вами серверам qBittorrent. Wake-on-LAN отправляет пакет на введённый локальный адрес. Поиск и RSS выполняет ваш сервер.';

  @override
  String get message0088 => 'Защита соединения';

  @override
  String get message0089 => 'Для удалённого доступа используйте HTTPS или VPN. Проверка сертификата включена; собственный CA и клиентский PEM-сертификат задаются в профиле.';

  @override
  String get message0090 => 'Заполните поле';

  @override
  String get message0091 => 'Подтвердить';

  @override
  String get message0092 => 'Укажите целое число не меньше нуля';

  @override
  String get message0093 => 'Б';

  @override
  String get message0094 => 'КиБ';

  @override
  String get message0095 => 'МиБ';

  @override
  String get message0096 => 'ГиБ';

  @override
  String get message0097 => 'ТиБ';

  @override
  String get message0098 => 'Операция RSS не выполнена';

  @override
  String get message0099 => 'Обновить';

  @override
  String get message0100 => 'Добавить';

  @override
  String get message0101 => 'Добавить ленту';

  @override
  String get message0102 => 'Создать папку';

  @override
  String get message0103 => 'Добавить правило';

  @override
  String get message0104 => 'Действия с папкой';

  @override
  String get message0105 => 'Статьи';

  @override
  String get message0106 => 'Ленты';

  @override
  String get message0107 => 'Правила';

  @override
  String get message0108 => 'В лентах пока нет статей';

  @override
  String get message0109 => 'Без названия';

  @override
  String get message0110 => 'Торрент добавлен';

  @override
  String get message0111 => 'Добавить торрент';

  @override
  String get message0112 => 'Отметить прочитанной';

  @override
  String get message0113 => 'Добавьте первую RSS-ленту через +';

  @override
  String get message0114 => 'Обновить ленту';

  @override
  String get message0115 => 'Отметить всё прочитанным';

  @override
  String get message0116 => 'Переместить / переименовать';

  @override
  String get message0117 => 'Удалить ленту';

  @override
  String get message0118 => 'Нет правил автоматической загрузки';

  @override
  String get message0119 => 'Изменить';

  @override
  String get message0120 => 'Переименовать';

  @override
  String get message0121 => 'Подходящие статьи';

  @override
  String get message0122 => 'Удалить правило';

  @override
  String get message0123 => 'Папка RSS';

  @override
  String get message0124 => 'Полный путь папки';

  @override
  String get message0125 => 'Действие с папкой';

  @override
  String get message0126 => 'Удалить папку';

  @override
  String get message0127 => 'Новая RSS-лента';

  @override
  String get message0128 => 'Новая папка RSS';

  @override
  String get message0129 => 'URL ленты';

  @override
  String get message0130 => 'Путь и имя ленты (необязательно)';

  @override
  String get message0131 => 'Путь новой папки';

  @override
  String get message0132 => 'Новый путь RSS';

  @override
  String get message0133 => 'Путь и новое имя';

  @override
  String get message0134 => 'Удалить элемент RSS?';

  @override
  String message0135(String arg1) {
    return 'Будет удалён «$arg1» и его содержимое RSS. Файлы торрентов не затрагиваются.';
  }

  @override
  String get message0136 => 'Удалить правило?';

  @override
  String get message0137 => 'Имя правила';

  @override
  String get message0138 => 'Новое имя';

  @override
  String message0139(String arg1) {
    return 'Подходящие статьи: $arg1';
  }

  @override
  String get message0140 => 'Нет подходящих статей';

  @override
  String get message0141 => 'Закрыть';

  @override
  String get message0142 => 'Новое правило RSS';

  @override
  String get message0143 => 'Правило RSS';

  @override
  String get message0144 => 'Должно содержать';

  @override
  String get message0145 => 'Не должно содержать';

  @override
  String get message0146 => 'Фильтр серий';

  @override
  String get message0147 => 'URL лент, каждый с новой строки';

  @override
  String get message0148 => 'Категория';

  @override
  String get message0149 => 'Путь сохранения';

  @override
  String get message0150 => 'Не загружать повторно, дней';

  @override
  String get message0151 => 'Укажите имя правила';

  @override
  String get message0152 => 'Правило включено';

  @override
  String get message0153 => 'Регулярные выражения';

  @override
  String get message0154 => 'Умный фильтр серий';

  @override
  String get message0155 => 'Добавлять на паузе';

  @override
  String get message0156 => 'Поисковые плагины недоступны';

  @override
  String get message0157 => 'Поиск на вашем сервере…';

  @override
  String message0158(int arg1, String arg2) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 результата',
      many: '$arg1 результатов',
      few: '$arg1 результата',
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
      other: '$arg1 результата',
      many: '$arg1 результатов',
      few: '$arg1 результата',
      one: '$arg1 результат',
    );
    return '$_temp0 · поиск остановлен через 2 минуты';
  }

  @override
  String get message0161 => 'Поиск не выполнен';

  @override
  String get message0162 => 'Не удалось остановить поиск';

  @override
  String message0163(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 результата',
      many: '$arg1 результатов',
      few: '$arg1 результата',
      one: '$arg1 результат',
    );
    return '$_temp0 · остановлено';
  }

  @override
  String get message0164 => 'Поиск на сервере';

  @override
  String get message0165 => 'Плагины поиска';

  @override
  String get message0166 => 'Название торрента';

  @override
  String get message0167 => 'Стоп';

  @override
  String get message0168 => 'Найти';

  @override
  String get message0169 => 'Плагин';

  @override
  String get message0170 => 'Все плагины';

  @override
  String get message0171 => 'Только включённые';

  @override
  String get message0172 => 'Все';

  @override
  String get message0173 => 'Книги';

  @override
  String get message0174 => 'Игры';

  @override
  String get message0175 => 'Фильмы';

  @override
  String get message0176 => 'Музыка';

  @override
  String get message0177 => 'Программы';

  @override
  String get message0178 => 'Сериалы';

  @override
  String get message0179 => 'Введите запрос для поиска';

  @override
  String message0180(String arg1, String arg2, String arg3) {
    return '$arg1 · сиды $arg2\n$arg3';
  }

  @override
  String get message0181 => 'Добавить на сервер';

  @override
  String get message0182 => 'Не удалось добавить торрент';

  @override
  String get message0183 => 'Не удалось изменить плагины';

  @override
  String get message0184 => 'Установить поисковый плагин';

  @override
  String get message0185 => 'URL файла плагина';

  @override
  String get message0186 => 'Плагин будет скачан и установлен на вашем сервере qBittorrent. Указывайте доверенный источник.';

  @override
  String get message0187 => 'Поисковые плагины';

  @override
  String get message0188 => 'Обновить плагины';

  @override
  String get message0189 => 'Установить плагин';

  @override
  String get message0190 => 'На сервере нет поисковых плагинов';

  @override
  String message0191(String arg1) {
    return 'Версия $arg1';
  }

  @override
  String get message0192 => 'Удалить плагин';

  @override
  String get message0193 => 'Удалить плагин?';

  @override
  String get message0194 => 'Новая категория';

  @override
  String get message0195 => 'Изменить категорию';

  @override
  String get message0196 => 'Название';

  @override
  String get message0197 => 'Папка на сервере';

  @override
  String get message0198 => 'Категории';

  @override
  String get message0199 => 'Удалить категорию';

  @override
  String get message0200 => 'Удалить категорию?';

  @override
  String message0201(String arg1) {
    return '$arg1. Торренты и файлы сохранятся.';
  }

  @override
  String get message0202 => 'Теги';

  @override
  String get message0203 => 'Создать теги';

  @override
  String get message0204 => 'Новые теги';

  @override
  String get message0205 => 'Названия через запятую';

  @override
  String get message0206 => 'Удалить тег';

  @override
  String get message0207 => 'Удалить тег?';

  @override
  String message0208(String arg1) {
    return '$arg1. Торренты и файлы сохранятся.';
  }

  @override
  String get message0209 => 'Обычный';

  @override
  String get message0210 => 'Информация';

  @override
  String get message0211 => 'Предупреждение';

  @override
  String get message0212 => 'Критический';

  @override
  String get message0213 => 'Сообщение';

  @override
  String get message0214 => 'Журнал пиров';

  @override
  String get message0215 => 'Уровень';

  @override
  String get message0216 => 'Все сообщения';

  @override
  String get message0217 => 'Предупреждения';

  @override
  String get message0218 => 'Критические';

  @override
  String get message0219 => 'Заблокирован';

  @override
  String get message0220 => 'Разрешён';

  @override
  String get message0221 => 'Скорость загрузки';

  @override
  String get message0222 => 'Скорость отдачи';

  @override
  String get message0223 => 'Получено за сессию';

  @override
  String get message0224 => 'Отдано за сессию';

  @override
  String get message0225 => 'Лимит загрузки';

  @override
  String get message0226 => 'Лимит отдачи';

  @override
  String get message0227 => 'Узлы DHT';

  @override
  String get message0228 => 'Соединение';

  @override
  String message0229(String arg1) {
    return '$arg1/с';
  }

  @override
  String get message0230 => 'Подключено';

  @override
  String get message0231 => 'За NAT / firewall';

  @override
  String get message0232 => 'Нет соединения';

  @override
  String get message0233 => 'Категории и теги';

  @override
  String get message0234 => 'Состояние сервера';

  @override
  String get message0235 => 'Не удалось получить настройки';

  @override
  String get message0236 => 'Изменить WebUI?';

  @override
  String get message0237 => 'Изменение адреса, порта или авторизации может разорвать подключение.';

  @override
  String get message0238 => 'Настройки сохранены. Если изменились адрес, порт или пароль WebUI, обновите профиль подключения.';

  @override
  String get message0239 => 'Настройки сохранены';

  @override
  String get message0240 => 'Не удалось сохранить настройки';

  @override
  String get message0241 => 'Введите целое число';

  @override
  String get message0242 => 'Порт от 1 до 65535';

  @override
  String get message0243 => 'Час от 0 до 23';

  @override
  String get message0244 => 'Минута от 0 до 59';

  @override
  String get message0245 => 'Минимум −1 (если поддерживается сервером)';

  @override
  String get message0246 => 'Расширенные параметры JSON';

  @override
  String get message0247 => 'Все параметры текущего сервера. Сохраняются только изменённые ключи.';

  @override
  String get message0248 => 'Некорректный JSON параметров';

  @override
  String get message0249 => 'Загрузки';

  @override
  String get message0250 => 'Папка сохранения';

  @override
  String get message0251 => 'Папка временных файлов';

  @override
  String get message0252 => 'Использовать временную папку';

  @override
  String get message0253 => 'Добавлять остановленными';

  @override
  String get message0254 => 'Автоматическое управление';

  @override
  String get message0255 => 'Выделять место заранее';

  @override
  String get message0256 => 'Расширение для незавершённых файлов';

  @override
  String get message0257 => 'Папка экспорта .torrent';

  @override
  String get message0258 => 'Экспорт завершённых .torrent';

  @override
  String get message0259 => 'Входящий порт';

  @override
  String get message0260 => 'Случайный порт при запуске';

  @override
  String get message0261 => 'Максимум соединений (-1 — без лимита)';

  @override
  String get message0262 => 'Соединений на торрент';

  @override
  String get message0263 => 'Слотов отдачи';

  @override
  String get message0264 => 'Адрес прокси';

  @override
  String get message0265 => 'Порт прокси';

  @override
  String get message0266 => 'Пользователь прокси';

  @override
  String get message0267 => 'Пароль прокси';

  @override
  String get message0268 => 'Скорость';

  @override
  String get message0269 => 'Загрузка, байт/с (0 — без лимита)';

  @override
  String get message0270 => 'Отдача, байт/с (0 — без лимита)';

  @override
  String get message0271 => 'Альтернативная загрузка, байт/с';

  @override
  String get message0272 => 'Альтернативная отдача, байт/с';

  @override
  String get message0273 => 'Расписание альтернативных лимитов';

  @override
  String get message0274 => 'Начало: час';

  @override
  String get message0275 => 'Начало: минута';

  @override
  String get message0276 => 'Конец: час';

  @override
  String get message0277 => 'Конец: минута';

  @override
  String get message0278 => 'Учитывать служебный трафик';

  @override
  String get message0279 => 'Ограничивать локальных пиров';

  @override
  String get message0280 => 'Обмен пирами (PeX)';

  @override
  String get message0281 => 'Обнаружение локальных пиров';

  @override
  String get message0282 => 'Анонимный режим';

  @override
  String get message0283 => 'Очередь торрентов';

  @override
  String get message0284 => 'Активных загрузок';

  @override
  String get message0285 => 'Активных раздач';

  @override
  String get message0286 => 'Активных торрентов';

  @override
  String get message0287 => 'Не учитывать медленные торренты';

  @override
  String get message0288 => 'Добавлять трекеры автоматически';

  @override
  String get message0289 => 'Дополнительные трекеры';

  @override
  String get message0290 => 'Адрес прослушивания';

  @override
  String get message0291 => 'Порт WebUI';

  @override
  String get message0292 => 'Имя пользователя';

  @override
  String get message0293 => 'Новый пароль';

  @override
  String get message0294 => 'Авторизация localhost';

  @override
  String get message0295 => 'Защита CSRF';

  @override
  String get message0296 => 'Защита от clickjacking';

  @override
  String get message0297 => 'Время сессии, секунд';

  @override
  String get message0298 => 'Получать RSS-ленты';

  @override
  String get message0299 => 'Автозагрузка по правилам';

  @override
  String get message0300 => 'Интервал обновления, минут';

  @override
  String get message0301 => 'Статей в ленте';

  @override
  String get message0302 => 'Шаблоны серий';

  @override
  String get message0303 => 'Все параметры (JSON)';

  @override
  String get message0304 => 'Расширенные параметры и опции вашей версии сервера';

  @override
  String get message0305 => 'Не удалось выполнить действие';

  @override
  String get message0306 => 'Изменения применены';

  @override
  String get message0307 => 'Управление торрентом';

  @override
  String get message0308 => 'Организация';

  @override
  String get message0309 => 'Имя торрента';

  @override
  String get message0310 => 'Переименовать торрент';

  @override
  String get message0311 => 'Переместить файлы';

  @override
  String get message0312 => 'Новый путь на сервере';

  @override
  String get message0313 => 'Полный путь';

  @override
  String get message0314 => 'Перемещение выполняет qBittorrent на сервере';

  @override
  String get message0315 => 'Добавить метки';

  @override
  String get message0316 => 'Метки через запятую';

  @override
  String get message0317 => 'Снять метки';

  @override
  String get message0318 => 'Скорость и раздача';

  @override
  String get message0319 => 'Лимиты скорости';

  @override
  String get message0320 => 'Условия окончания раздачи';

  @override
  String get message0321 => 'Принудительный запуск';

  @override
  String get message0322 => 'Суперсидирование';

  @override
  String get message0323 => 'Переключить последовательную загрузку';

  @override
  String get message0324 => 'Переключить приоритет первого и последнего фрагментов';

  @override
  String get message0325 => 'Перепроверить файлы';

  @override
  String get message0326 => 'Перепроверить файлы?';

  @override
  String get message0327 => 'Проверка может занять время и временно приостановить передачу.';

  @override
  String get message0328 => 'Обновить объявления трекерам';

  @override
  String get message0329 => 'Очередь';

  @override
  String get message0330 => 'В начало очереди';

  @override
  String get message0331 => 'Поднять выше';

  @override
  String get message0332 => 'Опустить ниже';

  @override
  String get message0333 => 'В конец очереди';

  @override
  String get message0334 => 'Содержимое и соединения';

  @override
  String get message0335 => 'Экспортировать .torrent';

  @override
  String get message0336 => 'Файлы и приоритеты';

  @override
  String get message0337 => 'Переименовать папку';

  @override
  String get message0338 => 'Текущий путь внутри торрента';

  @override
  String get message0339 => 'Новый путь внутри торрента';

  @override
  String get message0340 => 'Трекеры';

  @override
  String get message0341 => 'Пиры';

  @override
  String get message0342 => 'HTTP-источники';

  @override
  String get message0343 => 'Состояние фрагментов';

  @override
  String get message0344 => 'Без категории';

  @override
  String get message0345 => 'Загрузка, КиБ/с';

  @override
  String get message0346 => 'Отдача, КиБ/с';

  @override
  String get message0347 => '0 — без ограничения. 1 КиБ/с = 1024 байта/с.';

  @override
  String get message0348 => 'Рейтинг';

  @override
  String get message0349 => 'Укажите число';

  @override
  String get message0350 => 'Время раздачи, минуты';

  @override
  String get message0351 => 'Укажите целое число';

  @override
  String get message0352 => 'Время неактивной раздачи, минуты';

  @override
  String get message0353 => '-2 — использовать настройки сервера, -1 — без ограничения.';

  @override
  String get message0354 => 'Включить';

  @override
  String get message0355 => 'Выключить';

  @override
  String get message0356 => 'Файлы';

  @override
  String message0357(String arg1, String arg2) {
    return '$arg1 · приоритет $arg2';
  }

  @override
  String get message0358 => 'Переименовать файл';

  @override
  String get message0359 => 'Изменения применены. Откройте список заново для обновления.';

  @override
  String get message0360 => 'Действие не выполнено';

  @override
  String get message0361 => 'Не скачивать';

  @override
  String get message0362 => 'Обычный приоритет';

  @override
  String get message0363 => 'Высокий приоритет';

  @override
  String get message0364 => 'Максимальный приоритет';

  @override
  String get message0365 => 'Изменить трекер';

  @override
  String get message0366 => 'Новый URL';

  @override
  String get message0367 => 'Удалить трекер?';

  @override
  String get message0368 => 'Не удалось изменить трекер';

  @override
  String get message0369 => 'Удалить';

  @override
  String get message0370 => 'Добавить трекеры';

  @override
  String get message0371 => 'URL, каждый с новой строки';

  @override
  String get message0372 => 'Не удалось добавить трекеры';

  @override
  String get message0373 => 'Нет подключённых пиров';

  @override
  String message0374(String arg1, String arg2) {
    return '$arg1 · ↓ $arg2/с';
  }

  @override
  String get message0375 => 'Добавить пиров';

  @override
  String get message0376 => 'IP:порт, разделитель |';

  @override
  String get message0377 => 'Не удалось добавить пиров';

  @override
  String message0378(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 фрагмента',
      many: '$arg1 фрагментов',
      few: '$arg1 фрагмента',
      one: '$arg1 фрагмент',
    );
    return '$_temp0';
  }

  @override
  String get message0379 => 'Серый — нет, синий — загружается, зелёный — готов. Показаны первые 4096 фрагментов.';

  @override
  String message0380(String arg1) {
    return 'Фрагмент $arg1';
  }

  @override
  String get message0381 => 'Экспорт выполнен';

  @override
  String get message0382 => 'Экспорт отменён';

  @override
  String get message0383 => 'Укажите URL';

  @override
  String get message0384 => 'URL не должен содержать пробелы, управляющие символы и «|»';

  @override
  String get message0385 => 'Укажите адрес http:// или https:// с именем узла';

  @override
  String get message0386 => 'Укажите хотя бы один URL';

  @override
  String get message0387 => 'Сервер не поддерживает изменение HTTP-источников. ';

  @override
  String get message0388 => 'Нужен qBittorrent 5.2 или новее; доступен только просмотр.';

  @override
  String get message0389 => 'Не удалось загрузить HTTP-источники';

  @override
  String get message0390 => 'Добавить HTTP-источники';

  @override
  String get message0391 => 'Адреса передаёт серверу qBittorrent; приложение не обращается к ним напрямую.';

  @override
  String get message0392 => 'Не удалось добавить HTTP-источники';

  @override
  String get message0393 => 'Изменить HTTP-источник';

  @override
  String get message0394 => 'Адрес не изменился';

  @override
  String get message0395 => 'Не удалось изменить HTTP-источник';

  @override
  String get message0396 => 'Удалить HTTP-источник?';

  @override
  String get message0397 => 'Не удалось удалить HTTP-источник';

  @override
  String get message0398 => 'Добавить источники';

  @override
  String get message0399 => 'Изменение HTTP-источников требует qBittorrent 5.2 или новее. ';

  @override
  String get message0400 => 'Более ранний сервер может отклонить изменения.';

  @override
  String get message0401 => 'Повторить';

  @override
  String get message0402 => 'HTTP-источников нет';

  @override
  String get message0403 => 'Не удалось инициализировать защищённое хранилище.';

  @override
  String get message0404 => 'Добавить входящий торрент?';

  @override
  String message0405(String arg1) {
    return 'Сервер: $arg1';
  }

  @override
  String get message0406 => 'Один .torrent-файл';

  @override
  String get message0407 => 'Одна ссылка';

  @override
  String get message0408 => 'Файл .torrent';

  @override
  String get message0409 => 'Не удалось удалить локальные данные.';

  @override
  String get message0410 => 'Домашний qB заблокирован';

  @override
  String get message0411 => 'Открыть';

  @override
  String get message0412 => 'Сбросить локальные данные';

  @override
  String get message0413 => 'Будут удалены профили, пароли и сертификаты с этого устройства. Торренты на сервере сохранятся.';

  @override
  String get message0414 => 'Удалить локальные данные';

  @override
  String get message0415 => 'Не удалось прочитать настройки устройства из защищенного хранилища.';

  @override
  String get message0416 => 'Не удалось запланировать фоновый опрос на этом устройстве.';

  @override
  String get message0417 => 'Фоновый опрос доступен на Android и iOS. Уведомления на компьютере требуют, чтобы приложение оставалось открытым.';

  @override
  String get message0418 => 'Уведомления не настроены на этой платформе.';

  @override
  String get message0419 => 'Системные уведомления недоступны.';

  @override
  String get message0420 => 'Не удалось инициализировать системные уведомления.';

  @override
  String get message0421 => 'Android может задерживать опрос из-за ограничений батареи, сети или фоновой работы.';

  @override
  String get message0422 => 'Выберите интервал опроса от 15 до 1440 минут.';

  @override
  String get message0423 => 'Новый интервал сохранен, но фоновое расписание обновить не удалось.';

  @override
  String get message0424 => 'Уведомления недоступны.';

  @override
  String get message0425 => 'Разрешение на уведомления не предоставлено.';

  @override
  String get message0426 => 'Не удалось обновить фоновое расписание. Проверки уведомлений в открытом приложении продолжают работать.';

  @override
  String get message0427 => 'Разблокировать Home qB Remote';

  @override
  String get message0428 => 'Аутентификация устройства не завершена.';

  @override
  String get message0429 => 'Не удалось включить защиту снимков экрана.';

  @override
  String get message0430 => 'Не удалось удалить системные уведомления.';

  @override
  String get message0431 => 'Не удалось отменить фоновую проверку.';

  @override
  String get message0432 => 'Загрузка завершена';

  @override
  String get message0433 => 'Загрузка завершена. Откройте приложение для просмотра.';

  @override
  String get message0434 => 'Завершение загрузок';

  @override
  String get message0435 => 'Завершённые загрузки на ваших серверах qBittorrent';

  @override
  String get message0436 => 'Лимит фонового сканирования исчерпан.';

  @override
  String get message0437 => 'Можно импортировать только локальный документ .torrent.';

  @override
  String get message0438 => 'Импорт документов не поддерживается на этой платформе.';

  @override
  String get message0439 => 'Импорт документов недоступен в этой сборке приложения.';

  @override
  String get message0440 => 'Документ отклонен системой.';

  @override
  String get message0441 => 'Не удалось прочитать торрент-документ.';

  @override
  String get message0442 => 'Торрент-документ пуст.';

  @override
  String get message0443 => 'Торрент-документ больше 16 МиБ и не может быть импортирован.';

  @override
  String get message0444 => 'Документ не является допустимым файлом .torrent.';

  @override
  String get message0445 => 'Русский';

  @override
  String get message0446 => 'Українська';

  @override
  String get message0447 => 'Неподдерживаемый язык';

  @override
  String get message0448 => 'Другой экспорт еще выполняется.';

  @override
  String get message0449 => 'Экспорт не поддерживается на этой платформе.';

  @override
  String get message0450 => 'Нет данных торрента для экспорта.';

  @override
  String get message0451 => 'Торрент-файл больше 16 МиБ и не может быть экспортирован.';

  @override
  String get message0452 => 'Данные торрента не являются допустимой последовательностью байтов.';

  @override
  String get message0453 => 'Экспорт недоступен в этой сборке приложения.';

  @override
  String get message0454 => 'Данные торрента отклонены системой.';

  @override
  String get message0455 => 'Не удалось сохранить торрент-файл.';

  @override
  String get message0456 => 'Не удалось открыть диалог сохранения.';

  @override
  String get message0457 => 'Не удалось записать торрент-файл в выбранное место.';

  @override
  String get message0458 => 'Введите целое число от 0';

  @override
  String get message0459 => 'Новая загрузка';

  @override
  String get message0460 => 'Magnet-ссылки или URL';

  @override
  String get message0461 => 'Каждая ссылка — с новой строки';

  @override
  String get message0462 => 'Выбрать .torrent-файл';

  @override
  String get message0463 => 'Параметры загрузки';

  @override
  String get message0464 => 'Теги через запятую';

  @override
  String get message0465 => 'Новое имя (необязательно)';

  @override
  String get message0466 => 'Лимит загрузки, КиБ/с';

  @override
  String get message0467 => '0 — без ограничения; пусто — настройка сервера';

  @override
  String get message0468 => 'Лимит отдачи, КиБ/с';

  @override
  String get message0469 => 'Структура файлов';

  @override
  String get message0470 => 'Как в торренте';

  @override
  String get message0471 => 'Создать подпапку';

  @override
  String get message0472 => 'Без подпапки';

  @override
  String get message0473 => 'Добавить остановленным';

  @override
  String get message0474 => 'Последовательная загрузка';

  @override
  String get message0475 => 'Сначала начало и конец';

  @override
  String get message0476 => 'Пароль PKCS#12';

  @override
  String get message0477 => 'Пароль контейнера';

  @override
  String get message0478 => 'Импортировать';

  @override
  String get message0479 => 'Домашний qB';

  @override
  String get message0480 => 'Управление серверами';

  @override
  String get message0481 => 'Настройки приложения';

  @override
  String get message0482 => 'ВАШЕ ПОДКЛЮЧЕНИЕ';

  @override
  String get message0483 => 'Сервер не выбран';

  @override
  String get message0484 => 'Серверы';

  @override
  String get message0485 => 'RSS, поиск, настройки';

  @override
  String get message0486 => 'Загрузка';

  @override
  String get message0487 => 'Раздача';

  @override
  String get message0488 => 'Пауза';

  @override
  String get message0489 => 'Ошибки';

  @override
  String get message0490 => 'Все торренты';

  @override
  String get message0491 => 'Только ваши серверы.\nБез рекламы и телеметрии.';

  @override
  String get message0492 => 'Ваши загрузки — под рукой';

  @override
  String get message0493 => 'Подключите домашний qBittorrent через Web UI.\nАдрес сервера и настройки хранятся на этом устройстве.';

  @override
  String get message0494 => 'Подключить сервер';

  @override
  String get message0495 => 'Обзор загрузок';

  @override
  String get message0496 => 'Текущий сервер';

  @override
  String message0497(String arg1) {
    return '$arg1/с';
  }

  @override
  String message0498(String arg1) {
    return '$arg1/с';
  }

  @override
  String get message0499 => 'Торренты';

  @override
  String get message0500 => 'Найти торрент по имени';

  @override
  String message0501(String arg1) {
    return 'Выбрано: $arg1';
  }

  @override
  String get message0502 => 'Продолжить выбранные';

  @override
  String get message0503 => 'Приостановить выбранные';

  @override
  String get message0504 => 'Удалить выбранные';

  @override
  String get message0505 => 'Снять выделение';

  @override
  String get message0506 => 'Ничего не найдено';

  @override
  String get message0507 => 'Пока нет торрентов';

  @override
  String get message0508 => 'Добавьте magnet-ссылку, URL или .torrent-файл.';

  @override
  String get message0509 => 'Продолжить';

  @override
  String get message0510 => 'Приостановить';

  @override
  String get message0511 => 'Действия';

  @override
  String get message0512 => 'Подробнее';

  @override
  String get message0513 => 'Удалить…';

  @override
  String message0514(String arg1) {
    return '↓ $arg1/с';
  }

  @override
  String message0515(String arg1) {
    return '↑ $arg1/с';
  }

  @override
  String get message0516 => 'Не удалось выполнить действие. Проверьте подключение к серверу.';

  @override
  String get message0517 => 'Мои серверы';

  @override
  String get message0518 => 'Настройки сервера';

  @override
  String get message0519 => 'Редактировать';

  @override
  String get message0520 => 'Удалить профиль';

  @override
  String get message0521 => 'Добавить сервер';

  @override
  String get message0522 => 'Удалить профиль?';

  @override
  String message0523(String arg1) {
    return 'Профиль «$arg1» будет удалён с этого устройства. Торренты на сервере сохранятся.';
  }

  @override
  String get message0524 => 'Использовать локальный HTTP?';

  @override
  String get message0525 => 'SSID не подтверждает подлинность сети. В другой сети с таким же именем пароль может попасть к постороннему серверу. Для защиты используйте HTTPS с проверкой сертификата или VPN.';

  @override
  String get message0526 => 'Выберите .torrent-файл размером до 16 МБ.';

  @override
  String get message0527 => 'Не удалось открыть выбранный файл.';

  @override
  String get message0528 => 'Удалить торрент?';

  @override
  String message0529(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: 'Удалить $arg1 торрента?',
      many: 'Удалить $arg1 торрентов?',
      few: 'Удалить $arg1 торрента?',
      one: 'Удалить $arg1 торрент?',
    );
    return '$_temp0';
  }

  @override
  String get message0530 => 'По умолчанию загруженные файлы останутся на сервере.';

  @override
  String get message0531 => 'Также удалить файлы с сервера';

  @override
  String get message0532 => 'Это действие нельзя отменить';

  @override
  String get message0533 => 'Домашний сервер';

  @override
  String get message0534 => 'Не удалось импортировать PKCS#12. Проверьте пароль и файл (до 4 МБ).';

  @override
  String get message0535 => 'Укажите название';

  @override
  String get message0536 => 'Адрес Web UI';

  @override
  String get message0537 => 'HTTP или HTTPS, включая порт и путь';

  @override
  String get message0538 => 'Укажите полный HTTP(S)-адрес сервера';

  @override
  String get message0539 => 'Уберите пароль, параметры и # из адреса';

  @override
  String get message0540 => 'Пароль';

  @override
  String get message0541 => 'Скрыть пароль';

  @override
  String get message0542 => 'Показать пароль';

  @override
  String get message0543 => 'API-ключ (необязательно)';

  @override
  String get message0544 => 'qBittorrent 5.2+. При заполнении используется вместо имени и пароля.';

  @override
  String get message0545 => 'API-ключ нельзя сочетать с Basic auth прокси';

  @override
  String get message0546 => 'Локальный адрес по Wi-Fi';

  @override
  String get message0547 => 'Необязательно. SSID используется только на устройстве для выбора адреса. ОС может запросить разрешение геолокации для чтения имени Wi-Fi; координаты не считываются.';

  @override
  String get message0548 => 'Локальный URL';

  @override
  String get message0549 => 'Укажите HTTP(S)-адрес без пароля и параметров';

  @override
  String get message0550 => 'Домашняя Wi-Fi сеть (SSID)';

  @override
  String get message0551 => 'SSID недоступен. Можно ввести имя сети вручную.';

  @override
  String get message0552 => 'Прочитать текущую сеть';

  @override
  String get message0553 => 'Прокси и сертификаты';

  @override
  String get message0554 => 'Basic auth для обратного прокси; PEM для HTTPS и клиентского сертификата.';

  @override
  String get message0555 => 'Basic auth: имя';

  @override
  String get message0556 => 'Basic auth: пароль';

  @override
  String get message0557 => 'Собственный CA (PEM)';

  @override
  String get message0558 => 'Клиентский сертификат (PEM)';

  @override
  String get message0559 => 'Приватный ключ (PEM)';

  @override
  String get message0560 => 'Импортировать PKCS#12 (.p12/.pfx)';

  @override
  String get message0561 => 'Пароль приватного ключа';

  @override
  String get message0562 => 'Размер PEM-файла должен быть меньше 1 МБ.';

  @override
  String get message0563 => 'Не удалось прочитать PEM-файл.';

  @override
  String get message0564 => 'Импортировать файл';

  @override
  String get message0565 => 'Действия с торрентом';

  @override
  String get message0566 => 'Перепроверить';

  @override
  String get message0567 => 'Обновить трекеры';

  @override
  String get message0568 => 'Принудительно запустить';

  @override
  String get message0569 => 'Первый и последний фрагменты';

  @override
  String get message0570 => 'Не удалось получить сведения о торренте.';

  @override
  String get message0571 => 'Обзор';

  @override
  String get message0572 => 'Список файлов пуст';

  @override
  String get message0573 => 'Файл';

  @override
  String get message0574 => 'Приоритет файла';

  @override
  String get message0575 => 'Высокий';

  @override
  String get message0576 => 'Максимальный';

  @override
  String get message0577 => 'Нет трекеров';

  @override
  String get message0578 => 'Трекер';

  @override
  String get message0579 => 'Не удалось изменить торрент.';

  @override
  String get message0580 => 'Состояние';

  @override
  String get message0581 => 'Размер';

  @override
  String get message0582 => 'Готово';

  @override
  String get message0583 => 'Загружено';

  @override
  String get message0584 => 'Отдано';

  @override
  String get message0585 => 'Комментарий';

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
  String get message0591 => 'Ошибка';

  @override
  String get message0592 => 'Проверка';

  @override
  String get message0593 => 'Перемещение';

  @override
  String get message0594 => 'В очереди';

  @override
  String get message0595 => 'Метаданные';

  @override
  String get message0596 => 'Сервер';

  @override
  String get message0597 => 'Не опрошен';

  @override
  String get message0598 => 'Не работает';

  @override
  String get message0599 => 'Работает';

  @override
  String get message0600 => 'Обновление';

  @override
  String get message0601 => 'Состояние неизвестно';

  @override
  String get languageTitle => 'Язык';

  @override
  String get systemLanguage => 'Системный язык';

  @override
  String get languageFollowSystemDescription => 'Использовать язык устройства';

  @override
  String get languageChangeFailed => 'Не удалось изменить язык. Повторите попытку.';

  @override
  String get startupStorageFailed => 'Не удалось прочитать защищённое хранилище. Повторите попытку.';

  @override
  String get localDataResetFailed => 'Не удалось удалить локальные данные. Повторите попытку.';

  @override
  String get appLocked => 'Приложение заблокировано';

  @override
  String get open => 'Открыть';

  @override
  String get resetLocalData => 'Сбросить локальные данные';

  @override
  String get resetLocalDataWarning => 'Сохранённые профили, учётные данные и настройки устройства будут удалены. Это действие нельзя отменить.';

  @override
  String get deleteLocalData => 'Удалить локальные данные';

  @override
  String get cancel => 'Отмена';

  @override
  String get add => 'Добавить';

  @override
  String get incomingTorrentTitle => 'Добавить входящий торрент?';

  @override
  String serverName(String name) {
    return 'Сервер: $name';
  }

  @override
  String get incomingTorrentFile => 'Один .torrent-файл';

  @override
  String get incomingTorrentLink => 'Одна ссылка';

  @override
  String get torrentFile => 'Файл .torrent';

  @override
  String get unlockReason => 'Разблокируйте Home qB Remote';

  @override
  String get downloadComplete => 'Загрузка завершена';

  @override
  String get downloadCompletePrivate => 'Загрузка завершена. Откройте приложение для просмотра.';

  @override
  String get completionChannelName => 'Завершение загрузок';

  @override
  String get completionChannelDescription => 'Завершённые загрузки на ваших серверах qBittorrent';

  @override
  String get integrationsTitle => 'Интеграции';

  @override
  String get integrationsNotice => 'Необязательные подключения к вашим серверам. Поиск никогда не запускает загрузку автоматически.';

  @override
  String get integrationAddJackett => 'Добавить Jackett';

  @override
  String get integrationAddJellyfin => 'Добавить Jellyfin';

  @override
  String get integrationName => 'Название профиля';

  @override
  String get integrationServerUrl => 'URL сервера';

  @override
  String get integrationApiKey => 'API-ключ';

  @override
  String get integrationAccessToken => 'Токен доступа пользователя';

  @override
  String get integrationUserId => 'ID пользователя Jellyfin';

  @override
  String get integrationSave => 'Сохранить профиль';

  @override
  String get integrationEdit => 'Изменить профиль';

  @override
  String get integrationRemove => 'Удалить профиль';

  @override
  String get integrationRemoveConfirm => 'Удалить это подключение из приложения? Данные на сервере не изменятся.';

  @override
  String get integrationCancel => 'Отмена';

  @override
  String get integrationInvalidProfile => 'Введите название, корректный URL сервера HTTP(S) и необходимые учётные данные.';

  @override
  String get integrationStorageFailed => 'Защищённое хранилище интеграций недоступно. Существующие профили сохранены.';

  @override
  String get integrationRetry => 'Повторить';

  @override
  String get integrationHttpNotice => 'HTTP передаёт учётные данные без шифрования. Используйте его только в доверенной локальной сети.';

  @override
  String get integrationSecretNotice => 'Учётные данные хранятся в защищённом хранилище устройства и отправляются только настроенному сервису.';

  @override
  String get integrationNoProfiles => 'Интеграции не настроены.';

  @override
  String get jackettSearchTitle => 'Поиск Jackett';

  @override
  String get jackettSearchHint => 'Поиск по настроенным индексаторам';

  @override
  String get jackettSearchAction => 'Найти';

  @override
  String get jackettSearchEmpty => 'Подходящих результатов нет.';

  @override
  String get jackettSearchFailed => 'Не удалось выполнить поиск в Jackett. Проверьте сервер, API-ключ и настройки индексаторов.';

  @override
  String get jackettDownloadFailed => 'Не удалось получить корректный торрент с настроенного сервера Jackett.';

  @override
  String get jackettDownloadAction => 'Скачать';

  @override
  String get jackettUnknownValue => 'Неизвестно';

  @override
  String get jackettNoTarget => 'Выберите сервер qBittorrent перед добавлением загрузки.';

  @override
  String get jackettAdded => 'Загрузка отправлена. Статус можно проверить в списке торрентов.';

  @override
  String get jellyfinLibraryTitle => 'Медиатека Jellyfin';

  @override
  String get jellyfinSearchHint => 'Поиск в медиатеке';

  @override
  String get jellyfinSearchAction => 'Найти';

  @override
  String get jellyfinEmptyLibrary => 'Подходящих элементов в медиатеке нет.';

  @override
  String get jellyfinReadOnlyNotice => 'Просмотр существующей медиатеки. Воспроизведение здесь пока недоступно.';

  @override
  String get jellyfinConnectionFailed => 'Не удалось подключиться к Jellyfin. Проверьте профиль и повторите попытку.';

  @override
  String get jellyfinAuthenticationFailed => 'Jellyfin отклонил токен доступа или пользователя.';

  @override
  String get jellyfinInvalidResponse => 'Jellyfin вернул некорректный или слишком большой ответ.';

  @override
  String get jellyfinInvalidProfile => 'Введите корректный URL сервера, токен доступа и ID пользователя.';

  @override
  String get jellyfinRedirectBlocked => 'Jellyfin перенаправил запрос за пределы настроенного сервера.';

  @override
  String get jellyfinRetry => 'Повторить';

  @override
  String get jellyfinClose => 'Закрыть';

  @override
  String get searchDownloadConfirmTitle => 'Подтвердите загрузку';

  @override
  String searchDownloadTarget(String name) {
    return 'Целевой сервер: $name';
  }

  @override
  String get searchDownloadDataNotice => 'Ссылка и метаданные торрента будут отправлены на этот сервер qBittorrent. URL могут содержать учётные данные трекера.';

  @override
  String get searchResultUrlHidden => 'Адреса источника и загрузки скрыты, так как могут содержать учётные данные.';

  @override
  String get searchProfileChanged => 'Выбранный сервер изменился. Запустите новый поиск перед загрузкой.';

  @override
  String get searchAlreadyAdded => 'Этот торрент уже есть на выбранном сервере или уже был отправлен.';

  @override
  String get searchAddOutcomeUnknown => 'Запрос на загрузку мог дойти до сервера. Проверьте список торрентов, прежде чем повторять попытку.';

  @override
  String get searchCheckServer => 'Проверить сервер';

  @override
  String get searchUnsupportedDownload => 'У этого результата нет поддерживаемой ссылки для загрузки.';

  @override
  String get searchAddOptions => 'Параметры загрузки';

  @override
  String get searchConfirmAdd => 'Подтвердить и добавить';

  @override
  String get torrentListFilterHint => 'Фильтр текущих торрентов';

  @override
  String get clearTorrentListFilter => 'Сбросить фильтр торрентов';
}
