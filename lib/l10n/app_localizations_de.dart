// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get message0001 => 'Der geschützte Profilspeicher konnte nicht gelesen werden.';

  @override
  String get message0002 => 'Der Profilspeicher ist nicht verfügbar. Änderungen wurden nicht gespeichert; vorhandene Daten wurden beibehalten.';

  @override
  String get message0003 => 'Ein API-Schlüssel kann nicht zusammen mit der Basic-Authentifizierung des Reverse Proxys verwendet werden: Beide nutzen den Authorization-Header.';

  @override
  String get message0004 => 'Die Anmeldung wurde abgelehnt. Prüfe deine Zugangsdaten und verbinde dich erneut mit dem Server.';

  @override
  String get message0005 => 'Server auswählen';

  @override
  String get message0006 => 'Die ausgewählte Datei ist keine gültige .torrent-Datei. Daten wurden nicht gesendet.';

  @override
  String get message0007 => 'Vorgang fehlgeschlagen. Prüfe die Verbindung und die Servereinstellungen.';

  @override
  String get message0008 => 'Der HTTP-Basic-Benutzername darf keinen Doppelpunkt enthalten.';

  @override
  String get message0009 => 'Verwende entweder einen API-Schlüssel oder HTTP-Basic-Zugangsdaten, nicht beides.';

  @override
  String get message0010 => 'Der API-Schlüssel enthält Leerzeichen, Zeilenumbrüche oder andere nicht unterstützte Zeichen.';

  @override
  String get message0011 => 'Gib sowohl das Client-Zertifikat als auch den zugehörigen privaten Schlüssel an.';

  @override
  String get message0012 => 'Die benutzerdefinierte CA oder das Client-Zertifikat konnte nicht geladen werden.';

  @override
  String get message0013 => 'Verwende eine HTTP- oder HTTPS-Server-URL ohne eingebettete Zugangsdaten, Abfrage oder Fragment.';

  @override
  String get message0014 => 'Ungültiger API-Endpunkt.';

  @override
  String get message0015 => 'Die Serververbindung ist geschlossen.';

  @override
  String get message0016 => 'Der Server hat die API-Schlüssel-Prüfung nicht beantwortet. Prüfe die Server-URL und die WebUI-Zugriffseinstellungen.';

  @override
  String get message0017 => 'Anmeldung fehlgeschlagen. Prüfe die Zugangsdaten des Servers und die WebUI-Zugriffseinstellungen.';

  @override
  String get message0018 => 'Der Server hat den API-Schlüssel abgelehnt. Prüfe den Schlüssel und die WebUI-Zugriffseinstellungen und verbinde dich dann erneut.';

  @override
  String get message0019 => 'Die Anmeldung wurde abgelehnt. Prüfe die Zugangsdaten des Servers und die WebUI-Zugriffseinstellungen und verbinde dich dann erneut.';

  @override
  String get message0020 => 'Melde dich zuerst am Server an.';

  @override
  String get message0021 => 'Der Server hat ungültiges JSON zurückgegeben.';

  @override
  String get message0022 => 'Der Server konnte die Aktion nicht ausführen.';

  @override
  String get message0023 => 'Der Server hat eine ungültige Torrent-Liste zurückgegeben.';

  @override
  String get message0024 => 'Wähle zuerst gültige Torrents aus.';

  @override
  String get message0025 => 'Gib eine Torrent-URL oder einen Magnet-Link ein.';

  @override
  String get message0026 => 'Wähle eine nicht leere Torrent-Datei aus.';

  @override
  String get message0027 => 'Wähle eine Torrent-Datei mit Namen aus.';

  @override
  String get message0028 => 'Ungültiges Feld für Torrent-Optionen.';

  @override
  String get message0029 => 'Der Server hat die Torrent-Datei abgelehnt.';

  @override
  String get message0030 => 'Der Server hat ungültige Torrent-Details zurückgegeben.';

  @override
  String get message0031 => 'Zeitüberschreitung der Serveranfrage.';

  @override
  String get message0032 => 'Der Server hat eine ungültige Weiterleitung zurückgegeben.';

  @override
  String get message0033 => 'Der Server hat zu viele Weiterleitungen zurückgegeben.';

  @override
  String message0034(String arg1) {
    return 'Der Server hat die Anfrage abgelehnt (HTTP $arg1).';
  }

  @override
  String get message0035 => 'Die Serverantwort ist zu groß.';

  @override
  String get message0036 => 'Der Server ist nicht erreichbar. Prüfe Adresse und Verbindung.';

  @override
  String get message0037 => 'Die Serververbindung ist fehlgeschlagen.';

  @override
  String get message0038 => 'Der Server hat eine ungültige Antwort zurückgegeben.';

  @override
  String get message0039 => 'Die Serveranfrage ist fehlgeschlagen.';

  @override
  String get message0040 => 'Die Sitzung ist abgelaufen. Melde dich erneut an.';

  @override
  String get message0041 => 'Der Server hat die Anfrage abgelehnt (HTTP 403).';

  @override
  String get message0042 => 'Vorgang fehlgeschlagen';

  @override
  String get message0043 => 'Abbrechen';

  @override
  String get message0044 => 'Übernehmen';

  @override
  String get message0045 => 'Server-Tools';

  @override
  String get message0046 => 'Kein Server';

  @override
  String get message0047 => 'Direkte Verbindung zu deinem qBittorrent. Keine Werbung und keine Analyse.';

  @override
  String get message0048 => 'Torrent-Suche';

  @override
  String get message0049 => 'Die Suchplugins deines Servers';

  @override
  String get message0050 => 'RSS und Download-Regeln';

  @override
  String get message0051 => 'Feeds, Artikel, automatische Regeln';

  @override
  String get message0052 => 'Geschwindigkeit und Limit-Modus';

  @override
  String get message0053 => 'Download- und Upload-Limits in KiB/s';

  @override
  String get message0054 => 'qBittorrent-Einstellungen';

  @override
  String get message0055 => 'Alle verfügbaren WebUI-API-Optionen';

  @override
  String get message0056 => 'Kategorien und Tags';

  @override
  String get message0057 => 'Erstellen, bearbeiten und löschen';

  @override
  String get message0058 => 'Server-Protokoll';

  @override
  String get message0059 => 'Hauptprotokoll und blockierte Peers';

  @override
  String get message0060 => 'Verbindungsstatus';

  @override
  String get message0061 => 'Geschwindigkeiten, übertragene Daten und DHT';

  @override
  String get message0062 => 'Magic Packet im lokalen Netzwerk';

  @override
  String get message0063 => 'Geschwindigkeitslimits';

  @override
  String get message0064 => 'Download, KiB/s (0 = kein Limit)';

  @override
  String get message0065 => 'Upload, KiB/s (0 = kein Limit)';

  @override
  String get message0066 => 'Alternativer Modus (true/false)';

  @override
  String get message0067 => 'Limits gespeichert';

  @override
  String get message0068 => 'MAC-Adresse';

  @override
  String get message0069 => 'Broadcast-Adresse';

  @override
  String get message0070 => 'Port';

  @override
  String get message0071 => 'Magic Packet gesendet';

  @override
  String get message0072 => 'Einstellung nicht verfügbar. Prüfe Geräteberechtigungen und Sicherheitsschutz.';

  @override
  String get message0073 => 'Geräteeinstellungen';

  @override
  String get message0074 => 'App-Sperre';

  @override
  String get message0075 => 'Betriebssystem-Authentifizierung beim Öffnen und bei Rückkehr in die App.';

  @override
  String get message0076 => 'Benachrichtigungen bei Abschluss';

  @override
  String get message0077 => 'Prüfungen, während die App geöffnet ist. Die App muss laufen, damit Benachrichtigungen erscheinen.';

  @override
  String get message0078 => 'Direkte Abfrage von qBittorrent. Die Ausführung im Hintergrund ist durch das Betriebssystem eingeschränkt; sofortige Zustellung ist nicht garantiert.';

  @override
  String get message0079 => 'Prüfintervall im Hintergrund';

  @override
  String message0080(String arg1) {
    return '$arg1 Min. Das Betriebssystem kann den Start verzögern.';
  }

  @override
  String get message0081 => 'Intervall, Minuten';

  @override
  String get message0082 => 'Von 15 bis 1440 Minuten';

  @override
  String get message0083 => 'Speichern';

  @override
  String get message0084 => 'Keine Werbung oder Analysen';

  @override
  String get message0085 => 'Kein Firebase, keine Werbe-SDKs, keine Remote-Konfiguration und keine Entwicklerregistrierung. Profile und Zertifikate werden im sicheren Speicher des Betriebssystems abgelegt.';

  @override
  String get message0086 => 'Netzwerkverbindungen';

  @override
  String get message0087 => 'Der Client verbindet sich mit den qBittorrent-Servern, die Sie angeben. Wake-on-LAN sendet ein Paket an die lokale Adresse, die Sie eingeben. Suche und RSS werden von Ihrem Server verarbeitet.';

  @override
  String get message0088 => 'Verbindungssicherheit';

  @override
  String get message0089 => 'Verwenden Sie HTTPS oder ein VPN für den Fernzugriff. Die Zertifikatsprüfung ist aktiviert; eine benutzerdefinierte CA und ein Client-PEM-Zertifikat können im Profil festgelegt werden.';

  @override
  String get message0090 => 'Bitte dieses Feld ausfüllen';

  @override
  String get message0091 => 'Bestätigen';

  @override
  String get message0092 => 'Geben Sie eine ganze Zahl ein, null oder größer';

  @override
  String get message0093 => 'B';

  @override
  String get message0094 => 'KiB';

  @override
  String get message0095 => 'MiB';

  @override
  String get message0096 => 'GiB';

  @override
  String get message0097 => 'TiB';

  @override
  String get message0098 => 'RSS-Vorgang fehlgeschlagen';

  @override
  String get message0099 => 'Aktualisieren';

  @override
  String get message0100 => 'Hinzufügen';

  @override
  String get message0101 => 'Feed hinzufügen';

  @override
  String get message0102 => 'Ordner erstellen';

  @override
  String get message0103 => 'Regel hinzufügen';

  @override
  String get message0104 => 'Ordneraktionen';

  @override
  String get message0105 => 'Artikel';

  @override
  String get message0106 => 'Feeds';

  @override
  String get message0107 => 'Regeln';

  @override
  String get message0108 => 'Noch keine Artikel in den Feeds';

  @override
  String get message0109 => 'Ohne Titel';

  @override
  String get message0110 => 'Torrent hinzugefügt';

  @override
  String get message0111 => 'Torrent hinzufügen';

  @override
  String get message0112 => 'Als gelesen markieren';

  @override
  String get message0113 => 'Fügen Sie Ihren ersten RSS-Feed mit + hinzu';

  @override
  String get message0114 => 'Feed aktualisieren';

  @override
  String get message0115 => 'Alle als gelesen markieren';

  @override
  String get message0116 => 'Verschieben / Umbenennen';

  @override
  String get message0117 => 'Feed löschen';

  @override
  String get message0118 => 'Keine automatischen Download-Regeln';

  @override
  String get message0119 => 'Bearbeiten';

  @override
  String get message0120 => 'Umbenennen';

  @override
  String get message0121 => 'Passende Artikel';

  @override
  String get message0122 => 'Regel löschen';

  @override
  String get message0123 => 'RSS-Ordner';

  @override
  String get message0124 => 'Vollständiger Ordnerpfad';

  @override
  String get message0125 => 'Ordneraktion';

  @override
  String get message0126 => 'Ordner löschen';

  @override
  String get message0127 => 'Neuer RSS-Feed';

  @override
  String get message0128 => 'Neuer RSS-Ordner';

  @override
  String get message0129 => 'Feed-URL';

  @override
  String get message0130 => 'Feed-Pfad und Name (optional)';

  @override
  String get message0131 => 'Neuer Ordnerpfad';

  @override
  String get message0132 => 'Neuer RSS-Pfad';

  @override
  String get message0133 => 'Pfad und neuer Name';

  @override
  String get message0134 => 'RSS-Element löschen?';

  @override
  String message0135(String arg1) {
    return '„$arg1“ und sein RSS-Inhalt werden gelöscht. Torrent-Dateien bleiben unberührt.';
  }

  @override
  String get message0136 => 'Regel löschen?';

  @override
  String get message0137 => 'Regelname';

  @override
  String get message0138 => 'Neuer Name';

  @override
  String message0139(String arg1) {
    return 'Passende Artikel: $arg1';
  }

  @override
  String get message0140 => 'Keine passenden Artikel';

  @override
  String get message0141 => 'Schließen';

  @override
  String get message0142 => 'Neue RSS-Regel';

  @override
  String get message0143 => 'RSS-Regel';

  @override
  String get message0144 => 'Muss enthalten';

  @override
  String get message0145 => 'Darf nicht enthalten';

  @override
  String get message0146 => 'Episodenfilter';

  @override
  String get message0147 => 'Feed-URLs, eine pro Zeile';

  @override
  String get message0148 => 'Kategorie';

  @override
  String get message0149 => 'Speicherpfad';

  @override
  String get message0150 => 'Nicht erneut herunterladen für, Tage';

  @override
  String get message0151 => 'Regelnamen eingeben';

  @override
  String get message0152 => 'Regel aktiviert';

  @override
  String get message0153 => 'Reguläre Ausdrücke';

  @override
  String get message0154 => 'Intelligenter Episodenfilter';

  @override
  String get message0155 => 'Pausiert hinzufügen';

  @override
  String get message0156 => 'Suchplugins nicht verfügbar';

  @override
  String get message0157 => 'Suche auf Ihrem Server…';

  @override
  String message0158(int arg1, String arg2) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 Ergebnisse',
      one: '$arg1 Ergebnis',
    );
    return '$_temp0$arg2';
  }

  @override
  String get message0159 => ' · abgeschlossen';

  @override
  String message0160(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 Ergebnisse',
      one: '$arg1 Ergebnis',
    );
    return '$_temp0 · Suche nach 2 Minuten beendet';
  }

  @override
  String get message0161 => 'Suche fehlgeschlagen';

  @override
  String get message0162 => 'Suche konnte nicht gestoppt werden';

  @override
  String message0163(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 Ergebnisse',
      one: '$arg1 Ergebnis',
    );
    return '$_temp0 · gestoppt';
  }

  @override
  String get message0164 => 'Serversuche';

  @override
  String get message0165 => 'Suchplugins';

  @override
  String get message0166 => 'Torrent-Name';

  @override
  String get message0167 => 'Stoppen';

  @override
  String get message0168 => 'Suchen';

  @override
  String get message0169 => 'Plugin';

  @override
  String get message0170 => 'Alle Plugins';

  @override
  String get message0171 => 'Nur aktivierte';

  @override
  String get message0172 => 'Alle';

  @override
  String get message0173 => 'Bücher';

  @override
  String get message0174 => 'Spiele';

  @override
  String get message0175 => 'Filme';

  @override
  String get message0176 => 'Musik';

  @override
  String get message0177 => 'Software';

  @override
  String get message0178 => 'TV-Serien';

  @override
  String get message0179 => 'Suchbegriff eingeben';

  @override
  String message0180(String arg1, String arg2, String arg3) {
    return '$arg1 · Seeds $arg2\n$arg3';
  }

  @override
  String get message0181 => 'Zum Server hinzufügen';

  @override
  String get message0182 => 'Torrent konnte nicht hinzugefügt werden';

  @override
  String get message0183 => 'Plugins konnten nicht geändert werden';

  @override
  String get message0184 => 'Suchplugin installieren';

  @override
  String get message0185 => 'URL der Plugin-Datei';

  @override
  String get message0186 => 'Das Plugin wird heruntergeladen und auf deinem qBittorrent-Server installiert. Verwende nur vertrauenswürdige Quellen.';

  @override
  String get message0187 => 'Suchplugins';

  @override
  String get message0188 => 'Plugins aktualisieren';

  @override
  String get message0189 => 'Plugin installieren';

  @override
  String get message0190 => 'Keine Suchplugins auf dem Server';

  @override
  String message0191(String arg1) {
    return 'Version $arg1';
  }

  @override
  String get message0192 => 'Plugin löschen';

  @override
  String get message0193 => 'Plugin löschen?';

  @override
  String get message0194 => 'Neue Kategorie';

  @override
  String get message0195 => 'Kategorie bearbeiten';

  @override
  String get message0196 => 'Name';

  @override
  String get message0197 => 'Serverordner';

  @override
  String get message0198 => 'Kategorien';

  @override
  String get message0199 => 'Kategorie löschen';

  @override
  String get message0200 => 'Kategorie löschen?';

  @override
  String message0201(String arg1) {
    return '$arg1. Torrents und Dateien bleiben erhalten.';
  }

  @override
  String get message0202 => 'Tags';

  @override
  String get message0203 => 'Tags erstellen';

  @override
  String get message0204 => 'Neue Tags';

  @override
  String get message0205 => 'Namen durch Kommas getrennt';

  @override
  String get message0206 => 'Tag löschen';

  @override
  String get message0207 => 'Tag löschen?';

  @override
  String message0208(String arg1) {
    return '$arg1. Torrents und Dateien bleiben erhalten.';
  }

  @override
  String get message0209 => 'Normal';

  @override
  String get message0210 => 'Info';

  @override
  String get message0211 => 'Warnung';

  @override
  String get message0212 => 'Kritisch';

  @override
  String get message0213 => 'Nachricht';

  @override
  String get message0214 => 'Peer-Protokoll';

  @override
  String get message0215 => 'Stufe';

  @override
  String get message0216 => 'Alle Nachrichten';

  @override
  String get message0217 => 'Warnungen';

  @override
  String get message0218 => 'Kritisch';

  @override
  String get message0219 => 'Blockiert';

  @override
  String get message0220 => 'Erlaubt';

  @override
  String get message0221 => 'Download-Geschwindigkeit';

  @override
  String get message0222 => 'Upload-Geschwindigkeit';

  @override
  String get message0223 => 'In dieser Sitzung heruntergeladen';

  @override
  String get message0224 => 'In dieser Sitzung hochgeladen';

  @override
  String get message0225 => 'Download-Limit';

  @override
  String get message0226 => 'Upload-Limit';

  @override
  String get message0227 => 'DHT-Knoten';

  @override
  String get message0228 => 'Verbindung';

  @override
  String message0229(String arg1) {
    return '$arg1/s';
  }

  @override
  String get message0230 => 'Verbunden';

  @override
  String get message0231 => 'Hinter NAT / Firewall';

  @override
  String get message0232 => 'Nicht verbunden';

  @override
  String get message0233 => 'Kategorien und Tags';

  @override
  String get message0234 => 'Serverstatus';

  @override
  String get message0235 => 'Einstellungen konnten nicht geladen werden';

  @override
  String get message0236 => 'WebUI ändern?';

  @override
  String get message0237 => 'Das Ändern von Adresse, Port oder Authentifizierung kann die Verbindung trennen.';

  @override
  String get message0238 => 'Einstellungen gespeichert. Wenn sich WebUI-Adresse, Port oder Passwort geändert haben, Verbindungsprofil aktualisieren.';

  @override
  String get message0239 => 'Einstellungen gespeichert';

  @override
  String get message0240 => 'Einstellungen konnten nicht gespeichert werden';

  @override
  String get message0241 => 'Ganze Zahl eingeben';

  @override
  String get message0242 => 'Port muss 1–65535 sein';

  @override
  String get message0243 => 'Stunde muss 0–23 sein';

  @override
  String get message0244 => 'Minute muss 0–59 sein';

  @override
  String get message0245 => 'Minimum −1 (sofern vom Server unterstützt)';

  @override
  String get message0246 => 'Erweiterte JSON-Einstellungen';

  @override
  String get message0247 => 'Alle Einstellungen des aktuellen Servers. Nur geänderte Schlüssel werden gespeichert.';

  @override
  String get message0248 => 'Ungültiges Einstellungs-JSON';

  @override
  String get message0249 => 'Downloads';

  @override
  String get message0250 => 'Speicherordner';

  @override
  String get message0251 => 'Temporärer Ordner';

  @override
  String get message0252 => 'Temporären Ordner verwenden';

  @override
  String get message0253 => 'Pausiert hinzufügen';

  @override
  String get message0254 => 'Automatische Torrent-Verwaltung';

  @override
  String get message0255 => 'Speicherplatz vorab zuweisen';

  @override
  String get message0256 => 'Erweiterung für unvollständige Dateien';

  @override
  String get message0257 => '.torrent-Exportordner';

  @override
  String get message0258 => 'Abgeschlossene .torrent-Dateien exportieren';

  @override
  String get message0259 => 'Eingehender Port';

  @override
  String get message0260 => 'Zufälliger Port beim Start';

  @override
  String get message0261 => 'Max. Verbindungen (-1 = kein Limit)';

  @override
  String get message0262 => 'Verbindungen pro Torrent';

  @override
  String get message0263 => 'Upload-Slots';

  @override
  String get message0264 => 'Proxy-Adresse';

  @override
  String get message0265 => 'Proxy-Port';

  @override
  String get message0266 => 'Proxy-Benutzername';

  @override
  String get message0267 => 'Proxy-Passwort';

  @override
  String get message0268 => 'Geschwindigkeit';

  @override
  String get message0269 => 'Download, Bytes/s (0 = kein Limit)';

  @override
  String get message0270 => 'Upload, Bytes/s (0 = kein Limit)';

  @override
  String get message0271 => 'Alternativer Download, Bytes/s';

  @override
  String get message0272 => 'Alternativer Upload, Bytes/s';

  @override
  String get message0273 => 'Zeitplan für alternative Limits';

  @override
  String get message0274 => 'Start: Stunde';

  @override
  String get message0275 => 'Start: Minute';

  @override
  String get message0276 => 'Ende: Stunde';

  @override
  String get message0277 => 'Ende: Minute';

  @override
  String get message0278 => 'Protokoll-Overhead in Limits einbeziehen';

  @override
  String get message0279 => 'Lokale Peers begrenzen';

  @override
  String get message0280 => 'Peer-Austausch (PeX)';

  @override
  String get message0281 => 'Lokale Peer-Suche';

  @override
  String get message0282 => 'Anonymer Modus';

  @override
  String get message0283 => 'Torrent-Warteschlange';

  @override
  String get message0284 => 'Aktive Downloads';

  @override
  String get message0285 => 'Aktive Uploads';

  @override
  String get message0286 => 'Aktive Torrents';

  @override
  String get message0287 => 'Langsame Torrents nicht zählen';

  @override
  String get message0288 => 'Tracker automatisch hinzufügen';

  @override
  String get message0289 => 'Zusätzliche Tracker';

  @override
  String get message0290 => 'Lauschadresse';

  @override
  String get message0291 => 'WebUI-Port';

  @override
  String get message0292 => 'Benutzername';

  @override
  String get message0293 => 'Neues Passwort';

  @override
  String get message0294 => 'Localhost-Authentifizierung';

  @override
  String get message0295 => 'CSRF-Schutz';

  @override
  String get message0296 => 'Clickjacking-Schutz';

  @override
  String get message0297 => 'Sitzungs-Timeout, Sekunden';

  @override
  String get message0298 => 'RSS-Feeds aktivieren';

  @override
  String get message0299 => 'Automatischer Download nach Regeln';

  @override
  String get message0300 => 'Aktualisierungsintervall, Minuten';

  @override
  String get message0301 => 'Artikel pro Feed';

  @override
  String get message0302 => 'Episodenfilter';

  @override
  String get message0303 => 'Alle Einstellungen (JSON)';

  @override
  String get message0304 => 'Erweiterte Einstellungen und Optionen für Ihre Serverversion';

  @override
  String get message0305 => 'Aktion konnte nicht abgeschlossen werden';

  @override
  String get message0306 => 'Änderungen übernommen';

  @override
  String get message0307 => 'Torrent verwalten';

  @override
  String get message0308 => 'Organisieren';

  @override
  String get message0309 => 'Torrent-Name';

  @override
  String get message0310 => 'Torrent umbenennen';

  @override
  String get message0311 => 'Dateien verschieben';

  @override
  String get message0312 => 'Neuer Serverpfad';

  @override
  String get message0313 => 'Vollständiger Pfad';

  @override
  String get message0314 => 'qBittorrent verschiebt die Dateien auf dem Server';

  @override
  String get message0315 => 'Tags hinzufügen';

  @override
  String get message0316 => 'Tags, durch Kommas getrennt';

  @override
  String get message0317 => 'Tags entfernen';

  @override
  String get message0318 => 'Geschwindigkeit und Seeding';

  @override
  String get message0319 => 'Geschwindigkeitslimits';

  @override
  String get message0320 => 'Seeding-Limits';

  @override
  String get message0321 => 'Erzwungen starten';

  @override
  String get message0322 => 'Super-Seeding';

  @override
  String get message0323 => 'Sequenziellen Download umschalten';

  @override
  String get message0324 => 'Priorität erster/letzter Teil umschalten';

  @override
  String get message0325 => 'Erzwungene Neuprüfung';

  @override
  String get message0326 => 'Dateien erneut prüfen?';

  @override
  String get message0327 => 'Die erneute Prüfung kann einige Zeit dauern und Übertragungen vorübergehend pausieren.';

  @override
  String get message0328 => 'Bei Trackern erneut ankündigen';

  @override
  String get message0329 => 'Warteschlange';

  @override
  String get message0330 => 'Nach ganz oben verschieben';

  @override
  String get message0331 => 'Nach oben verschieben';

  @override
  String get message0332 => 'Nach unten verschieben';

  @override
  String get message0333 => 'Nach ganz unten verschieben';

  @override
  String get message0334 => 'Inhalt und Verbindungen';

  @override
  String get message0335 => '.torrent exportieren';

  @override
  String get message0336 => 'Dateien und Prioritäten';

  @override
  String get message0337 => 'Ordner umbenennen';

  @override
  String get message0338 => 'Aktueller Pfad im Torrent';

  @override
  String get message0339 => 'Neuer Pfad im Torrent';

  @override
  String get message0340 => 'Tracker';

  @override
  String get message0341 => 'Peers';

  @override
  String get message0342 => 'HTTP-Quellen';

  @override
  String get message0343 => 'Teilstatus';

  @override
  String get message0344 => 'Ohne Kategorie';

  @override
  String get message0345 => 'Download, KiB/s';

  @override
  String get message0346 => 'Upload, KiB/s';

  @override
  String get message0347 => '0 = kein Limit. 1 KiB/s = 1024 Bytes/s.';

  @override
  String get message0348 => 'Verhältnis';

  @override
  String get message0349 => 'Zahl eingeben';

  @override
  String get message0350 => 'Seeding-Zeit, Minuten';

  @override
  String get message0351 => 'Ganzzahl eingeben';

  @override
  String get message0352 => 'Inaktive Seeding-Zeit, Minuten';

  @override
  String get message0353 => '-2 = Servereinstellungen verwenden, -1 = kein Limit.';

  @override
  String get message0354 => 'Aktivieren';

  @override
  String get message0355 => 'Deaktivieren';

  @override
  String get message0356 => 'Dateien';

  @override
  String message0357(String arg1, String arg2) {
    return '$arg1 · Priorität $arg2';
  }

  @override
  String get message0358 => 'Datei umbenennen';

  @override
  String get message0359 => 'Änderungen übernommen. Liste zum Aktualisieren erneut öffnen.';

  @override
  String get message0360 => 'Aktion fehlgeschlagen';

  @override
  String get message0361 => 'Nicht herunterladen';

  @override
  String get message0362 => 'Normale Priorität';

  @override
  String get message0363 => 'Hohe Priorität';

  @override
  String get message0364 => 'Höchste Priorität';

  @override
  String get message0365 => 'Tracker bearbeiten';

  @override
  String get message0366 => 'Neue URL';

  @override
  String get message0367 => 'Tracker entfernen?';

  @override
  String get message0368 => 'Tracker konnte nicht bearbeitet werden';

  @override
  String get message0369 => 'Entfernen';

  @override
  String get message0370 => 'Tracker hinzufügen';

  @override
  String get message0371 => 'URLs, eine pro Zeile';

  @override
  String get message0372 => 'Tracker konnten nicht hinzugefügt werden';

  @override
  String get message0373 => 'Keine verbundenen Peers';

  @override
  String message0374(String arg1, String arg2) {
    return '$arg1 · ↓ $arg2/s';
  }

  @override
  String get message0375 => 'Peers hinzufügen';

  @override
  String get message0376 => 'IP:Port, getrennt durch |';

  @override
  String get message0377 => 'Peers konnten nicht hinzugefügt werden';

  @override
  String message0378(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 Teile',
      one: '$arg1 Teil',
    );
    return '$_temp0';
  }

  @override
  String get message0379 => 'Grau: fehlend, Blau: wird heruntergeladen, Grün: fertig. Es werden die ersten 4096 Teile angezeigt.';

  @override
  String message0380(String arg1) {
    return 'Teil $arg1';
  }

  @override
  String get message0381 => 'Export abgeschlossen';

  @override
  String get message0382 => 'Export abgebrochen';

  @override
  String get message0383 => 'URL eingeben';

  @override
  String get message0384 => 'URL darf keine Leerzeichen, Steuerzeichen oder \"|\" enthalten';

  @override
  String get message0385 => 'Adresse mit http:// oder https:// und einem Hostnamen eingeben';

  @override
  String get message0386 => 'Mindestens eine URL eingeben';

  @override
  String get message0387 => 'Der Server unterstützt das Ändern von HTTP-Quellen nicht. ';

  @override
  String get message0388 => 'Erfordert qBittorrent 5.2 oder neuer; nur Anzeige.';

  @override
  String get message0389 => 'HTTP-Quellen konnten nicht geladen werden';

  @override
  String get message0390 => 'HTTP-Quellen hinzufügen';

  @override
  String get message0391 => 'Adressen werden an den qBittorrent-Server übergeben; die App verbindet sich nicht direkt mit ihnen.';

  @override
  String get message0392 => 'HTTP-Quellen konnten nicht hinzugefügt werden';

  @override
  String get message0393 => 'HTTP-Quelle bearbeiten';

  @override
  String get message0394 => 'Adresse unverändert';

  @override
  String get message0395 => 'HTTP-Quelle konnte nicht bearbeitet werden';

  @override
  String get message0396 => 'HTTP-Quelle entfernen?';

  @override
  String get message0397 => 'HTTP-Quelle konnte nicht entfernt werden';

  @override
  String get message0398 => 'Quellen hinzufügen';

  @override
  String get message0399 => 'Das Bearbeiten von HTTP-Quellen erfordert qBittorrent 5.2 oder neuer. ';

  @override
  String get message0400 => 'Ein älterer Server lehnt die Änderungen möglicherweise ab.';

  @override
  String get message0401 => 'Erneut versuchen';

  @override
  String get message0402 => 'Keine HTTP-Quellen';

  @override
  String get message0403 => 'Sicherer Speicher konnte nicht initialisiert werden.';

  @override
  String get message0404 => 'Eingehenden Torrent hinzufügen?';

  @override
  String message0405(String arg1) {
    return 'Server: $arg1';
  }

  @override
  String get message0406 => 'Eine .torrent-Datei';

  @override
  String get message0407 => 'Ein Link';

  @override
  String get message0408 => '.torrent-Datei';

  @override
  String get message0409 => 'Lokale Daten konnten nicht gelöscht werden.';

  @override
  String get message0410 => 'Home qB gesperrt';

  @override
  String get message0411 => 'Öffnen';

  @override
  String get message0412 => 'Lokale Daten zurücksetzen';

  @override
  String get message0413 => 'Profile, Passwörter und Zertifikate werden von diesem Gerät gelöscht. Torrents auf dem Server bleiben erhalten.';

  @override
  String get message0414 => 'Lokale Daten löschen';

  @override
  String get message0415 => 'Geräteeinstellungen konnten nicht aus dem sicheren Speicher gelesen werden.';

  @override
  String get message0416 => 'Hintergrundabfrage konnte auf diesem Gerät nicht geplant werden.';

  @override
  String get message0417 => 'Hintergrundabfrage ist unter Android und iOS verfügbar. Desktop-Benachrichtigungen setzen voraus, dass die App geöffnet bleibt.';

  @override
  String get message0418 => 'Benachrichtigungen sind auf dieser Plattform nicht konfiguriert.';

  @override
  String get message0419 => 'Systembenachrichtigungen sind nicht verfügbar.';

  @override
  String get message0420 => 'Systembenachrichtigungen konnten nicht initialisiert werden.';

  @override
  String get message0421 => 'Android kann die Abfrage aufgrund von Akku-, Netzwerk- oder Hintergrundbeschränkungen verzögern.';

  @override
  String get message0422 => 'Wählen Sie ein Abfrageintervall zwischen 15 und 1440 Minuten.';

  @override
  String get message0423 => 'Das neue Intervall wurde gespeichert, der Hintergrundzeitplan konnte jedoch nicht aktualisiert werden.';

  @override
  String get message0424 => 'Benachrichtigungen sind nicht verfügbar.';

  @override
  String get message0425 => 'Die Berechtigung für Benachrichtigungen wurde nicht erteilt.';

  @override
  String get message0426 => 'Der Hintergrundzeitplan konnte nicht aktualisiert werden. Benachrichtigungsprüfungen im Vordergrund funktionieren weiterhin.';

  @override
  String get message0427 => 'Home qB Remote entsperren';

  @override
  String get message0428 => 'Geräteauthentifizierung wurde nicht abgeschlossen.';

  @override
  String get message0429 => 'Screenshot-Schutz konnte nicht aktiviert werden.';

  @override
  String get message0430 => 'Systembenachrichtigungen konnten nicht entfernt werden.';

  @override
  String get message0431 => 'Die Hintergrundprüfung konnte nicht abgebrochen werden.';

  @override
  String get message0432 => 'Download abgeschlossen';

  @override
  String get message0433 => 'Download abgeschlossen. Öffnen Sie die App, um ihn anzuzeigen.';

  @override
  String get message0434 => 'Abgeschlossene Downloads';

  @override
  String get message0435 => 'Abgeschlossene Downloads auf Ihren qBittorrent-Servern';

  @override
  String get message0436 => 'Das Budget für Hintergrundprüfungen ist aufgebraucht.';

  @override
  String get message0437 => 'Nur ein lokales .torrent-Dokument kann importiert werden.';

  @override
  String get message0438 => 'Dokumentimport wird auf dieser Plattform nicht unterstützt.';

  @override
  String get message0439 => 'Dokumentimport ist in dieser Version der App nicht verfügbar.';

  @override
  String get message0440 => 'Das Dokument wurde vom System abgelehnt.';

  @override
  String get message0441 => 'Das Torrent-Dokument konnte nicht gelesen werden.';

  @override
  String get message0442 => 'Das Torrent-Dokument ist leer.';

  @override
  String get message0443 => 'Das Torrent-Dokument ist größer als 16 MiB und kann nicht importiert werden.';

  @override
  String get message0444 => 'Das Dokument ist keine gültige .torrent-Datei.';

  @override
  String get message0445 => 'Russisch';

  @override
  String get message0446 => 'Ukrainisch';

  @override
  String get message0447 => 'Nicht unterstützte Sprache';

  @override
  String get message0448 => 'Ein anderer Export läuft noch.';

  @override
  String get message0449 => 'Export wird auf dieser Plattform nicht unterstützt.';

  @override
  String get message0450 => 'Es gibt keine Torrent-Daten zum Exportieren.';

  @override
  String get message0451 => 'Die Torrent-Datei ist größer als 16 MiB und kann nicht exportiert werden.';

  @override
  String get message0452 => 'Die Torrent-Daten sind keine gültige Bytefolge.';

  @override
  String get message0453 => 'Export ist in dieser Version der App nicht verfügbar.';

  @override
  String get message0454 => 'Die Torrent-Daten wurden vom System abgelehnt.';

  @override
  String get message0455 => 'Die Torrent-Datei konnte nicht gespeichert werden.';

  @override
  String get message0456 => 'Der Speichern-Dialog konnte nicht geöffnet werden.';

  @override
  String get message0457 => 'Die Torrent-Datei konnte nicht an den gewählten Speicherort geschrieben werden.';

  @override
  String get message0458 => 'Geben Sie eine ganze Zahl ab 0 ein';

  @override
  String get message0459 => 'Neuer Download';

  @override
  String get message0460 => 'Magnet-Links oder URLs';

  @override
  String get message0461 => 'Ein Link pro Zeile';

  @override
  String get message0462 => '.torrent-Datei auswählen';

  @override
  String get message0463 => 'Download-Optionen';

  @override
  String get message0464 => 'Tags, durch Kommas getrennt';

  @override
  String get message0465 => 'Neuer Name (optional)';

  @override
  String get message0466 => 'Download-Limit, KiB/s';

  @override
  String get message0467 => '0 — kein Limit; leer — Servereinstellung';

  @override
  String get message0468 => 'Upload-Limit, KiB/s';

  @override
  String get message0469 => 'Dateistruktur';

  @override
  String get message0470 => 'Wie im Torrent';

  @override
  String get message0471 => 'Unterordner erstellen';

  @override
  String get message0472 => 'Kein Unterordner';

  @override
  String get message0473 => 'Pausiert hinzufügen';

  @override
  String get message0474 => 'Sequenzieller Download';

  @override
  String get message0475 => 'Erste und letzte Teile zuerst';

  @override
  String get message0476 => 'PKCS#12-Passwort';

  @override
  String get message0477 => 'Container-Passwort';

  @override
  String get message0478 => 'Importieren';

  @override
  String get message0479 => 'Home qB';

  @override
  String get message0480 => 'Server verwalten';

  @override
  String get message0481 => 'App-Einstellungen';

  @override
  String get message0482 => 'IHRE VERBINDUNG';

  @override
  String get message0483 => 'Kein Server ausgewählt';

  @override
  String get message0484 => 'Server';

  @override
  String get message0485 => 'RSS, Suche, Einstellungen';

  @override
  String get message0486 => 'Herunterladen';

  @override
  String get message0487 => 'Seeding';

  @override
  String get message0488 => 'Pausiert';

  @override
  String get message0489 => 'Fehler';

  @override
  String get message0490 => 'Alle Torrents';

  @override
  String get message0491 => 'Nur Ihre Server.\nKeine Werbung und keine Telemetrie.';

  @override
  String get message0492 => 'Ihre Downloads, immer griffbereit';

  @override
  String get message0493 => 'Verbinden Sie Ihren qBittorrent-Heimserver über die Web-UI.\nDie Serveradresse und die Einstellungen werden auf diesem Gerät gespeichert.';

  @override
  String get message0494 => 'Server verbinden';

  @override
  String get message0495 => 'Downloads durchsuchen';

  @override
  String get message0496 => 'Aktueller Server';

  @override
  String message0497(String arg1) {
    return '$arg1/s';
  }

  @override
  String message0498(String arg1) {
    return '$arg1/s';
  }

  @override
  String get message0499 => 'Torrents';

  @override
  String get message0500 => 'Torrent nach Namen suchen';

  @override
  String message0501(String arg1) {
    return 'Ausgewählt: $arg1';
  }

  @override
  String get message0502 => 'Ausgewählte fortsetzen';

  @override
  String get message0503 => 'Ausgewählte pausieren';

  @override
  String get message0504 => 'Ausgewählte löschen';

  @override
  String get message0505 => 'Auswahl aufheben';

  @override
  String get message0506 => 'Nichts gefunden';

  @override
  String get message0507 => 'Noch keine Torrents';

  @override
  String get message0508 => 'Fügen Sie einen Magnet-Link, eine URL oder eine .torrent-Datei hinzu.';

  @override
  String get message0509 => 'Fortsetzen';

  @override
  String get message0510 => 'Pausieren';

  @override
  String get message0511 => 'Aktionen';

  @override
  String get message0512 => 'Details';

  @override
  String get message0513 => 'Löschen…';

  @override
  String message0514(String arg1) {
    return '↓ $arg1/s';
  }

  @override
  String message0515(String arg1) {
    return '↑ $arg1/s';
  }

  @override
  String get message0516 => 'Aktion konnte nicht abgeschlossen werden. Prüfen Sie die Verbindung zu Ihrem Server.';

  @override
  String get message0517 => 'Meine Server';

  @override
  String get message0518 => 'Servereinstellungen';

  @override
  String get message0519 => 'Bearbeiten';

  @override
  String get message0520 => 'Profil löschen';

  @override
  String get message0521 => 'Server hinzufügen';

  @override
  String get message0522 => 'Profil löschen?';

  @override
  String message0523(String arg1) {
    return 'Profil „$arg1“ wird von diesem Gerät entfernt. Torrents auf dem Server bleiben erhalten.';
  }

  @override
  String get message0524 => 'Lokales HTTP verwenden?';

  @override
  String get message0525 => 'SSID bestätigt nicht die Identität des Netzwerks. In einem anderen Netzwerk mit demselben Namen könnte Ihr Passwort an einen nicht autorisierten Server gelangen. Verwenden Sie zum Schutz HTTPS mit Zertifikatsprüfung oder ein VPN.';

  @override
  String get message0526 => 'Wählen Sie eine .torrent-Datei mit bis zu 16 MB.';

  @override
  String get message0527 => 'Die ausgewählte Datei konnte nicht geöffnet werden.';

  @override
  String get message0528 => 'Torrent löschen?';

  @override
  String message0529(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 Torrents löschen?',
      one: '$arg1 Torrent löschen?',
    );
    return '$_temp0';
  }

  @override
  String get message0530 => 'Standardmäßig bleiben heruntergeladene Dateien auf dem Server.';

  @override
  String get message0531 => 'Dateien auch vom Server löschen';

  @override
  String get message0532 => 'Diese Aktion kann nicht rückgängig gemacht werden';

  @override
  String get message0533 => 'Heimserver';

  @override
  String get message0534 => 'PKCS#12 konnte nicht importiert werden. Prüfen Sie das Passwort und die Datei (bis 4 MB).';

  @override
  String get message0535 => 'Namen eingeben';

  @override
  String get message0536 => 'Web-UI-Adresse';

  @override
  String get message0537 => 'HTTP oder HTTPS, einschließlich Port und Pfad';

  @override
  String get message0538 => 'Geben Sie die vollständige HTTP(S)-Serveradresse ein';

  @override
  String get message0539 => 'Entfernen Sie Passwort, Parameter und # aus der Adresse';

  @override
  String get message0540 => 'Passwort';

  @override
  String get message0541 => 'Passwort ausblenden';

  @override
  String get message0542 => 'Passwort anzeigen';

  @override
  String get message0543 => 'API-Schlüssel (optional)';

  @override
  String get message0544 => 'qBittorrent 5.2+. Falls ausgefüllt, wird er anstelle von Benutzername und Passwort verwendet.';

  @override
  String get message0545 => 'Ein API-Schlüssel kann nicht mit einem Basic-Auth-Proxy kombiniert werden';

  @override
  String get message0546 => 'Lokale WLAN-Adresse';

  @override
  String get message0547 => 'Optional. Die SSID wird nur auf dem Gerät verwendet, um eine Adresse auszuwählen. Das Betriebssystem kann die Standortberechtigung anfordern, um den WLAN-Namen zu lesen; Koordinaten werden nicht gelesen.';

  @override
  String get message0548 => 'Lokale URL';

  @override
  String get message0549 => 'Geben Sie eine HTTP(S)-Adresse ohne Passwort oder Parameter ein';

  @override
  String get message0550 => 'Heim-WLAN-Netzwerk (SSID)';

  @override
  String get message0551 => 'SSID nicht verfügbar. Sie können den Netzwerknamen manuell eingeben.';

  @override
  String get message0552 => 'Aktuelles Netzwerk auslesen';

  @override
  String get message0553 => 'Proxy und Zertifikate';

  @override
  String get message0554 => 'Basic Auth für Reverse-Proxy; PEM für HTTPS und Client-Zertifikat.';

  @override
  String get message0555 => 'Basic Auth: Benutzername';

  @override
  String get message0556 => 'Basic Auth: Passwort';

  @override
  String get message0557 => 'Eigene CA (PEM)';

  @override
  String get message0558 => 'Client-Zertifikat (PEM)';

  @override
  String get message0559 => 'Privater Schlüssel (PEM)';

  @override
  String get message0560 => 'PKCS#12 importieren (.p12/.pfx)';

  @override
  String get message0561 => 'Passwort des privaten Schlüssels';

  @override
  String get message0562 => 'Die PEM-Datei muss kleiner als 1 MB sein.';

  @override
  String get message0563 => 'PEM-Datei konnte nicht gelesen werden.';

  @override
  String get message0564 => 'Datei importieren';

  @override
  String get message0565 => 'Torrent-Aktionen';

  @override
  String get message0566 => 'Erneut prüfen';

  @override
  String get message0567 => 'Tracker aktualisieren';

  @override
  String get message0568 => 'Erzwungen starten';

  @override
  String get message0569 => 'Erste und letzte Teile';

  @override
  String get message0570 => 'Torrent-Details konnten nicht geladen werden.';

  @override
  String get message0571 => 'Durchsuchen';

  @override
  String get message0572 => 'Dateiliste ist leer';

  @override
  String get message0573 => 'Datei';

  @override
  String get message0574 => 'Dateipriorität';

  @override
  String get message0575 => 'Hoch';

  @override
  String get message0576 => 'Maximal';

  @override
  String get message0577 => 'Keine Tracker';

  @override
  String get message0578 => 'Tracker';

  @override
  String get message0579 => 'Torrent konnte nicht geändert werden.';

  @override
  String get message0580 => 'Status';

  @override
  String get message0581 => 'Größe';

  @override
  String get message0582 => 'Fertig';

  @override
  String get message0583 => 'Heruntergeladen';

  @override
  String get message0584 => 'Hochgeladen';

  @override
  String get message0585 => 'Kommentar';

  @override
  String get message0586 => 'Hash';

  @override
  String get message0587 => 'KB';

  @override
  String get message0588 => 'MB';

  @override
  String get message0589 => 'GB';

  @override
  String get message0590 => 'TB';

  @override
  String get message0591 => 'Fehler';

  @override
  String get message0592 => 'Wird geprüft';

  @override
  String get message0593 => 'Wird verschoben';

  @override
  String get message0594 => 'In Warteschlange';

  @override
  String get message0595 => 'Metadaten';

  @override
  String get message0596 => 'Server';

  @override
  String get message0597 => 'Nicht abgefragt';

  @override
  String get message0598 => 'Nicht erreichbar';

  @override
  String get message0599 => 'Aktiv';

  @override
  String get message0600 => 'Wird aktualisiert';

  @override
  String get message0601 => 'Status unbekannt';

  @override
  String get languageTitle => 'Sprache';

  @override
  String get systemLanguage => 'Systemstandard';

  @override
  String get languageFollowSystemDescription => 'Der Gerätesprache folgen';

  @override
  String get languageChangeFailed => 'Die Sprache konnte nicht geändert werden. Bitte erneut versuchen.';

  @override
  String get startupStorageFailed => 'Geschützter Speicher konnte nicht gelesen werden. Bitte erneut versuchen.';

  @override
  String get localDataResetFailed => 'Lokale Daten konnten nicht gelöscht werden. Bitte erneut versuchen.';

  @override
  String get appLocked => 'App gesperrt';

  @override
  String get open => 'Öffnen';

  @override
  String get resetLocalData => 'Lokale Daten zurücksetzen';

  @override
  String get resetLocalDataWarning => 'Gespeicherte Profile, Zugangsdaten und Geräteeinstellungen werden gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get deleteLocalData => 'Lokale Daten löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get incomingTorrentTitle => 'Eingehenden Torrent hinzufügen?';

  @override
  String serverName(String name) {
    return 'Server: $name';
  }

  @override
  String get incomingTorrentFile => 'Eine .torrent-Datei';

  @override
  String get incomingTorrentLink => 'Ein Link';

  @override
  String get torrentFile => 'Torrent-Datei';

  @override
  String get unlockReason => 'Home qB Remote entsperren';

  @override
  String get downloadComplete => 'Download abgeschlossen';

  @override
  String get downloadCompletePrivate => 'Download abgeschlossen. Öffne die App, um ihn anzuzeigen.';

  @override
  String get completionChannelName => 'Abgeschlossene Downloads';

  @override
  String get completionChannelDescription => 'Abgeschlossene Downloads auf deinen qBittorrent-Servern';
}
