// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get message0001 => 'Could not read the protected profile storage.';

  @override
  String get message0002 => 'Profile storage is unavailable. Changes were not saved; existing data was kept.';

  @override
  String get message0003 => 'An API key cannot be combined with reverse proxy Basic auth: both use the Authorization header.';

  @override
  String get message0004 => 'Sign-in was rejected. Check your access details and reconnect to the server.';

  @override
  String get message0005 => 'Select a server';

  @override
  String get message0006 => 'The selected file is not a valid .torrent. Data was not sent.';

  @override
  String get message0007 => 'Operation failed. Check the connection and server settings.';

  @override
  String get message0008 => 'The HTTP Basic username cannot contain a colon.';

  @override
  String get message0009 => 'Use either an API key or HTTP Basic credentials, not both.';

  @override
  String get message0010 => 'The API key contains spaces, line breaks or other unsupported characters.';

  @override
  String get message0011 => 'Provide both the client certificate and its private key.';

  @override
  String get message0012 => 'The custom CA or client certificate could not be loaded.';

  @override
  String get message0013 => 'Use an HTTP or HTTPS server URL without embedded credentials, query, or fragment.';

  @override
  String get message0014 => 'Invalid API endpoint.';

  @override
  String get message0015 => 'The server connection is closed.';

  @override
  String get message0016 => 'The server did not answer the API key check. Check the server URL and WebUI access settings.';

  @override
  String get message0017 => 'Sign-in failed. Check the server credentials and WebUI access settings.';

  @override
  String get message0018 => 'The server rejected the API key. Check the key and WebUI access settings, then reconnect.';

  @override
  String get message0019 => 'Sign-in was rejected. Check the server credentials and WebUI access settings, then reconnect.';

  @override
  String get message0020 => 'Sign in to the server first.';

  @override
  String get message0021 => 'The server returned invalid JSON.';

  @override
  String get message0022 => 'The server could not complete the action.';

  @override
  String get message0023 => 'The server returned an invalid torrent list.';

  @override
  String get message0024 => 'Select valid torrents first.';

  @override
  String get message0025 => 'Enter a torrent URL or magnet link.';

  @override
  String get message0026 => 'Choose a non-empty torrent file.';

  @override
  String get message0027 => 'Choose a named torrent file.';

  @override
  String get message0028 => 'Invalid torrent option field.';

  @override
  String get message0029 => 'The server rejected the torrent file.';

  @override
  String get message0030 => 'The server returned invalid torrent details.';

  @override
  String get message0031 => 'The server request timed out.';

  @override
  String get message0032 => 'The server returned an invalid redirect.';

  @override
  String get message0033 => 'The server returned too many redirects.';

  @override
  String message0034(String arg1) {
    return 'The server rejected the request (HTTP $arg1).';
  }

  @override
  String get message0035 => 'The server response is too large.';

  @override
  String get message0036 => 'Cannot reach the server. Check its address and connection.';

  @override
  String get message0037 => 'The server connection failed.';

  @override
  String get message0038 => 'The server returned an invalid response.';

  @override
  String get message0039 => 'The server request failed.';

  @override
  String get message0040 => 'The session expired. Sign in again.';

  @override
  String get message0041 => 'The server rejected the request (HTTP 403).';

  @override
  String get message0042 => 'Operation failed';

  @override
  String get message0043 => 'Cancel';

  @override
  String get message0044 => 'Apply';

  @override
  String get message0045 => 'Server tools';

  @override
  String get message0046 => 'No server';

  @override
  String get message0047 => 'Direct connection to your qBittorrent. No ads or analytics.';

  @override
  String get message0048 => 'Torrent search';

  @override
  String get message0049 => 'Your server\'s search plugins';

  @override
  String get message0050 => 'RSS and download rules';

  @override
  String get message0051 => 'Feeds, articles, automatic rules';

  @override
  String get message0052 => 'Speed and limit mode';

  @override
  String get message0053 => 'Download and upload limits in KiB/s';

  @override
  String get message0054 => 'qBittorrent settings';

  @override
  String get message0055 => 'All available WebUI API options';

  @override
  String get message0056 => 'Categories and tags';

  @override
  String get message0057 => 'Create, edit and delete';

  @override
  String get message0058 => 'Server log';

  @override
  String get message0059 => 'Main log and blocked peers';

  @override
  String get message0060 => 'Connection status';

  @override
  String get message0061 => 'Speeds, transferred data and DHT';

  @override
  String get message0062 => 'Magic packet on your local network';

  @override
  String get message0063 => 'Speed limits';

  @override
  String get message0064 => 'Download, KiB/s (0 = no limit)';

  @override
  String get message0065 => 'Upload, KiB/s (0 = no limit)';

  @override
  String get message0066 => 'Alternative mode (true/false)';

  @override
  String get message0067 => 'Limits saved';

  @override
  String get message0068 => 'MAC address';

  @override
  String get message0069 => 'Broadcast address';

  @override
  String get message0070 => 'Port';

  @override
  String get message0071 => 'Magic packet sent';

  @override
  String get message0072 => 'Setting unavailable. Check device permissions and security protection.';

  @override
  String get message0073 => 'Device settings';

  @override
  String get message0074 => 'App lock';

  @override
  String get message0075 => 'OS authentication when opening and returning to the app.';

  @override
  String get message0076 => 'Completion notifications';

  @override
  String get message0077 => 'Checks while the app is open. The app must be running for notifications.';

  @override
  String get message0078 => 'Direct polling of qBittorrent. Background execution is limited by the OS; instant delivery is not guaranteed.';

  @override
  String get message0079 => 'Background check interval';

  @override
  String message0080(String arg1) {
    return '$arg1 min. The OS may delay the start.';
  }

  @override
  String get message0081 => 'Interval, minutes';

  @override
  String get message0082 => 'From 15 to 1440 minutes';

  @override
  String get message0083 => 'Save';

  @override
  String get message0084 => 'No ads or analytics';

  @override
  String get message0085 => 'No Firebase, ad SDKs, remote config, or developer registration. Profiles and certificates are stored in the OS secure storage.';

  @override
  String get message0086 => 'Network connections';

  @override
  String get message0087 => 'The client connects to the qBittorrent servers you specify. Wake-on-LAN sends a packet to the local address you enter. Search and RSS are handled by your server.';

  @override
  String get message0088 => 'Connection security';

  @override
  String get message0089 => 'Use HTTPS or a VPN for remote access. Certificate verification is enabled; a custom CA and client PEM certificate can be set in the profile.';

  @override
  String get message0090 => 'Fill in this field';

  @override
  String get message0091 => 'Confirm';

  @override
  String get message0092 => 'Enter a whole number, zero or greater';

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
  String get message0098 => 'RSS operation failed';

  @override
  String get message0099 => 'Refresh';

  @override
  String get message0100 => 'Add';

  @override
  String get message0101 => 'Add feed';

  @override
  String get message0102 => 'Create folder';

  @override
  String get message0103 => 'Add rule';

  @override
  String get message0104 => 'Folder actions';

  @override
  String get message0105 => 'Articles';

  @override
  String get message0106 => 'Feeds';

  @override
  String get message0107 => 'Rules';

  @override
  String get message0108 => 'No articles in feeds yet';

  @override
  String get message0109 => 'Untitled';

  @override
  String get message0110 => 'Torrent added';

  @override
  String get message0111 => 'Add torrent';

  @override
  String get message0112 => 'Mark as read';

  @override
  String get message0113 => 'Add your first RSS feed with +';

  @override
  String get message0114 => 'Refresh feed';

  @override
  String get message0115 => 'Mark all as read';

  @override
  String get message0116 => 'Move / rename';

  @override
  String get message0117 => 'Delete feed';

  @override
  String get message0118 => 'No automatic download rules';

  @override
  String get message0119 => 'Edit';

  @override
  String get message0120 => 'Rename';

  @override
  String get message0121 => 'Matching articles';

  @override
  String get message0122 => 'Delete rule';

  @override
  String get message0123 => 'RSS folder';

  @override
  String get message0124 => 'Full folder path';

  @override
  String get message0125 => 'Folder action';

  @override
  String get message0126 => 'Delete folder';

  @override
  String get message0127 => 'New RSS feed';

  @override
  String get message0128 => 'New RSS folder';

  @override
  String get message0129 => 'Feed URL';

  @override
  String get message0130 => 'Feed path and name (optional)';

  @override
  String get message0131 => 'New folder path';

  @override
  String get message0132 => 'New RSS path';

  @override
  String get message0133 => 'Path and new name';

  @override
  String get message0134 => 'Delete RSS item?';

  @override
  String message0135(String arg1) {
    return '“$arg1” and its RSS content will be deleted. Torrent files will not be affected.';
  }

  @override
  String get message0136 => 'Delete rule?';

  @override
  String get message0137 => 'Rule name';

  @override
  String get message0138 => 'New name';

  @override
  String message0139(String arg1) {
    return 'Matching articles: $arg1';
  }

  @override
  String get message0140 => 'No matching articles';

  @override
  String get message0141 => 'Close';

  @override
  String get message0142 => 'New RSS rule';

  @override
  String get message0143 => 'RSS rule';

  @override
  String get message0144 => 'Must contain';

  @override
  String get message0145 => 'Must not contain';

  @override
  String get message0146 => 'Episode filter';

  @override
  String get message0147 => 'Feed URLs, one per line';

  @override
  String get message0148 => 'Category';

  @override
  String get message0149 => 'Save path';

  @override
  String get message0150 => 'Do not re-download for, days';

  @override
  String get message0151 => 'Enter a rule name';

  @override
  String get message0152 => 'Rule enabled';

  @override
  String get message0153 => 'Regular expressions';

  @override
  String get message0154 => 'Smart episode filter';

  @override
  String get message0155 => 'Add paused';

  @override
  String get message0156 => 'Search plugins unavailable';

  @override
  String get message0157 => 'Searching your server…';

  @override
  String message0158(int arg1, String arg2) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 results',
      one: '$arg1 result',
    );
    return '$_temp0$arg2';
  }

  @override
  String get message0159 => ' · completed';

  @override
  String message0160(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 results',
      one: '$arg1 result',
    );
    return '$_temp0 · search stopped after 2 minutes';
  }

  @override
  String get message0161 => 'Search failed';

  @override
  String get message0162 => 'Could not stop the search';

  @override
  String message0163(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 results',
      one: '$arg1 result',
    );
    return '$_temp0 · stopped';
  }

  @override
  String get message0164 => 'Server search';

  @override
  String get message0165 => 'Search plugins';

  @override
  String get message0166 => 'Torrent name';

  @override
  String get message0167 => 'Stop';

  @override
  String get message0168 => 'Search';

  @override
  String get message0169 => 'Plugin';

  @override
  String get message0170 => 'All plugins';

  @override
  String get message0171 => 'Enabled only';

  @override
  String get message0172 => 'All';

  @override
  String get message0173 => 'Books';

  @override
  String get message0174 => 'Games';

  @override
  String get message0175 => 'Movies';

  @override
  String get message0176 => 'Music';

  @override
  String get message0177 => 'Software';

  @override
  String get message0178 => 'TV shows';

  @override
  String get message0179 => 'Enter a search query';

  @override
  String message0180(String arg1, String arg2, String arg3) {
    return '$arg1 · seeds $arg2\n$arg3';
  }

  @override
  String get message0181 => 'Add to server';

  @override
  String get message0182 => 'Could not add torrent';

  @override
  String get message0183 => 'Could not change plugins';

  @override
  String get message0184 => 'Install search plugin';

  @override
  String get message0185 => 'Plugin file URL';

  @override
  String get message0186 => 'The plugin will be downloaded and installed on your qBittorrent server. Use only trusted sources.';

  @override
  String get message0187 => 'Search plugins';

  @override
  String get message0188 => 'Update plugins';

  @override
  String get message0189 => 'Install plugin';

  @override
  String get message0190 => 'No search plugins on the server';

  @override
  String message0191(String arg1) {
    return 'Version $arg1';
  }

  @override
  String get message0192 => 'Delete plugin';

  @override
  String get message0193 => 'Delete plugin?';

  @override
  String get message0194 => 'New category';

  @override
  String get message0195 => 'Edit category';

  @override
  String get message0196 => 'Name';

  @override
  String get message0197 => 'Server folder';

  @override
  String get message0198 => 'Categories';

  @override
  String get message0199 => 'Delete category';

  @override
  String get message0200 => 'Delete category?';

  @override
  String message0201(String arg1) {
    return '$arg1. Torrents and files will be kept.';
  }

  @override
  String get message0202 => 'Tags';

  @override
  String get message0203 => 'Create tags';

  @override
  String get message0204 => 'New tags';

  @override
  String get message0205 => 'Names separated by commas';

  @override
  String get message0206 => 'Delete tag';

  @override
  String get message0207 => 'Delete tag?';

  @override
  String message0208(String arg1) {
    return '$arg1. Torrents and files will be kept.';
  }

  @override
  String get message0209 => 'Normal';

  @override
  String get message0210 => 'Info';

  @override
  String get message0211 => 'Warning';

  @override
  String get message0212 => 'Critical';

  @override
  String get message0213 => 'Message';

  @override
  String get message0214 => 'Peer log';

  @override
  String get message0215 => 'Level';

  @override
  String get message0216 => 'All messages';

  @override
  String get message0217 => 'Warnings';

  @override
  String get message0218 => 'Critical';

  @override
  String get message0219 => 'Blocked';

  @override
  String get message0220 => 'Allowed';

  @override
  String get message0221 => 'Download speed';

  @override
  String get message0222 => 'Upload speed';

  @override
  String get message0223 => 'Downloaded this session';

  @override
  String get message0224 => 'Uploaded this session';

  @override
  String get message0225 => 'Download limit';

  @override
  String get message0226 => 'Upload limit';

  @override
  String get message0227 => 'DHT nodes';

  @override
  String get message0228 => 'Connection';

  @override
  String message0229(String arg1) {
    return '$arg1/s';
  }

  @override
  String get message0230 => 'Connected';

  @override
  String get message0231 => 'Behind NAT / firewall';

  @override
  String get message0232 => 'Not connected';

  @override
  String get message0233 => 'Categories and tags';

  @override
  String get message0234 => 'Server status';

  @override
  String get message0235 => 'Couldn\'t load settings';

  @override
  String get message0236 => 'Change WebUI?';

  @override
  String get message0237 => 'Changing the address, port, or authentication may disconnect you.';

  @override
  String get message0238 => 'Settings saved. If the WebUI address, port, or password changed, update your connection profile.';

  @override
  String get message0239 => 'Settings saved';

  @override
  String get message0240 => 'Couldn\'t save settings';

  @override
  String get message0241 => 'Enter a whole number';

  @override
  String get message0242 => 'Port must be 1–65535';

  @override
  String get message0243 => 'Hour must be 0–23';

  @override
  String get message0244 => 'Minute must be 0–59';

  @override
  String get message0245 => 'Minimum −1 (if supported by the server)';

  @override
  String get message0246 => 'Advanced JSON settings';

  @override
  String get message0247 => 'All settings from the current server. Only changed keys are saved.';

  @override
  String get message0248 => 'Invalid settings JSON';

  @override
  String get message0249 => 'Downloads';

  @override
  String get message0250 => 'Save folder';

  @override
  String get message0251 => 'Temp folder';

  @override
  String get message0252 => 'Use temp folder';

  @override
  String get message0253 => 'Add paused';

  @override
  String get message0254 => 'Automatic torrent management';

  @override
  String get message0255 => 'Pre-allocate disk space';

  @override
  String get message0256 => 'Extension for incomplete files';

  @override
  String get message0257 => '.torrent export folder';

  @override
  String get message0258 => 'Export finished .torrent files';

  @override
  String get message0259 => 'Incoming port';

  @override
  String get message0260 => 'Random port on startup';

  @override
  String get message0261 => 'Max connections (-1 = no limit)';

  @override
  String get message0262 => 'Connections per torrent';

  @override
  String get message0263 => 'Upload slots';

  @override
  String get message0264 => 'Proxy address';

  @override
  String get message0265 => 'Proxy port';

  @override
  String get message0266 => 'Proxy username';

  @override
  String get message0267 => 'Proxy password';

  @override
  String get message0268 => 'Speed';

  @override
  String get message0269 => 'Download, bytes/s (0 = no limit)';

  @override
  String get message0270 => 'Upload, bytes/s (0 = no limit)';

  @override
  String get message0271 => 'Alternative download, bytes/s';

  @override
  String get message0272 => 'Alternative upload, bytes/s';

  @override
  String get message0273 => 'Alternative limits schedule';

  @override
  String get message0274 => 'Start: hour';

  @override
  String get message0275 => 'Start: minute';

  @override
  String get message0276 => 'End: hour';

  @override
  String get message0277 => 'End: minute';

  @override
  String get message0278 => 'Include protocol overhead in limits';

  @override
  String get message0279 => 'Limit local peers';

  @override
  String get message0280 => 'Peer exchange (PeX)';

  @override
  String get message0281 => 'Local peer discovery';

  @override
  String get message0282 => 'Anonymous mode';

  @override
  String get message0283 => 'Torrent queueing';

  @override
  String get message0284 => 'Active downloads';

  @override
  String get message0285 => 'Active uploads';

  @override
  String get message0286 => 'Active torrents';

  @override
  String get message0287 => 'Don\'t count slow torrents';

  @override
  String get message0288 => 'Add trackers automatically';

  @override
  String get message0289 => 'Additional trackers';

  @override
  String get message0290 => 'Listening address';

  @override
  String get message0291 => 'WebUI port';

  @override
  String get message0292 => 'Username';

  @override
  String get message0293 => 'New password';

  @override
  String get message0294 => 'Localhost authentication';

  @override
  String get message0295 => 'CSRF protection';

  @override
  String get message0296 => 'Clickjacking protection';

  @override
  String get message0297 => 'Session timeout, seconds';

  @override
  String get message0298 => 'Enable RSS feeds';

  @override
  String get message0299 => 'Auto-download by rules';

  @override
  String get message0300 => 'Refresh interval, minutes';

  @override
  String get message0301 => 'Articles per feed';

  @override
  String get message0302 => 'Episode filters';

  @override
  String get message0303 => 'All settings (JSON)';

  @override
  String get message0304 => 'Advanced settings and options for your server version';

  @override
  String get message0305 => 'Couldn\'t complete the action';

  @override
  String get message0306 => 'Changes applied';

  @override
  String get message0307 => 'Manage torrent';

  @override
  String get message0308 => 'Organize';

  @override
  String get message0309 => 'Torrent name';

  @override
  String get message0310 => 'Rename torrent';

  @override
  String get message0311 => 'Move files';

  @override
  String get message0312 => 'New server path';

  @override
  String get message0313 => 'Full path';

  @override
  String get message0314 => 'qBittorrent moves the files on the server';

  @override
  String get message0315 => 'Add tags';

  @override
  String get message0316 => 'Tags, comma-separated';

  @override
  String get message0317 => 'Remove tags';

  @override
  String get message0318 => 'Speed and seeding';

  @override
  String get message0319 => 'Speed limits';

  @override
  String get message0320 => 'Seeding limits';

  @override
  String get message0321 => 'Force start';

  @override
  String get message0322 => 'Super seeding';

  @override
  String get message0323 => 'Toggle sequential download';

  @override
  String get message0324 => 'Toggle first/last piece priority';

  @override
  String get message0325 => 'Force recheck';

  @override
  String get message0326 => 'Recheck files?';

  @override
  String get message0327 => 'Rechecking may take a while and temporarily pause transfers.';

  @override
  String get message0328 => 'Reannounce to trackers';

  @override
  String get message0329 => 'Queue';

  @override
  String get message0330 => 'Move to top';

  @override
  String get message0331 => 'Move up';

  @override
  String get message0332 => 'Move down';

  @override
  String get message0333 => 'Move to bottom';

  @override
  String get message0334 => 'Content and connections';

  @override
  String get message0335 => 'Export .torrent';

  @override
  String get message0336 => 'Files and priorities';

  @override
  String get message0337 => 'Rename folder';

  @override
  String get message0338 => 'Current path within torrent';

  @override
  String get message0339 => 'New path within torrent';

  @override
  String get message0340 => 'Trackers';

  @override
  String get message0341 => 'Peers';

  @override
  String get message0342 => 'HTTP sources';

  @override
  String get message0343 => 'Piece states';

  @override
  String get message0344 => 'Uncategorized';

  @override
  String get message0345 => 'Download, KiB/s';

  @override
  String get message0346 => 'Upload, KiB/s';

  @override
  String get message0347 => '0 = no limit. 1 KiB/s = 1024 bytes/s.';

  @override
  String get message0348 => 'Ratio';

  @override
  String get message0349 => 'Enter a number';

  @override
  String get message0350 => 'Seeding time, minutes';

  @override
  String get message0351 => 'Enter a whole number';

  @override
  String get message0352 => 'Inactive seeding time, minutes';

  @override
  String get message0353 => '-2 = use server settings, -1 = no limit.';

  @override
  String get message0354 => 'Enable';

  @override
  String get message0355 => 'Disable';

  @override
  String get message0356 => 'Files';

  @override
  String message0357(String arg1, String arg2) {
    return '$arg1 · priority $arg2';
  }

  @override
  String get message0358 => 'Rename file';

  @override
  String get message0359 => 'Changes applied. Reopen the list to refresh.';

  @override
  String get message0360 => 'Action failed';

  @override
  String get message0361 => 'Do not download';

  @override
  String get message0362 => 'Normal priority';

  @override
  String get message0363 => 'High priority';

  @override
  String get message0364 => 'Maximum priority';

  @override
  String get message0365 => 'Edit tracker';

  @override
  String get message0366 => 'New URL';

  @override
  String get message0367 => 'Remove tracker?';

  @override
  String get message0368 => 'Couldn\'t edit tracker';

  @override
  String get message0369 => 'Remove';

  @override
  String get message0370 => 'Add trackers';

  @override
  String get message0371 => 'URLs, one per line';

  @override
  String get message0372 => 'Couldn\'t add trackers';

  @override
  String get message0373 => 'No connected peers';

  @override
  String message0374(String arg1, String arg2) {
    return '$arg1 · ↓ $arg2/s';
  }

  @override
  String get message0375 => 'Add peers';

  @override
  String get message0376 => 'IP:port, separated by |';

  @override
  String get message0377 => 'Couldn\'t add peers';

  @override
  String message0378(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: '$arg1 pieces',
      one: '$arg1 piece',
    );
    return '$_temp0';
  }

  @override
  String get message0379 => 'Grey: missing, blue: downloading, green: done. Showing the first 4096 pieces.';

  @override
  String message0380(String arg1) {
    return 'Piece $arg1';
  }

  @override
  String get message0381 => 'Export complete';

  @override
  String get message0382 => 'Export cancelled';

  @override
  String get message0383 => 'Enter a URL';

  @override
  String get message0384 => 'URL must not contain spaces, control characters, or \"|\"';

  @override
  String get message0385 => 'Enter an http:// or https:// address with a host name';

  @override
  String get message0386 => 'Enter at least one URL';

  @override
  String get message0387 => 'The server does not support changing HTTP sources. ';

  @override
  String get message0388 => 'Requires qBittorrent 5.2 or later; view-only.';

  @override
  String get message0389 => 'Couldn\'t load HTTP sources';

  @override
  String get message0390 => 'Add HTTP sources';

  @override
  String get message0391 => 'Addresses are passed to the qBittorrent server; the app does not connect to them directly.';

  @override
  String get message0392 => 'Couldn\'t add HTTP sources';

  @override
  String get message0393 => 'Edit HTTP source';

  @override
  String get message0394 => 'Address unchanged';

  @override
  String get message0395 => 'Couldn\'t edit HTTP source';

  @override
  String get message0396 => 'Remove HTTP source?';

  @override
  String get message0397 => 'Couldn\'t remove HTTP source';

  @override
  String get message0398 => 'Add sources';

  @override
  String get message0399 => 'Editing HTTP sources requires qBittorrent 5.2 or later. ';

  @override
  String get message0400 => 'An older server may reject the changes.';

  @override
  String get message0401 => 'Retry';

  @override
  String get message0402 => 'No HTTP sources';

  @override
  String get message0403 => 'Couldn\'t initialize secure storage.';

  @override
  String get message0404 => 'Add incoming torrent?';

  @override
  String message0405(String arg1) {
    return 'Server: $arg1';
  }

  @override
  String get message0406 => 'One .torrent file';

  @override
  String get message0407 => 'One link';

  @override
  String get message0408 => '.torrent file';

  @override
  String get message0409 => 'Couldn\'t delete local data.';

  @override
  String get message0410 => 'Home qB locked';

  @override
  String get message0411 => 'Open';

  @override
  String get message0412 => 'Reset local data';

  @override
  String get message0413 => 'Profiles, passwords, and certificates will be deleted from this device. Torrents on the server will be kept.';

  @override
  String get message0414 => 'Delete local data';

  @override
  String get message0415 => 'Device settings could not be read from secure storage.';

  @override
  String get message0416 => 'Background polling could not be scheduled on this device.';

  @override
  String get message0417 => 'Background polling is available on Android and iOS. Desktop notifications require the app to remain open.';

  @override
  String get message0418 => 'Notifications are not configured on this platform.';

  @override
  String get message0419 => 'System notifications are unavailable.';

  @override
  String get message0420 => 'System notifications could not be initialized.';

  @override
  String get message0421 => 'Android may delay polling because of battery, network, or background restrictions.';

  @override
  String get message0422 => 'Choose a polling interval between 15 and 1440 minutes.';

  @override
  String get message0423 => 'The new interval was saved, but the background schedule could not be updated.';

  @override
  String get message0424 => 'Notifications are unavailable.';

  @override
  String get message0425 => 'Notification permission was not granted.';

  @override
  String get message0426 => 'The background schedule could not be updated. Foreground notification checks still work.';

  @override
  String get message0427 => 'Unlock Home qB Remote';

  @override
  String get message0428 => 'Device authentication was not completed.';

  @override
  String get message0429 => 'Couldn\'t enable screenshot protection.';

  @override
  String get message0430 => 'Couldn\'t remove system notifications.';

  @override
  String get message0431 => 'Couldn\'t cancel the background check.';

  @override
  String get message0432 => 'Download complete';

  @override
  String get message0433 => 'Download complete. Open the app to view it.';

  @override
  String get message0434 => 'Completed downloads';

  @override
  String get message0435 => 'Completed downloads on your qBittorrent servers';

  @override
  String get message0436 => 'Background scan budget exhausted.';

  @override
  String get message0437 => 'Only a local .torrent document can be imported.';

  @override
  String get message0438 => 'Document import is not supported on this platform.';

  @override
  String get message0439 => 'Document import is not available in this build of the app.';

  @override
  String get message0440 => 'The document was rejected by the system.';

  @override
  String get message0441 => 'The torrent document could not be read.';

  @override
  String get message0442 => 'The torrent document is empty.';

  @override
  String get message0443 => 'The torrent document is larger than 16 MiB and cannot be imported.';

  @override
  String get message0444 => 'The document is not a valid .torrent file.';

  @override
  String get message0445 => 'Russian';

  @override
  String get message0446 => 'Ukrainian';

  @override
  String get message0447 => 'Unsupported language';

  @override
  String get message0448 => 'Another export is still in progress.';

  @override
  String get message0449 => 'Export is not supported on this platform.';

  @override
  String get message0450 => 'There is no torrent data to export.';

  @override
  String get message0451 => 'The torrent file is larger than 16 MiB and cannot be exported.';

  @override
  String get message0452 => 'The torrent data is not a valid byte sequence.';

  @override
  String get message0453 => 'Export is not available in this build of the app.';

  @override
  String get message0454 => 'The torrent data was rejected by the system.';

  @override
  String get message0455 => 'The torrent file could not be saved.';

  @override
  String get message0456 => 'The save dialog could not be opened.';

  @override
  String get message0457 => 'The torrent file could not be written to the chosen location.';

  @override
  String get message0458 => 'Enter a whole number from 0';

  @override
  String get message0459 => 'New download';

  @override
  String get message0460 => 'Magnet links or URLs';

  @override
  String get message0461 => 'One link per line';

  @override
  String get message0462 => 'Choose .torrent file';

  @override
  String get message0463 => 'Download options';

  @override
  String get message0464 => 'Tags, comma-separated';

  @override
  String get message0465 => 'New name (optional)';

  @override
  String get message0466 => 'Download limit, KiB/s';

  @override
  String get message0467 => '0 — no limit; empty — server setting';

  @override
  String get message0468 => 'Upload limit, KiB/s';

  @override
  String get message0469 => 'File structure';

  @override
  String get message0470 => 'As in torrent';

  @override
  String get message0471 => 'Create subfolder';

  @override
  String get message0472 => 'No subfolder';

  @override
  String get message0473 => 'Add paused';

  @override
  String get message0474 => 'Sequential download';

  @override
  String get message0475 => 'First and last pieces first';

  @override
  String get message0476 => 'PKCS#12 password';

  @override
  String get message0477 => 'Container password';

  @override
  String get message0478 => 'Import';

  @override
  String get message0479 => 'Home qB';

  @override
  String get message0480 => 'Manage servers';

  @override
  String get message0481 => 'App settings';

  @override
  String get message0482 => 'YOUR CONNECTION';

  @override
  String get message0483 => 'No server selected';

  @override
  String get message0484 => 'Servers';

  @override
  String get message0485 => 'RSS, search, settings';

  @override
  String get message0486 => 'Downloading';

  @override
  String get message0487 => 'Seeding';

  @override
  String get message0488 => 'Paused';

  @override
  String get message0489 => 'Errors';

  @override
  String get message0490 => 'All torrents';

  @override
  String get message0491 => 'Only your servers.\nNo ads or telemetry.';

  @override
  String get message0492 => 'Your downloads, at your fingertips';

  @override
  String get message0493 => 'Connect your home qBittorrent via Web UI.\nThe server address and settings are stored on this device.';

  @override
  String get message0494 => 'Connect server';

  @override
  String get message0495 => 'Browse downloads';

  @override
  String get message0496 => 'Current server';

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
  String get message0500 => 'Find torrent by name';

  @override
  String message0501(String arg1) {
    return 'Selected: $arg1';
  }

  @override
  String get message0502 => 'Resume selected';

  @override
  String get message0503 => 'Pause selected';

  @override
  String get message0504 => 'Delete selected';

  @override
  String get message0505 => 'Clear selection';

  @override
  String get message0506 => 'Nothing found';

  @override
  String get message0507 => 'No torrents yet';

  @override
  String get message0508 => 'Add a magnet link, URL, or .torrent file.';

  @override
  String get message0509 => 'Resume';

  @override
  String get message0510 => 'Pause';

  @override
  String get message0511 => 'Actions';

  @override
  String get message0512 => 'Details';

  @override
  String get message0513 => 'Delete…';

  @override
  String message0514(String arg1) {
    return '↓ $arg1/s';
  }

  @override
  String message0515(String arg1) {
    return '↑ $arg1/s';
  }

  @override
  String get message0516 => 'Couldn\'t complete the action. Check your server connection.';

  @override
  String get message0517 => 'My servers';

  @override
  String get message0518 => 'Server settings';

  @override
  String get message0519 => 'Edit';

  @override
  String get message0520 => 'Delete profile';

  @override
  String get message0521 => 'Add server';

  @override
  String get message0522 => 'Delete profile?';

  @override
  String message0523(String arg1) {
    return 'Profile “$arg1” will be removed from this device. Torrents on the server will be kept.';
  }

  @override
  String get message0524 => 'Use local HTTP?';

  @override
  String get message0525 => 'SSID does not verify the network\'s identity. On another network with the same name, your password could reach an unauthorized server. For protection, use HTTPS with certificate verification or a VPN.';

  @override
  String get message0526 => 'Choose a .torrent file up to 16 MB.';

  @override
  String get message0527 => 'Couldn\'t open the selected file.';

  @override
  String get message0528 => 'Delete torrent?';

  @override
  String message0529(int arg1) {
    String _temp0 = intl.Intl.pluralLogic(
      arg1,
      locale: localeName,
      other: 'Delete $arg1 torrents?',
      one: 'Delete $arg1 torrent?',
    );
    return '$_temp0';
  }

  @override
  String get message0530 => 'By default, downloaded files will stay on the server.';

  @override
  String get message0531 => 'Also delete files from server';

  @override
  String get message0532 => 'This action can\'t be undone';

  @override
  String get message0533 => 'Home server';

  @override
  String get message0534 => 'Couldn\'t import PKCS#12. Check the password and file (up to 4 MB).';

  @override
  String get message0535 => 'Enter a name';

  @override
  String get message0536 => 'Web UI address';

  @override
  String get message0537 => 'HTTP or HTTPS, including port and path';

  @override
  String get message0538 => 'Enter the full HTTP(S) server address';

  @override
  String get message0539 => 'Remove password, parameters, and # from the address';

  @override
  String get message0540 => 'Password';

  @override
  String get message0541 => 'Hide password';

  @override
  String get message0542 => 'Show password';

  @override
  String get message0543 => 'API key (optional)';

  @override
  String get message0544 => 'qBittorrent 5.2+. If filled in, it\'s used instead of username and password.';

  @override
  String get message0545 => 'API key can\'t be combined with a Basic auth proxy';

  @override
  String get message0546 => 'Local Wi-Fi address';

  @override
  String get message0547 => 'Optional. The SSID is used only on the device to select an address. The OS may request location permission to read the Wi-Fi name; coordinates are not read.';

  @override
  String get message0548 => 'Local URL';

  @override
  String get message0549 => 'Enter an HTTP(S) address without password or parameters';

  @override
  String get message0550 => 'Home Wi-Fi network (SSID)';

  @override
  String get message0551 => 'SSID unavailable. You can enter the network name manually.';

  @override
  String get message0552 => 'Read current network';

  @override
  String get message0553 => 'Proxy and certificates';

  @override
  String get message0554 => 'Basic auth for reverse proxy; PEM for HTTPS and client certificate.';

  @override
  String get message0555 => 'Basic auth: username';

  @override
  String get message0556 => 'Basic auth: password';

  @override
  String get message0557 => 'Custom CA (PEM)';

  @override
  String get message0558 => 'Client certificate (PEM)';

  @override
  String get message0559 => 'Private key (PEM)';

  @override
  String get message0560 => 'Import PKCS#12 (.p12/.pfx)';

  @override
  String get message0561 => 'Private key password';

  @override
  String get message0562 => 'PEM file must be smaller than 1 MB.';

  @override
  String get message0563 => 'Couldn\'t read PEM file.';

  @override
  String get message0564 => 'Import file';

  @override
  String get message0565 => 'Torrent actions';

  @override
  String get message0566 => 'Recheck';

  @override
  String get message0567 => 'Update trackers';

  @override
  String get message0568 => 'Force start';

  @override
  String get message0569 => 'First and last pieces';

  @override
  String get message0570 => 'Couldn\'t load torrent details.';

  @override
  String get message0571 => 'Browse';

  @override
  String get message0572 => 'File list is empty';

  @override
  String get message0573 => 'File';

  @override
  String get message0574 => 'File priority';

  @override
  String get message0575 => 'High';

  @override
  String get message0576 => 'Maximum';

  @override
  String get message0577 => 'No trackers';

  @override
  String get message0578 => 'Tracker';

  @override
  String get message0579 => 'Couldn\'t change torrent.';

  @override
  String get message0580 => 'Status';

  @override
  String get message0581 => 'Size';

  @override
  String get message0582 => 'Done';

  @override
  String get message0583 => 'Downloaded';

  @override
  String get message0584 => 'Uploaded';

  @override
  String get message0585 => 'Comment';

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
  String get message0591 => 'Error';

  @override
  String get message0592 => 'Checking';

  @override
  String get message0593 => 'Moving';

  @override
  String get message0594 => 'Queued';

  @override
  String get message0595 => 'Metadata';

  @override
  String get message0596 => 'Server';

  @override
  String get message0597 => 'Not polled';

  @override
  String get message0598 => 'Down';

  @override
  String get message0599 => 'Working';

  @override
  String get message0600 => 'Updating';

  @override
  String get message0601 => 'Status unknown';

  @override
  String get languageTitle => 'Language';

  @override
  String get systemLanguage => 'System default';

  @override
  String get languageFollowSystemDescription => 'Follow the device language';

  @override
  String get languageChangeFailed => 'The language could not be changed. Try again.';

  @override
  String get startupStorageFailed => 'Could not read protected storage. Try again.';

  @override
  String get localDataResetFailed => 'Could not delete local data. Try again.';

  @override
  String get appLocked => 'App locked';

  @override
  String get open => 'Open';

  @override
  String get resetLocalData => 'Reset local data';

  @override
  String get resetLocalDataWarning => 'Saved profiles, credentials and device settings will be deleted. This cannot be undone.';

  @override
  String get deleteLocalData => 'Delete local data';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get incomingTorrentTitle => 'Add incoming torrent?';

  @override
  String serverName(String name) {
    return 'Server: $name';
  }

  @override
  String get incomingTorrentFile => 'One .torrent file';

  @override
  String get incomingTorrentLink => 'One link';

  @override
  String get torrentFile => 'Torrent file';

  @override
  String get unlockReason => 'Unlock Home qB Remote';

  @override
  String get downloadComplete => 'Download complete';

  @override
  String get downloadCompletePrivate => 'Download complete. Open the app to view it.';

  @override
  String get completionChannelName => 'Completed downloads';

  @override
  String get completionChannelDescription => 'Completed downloads on your qBittorrent servers';

  @override
  String get integrationsTitle => 'Integrations';

  @override
  String get integrationsNotice => 'Optional connections to your own servers. Search never starts a download automatically.';

  @override
  String get integrationAddJackett => 'Add Jackett';

  @override
  String get integrationAddJellyfin => 'Add Jellyfin';

  @override
  String get integrationName => 'Profile name';

  @override
  String get integrationServerUrl => 'Server URL';

  @override
  String get integrationApiKey => 'API key';

  @override
  String get integrationAccessToken => 'User access token';

  @override
  String get integrationUserId => 'Jellyfin user ID';

  @override
  String get integrationSave => 'Save profile';

  @override
  String get integrationEdit => 'Edit profile';

  @override
  String get integrationRemove => 'Remove profile';

  @override
  String get integrationRemoveConfirm => 'Remove this connection from the app? Server data will remain unchanged.';

  @override
  String get integrationCancel => 'Cancel';

  @override
  String get integrationInvalidProfile => 'Enter a name, a valid HTTP(S) server URL and the required credentials.';

  @override
  String get integrationStorageFailed => 'Protected integration storage is unavailable. Existing profiles were preserved.';

  @override
  String get integrationRetry => 'Retry';

  @override
  String get integrationHttpNotice => 'HTTP sends credentials without encryption. Use it only on a trusted local network.';

  @override
  String get integrationSecretNotice => 'Credentials are stored in protected device storage and sent only to the configured service.';

  @override
  String get integrationNoProfiles => 'No integrations configured.';

  @override
  String get jackettSearchTitle => 'Jackett search';

  @override
  String get jackettSearchHint => 'Search configured indexers';

  @override
  String get jackettSearchAction => 'Search';

  @override
  String get jackettSearchEmpty => 'No matching results.';

  @override
  String get jackettSearchFailed => 'Jackett search failed. Check the server, API key and indexer configuration.';

  @override
  String get jackettDownloadFailed => 'Could not retrieve a valid torrent from the configured Jackett server.';

  @override
  String get jackettDownloadAction => 'Download';

  @override
  String get jackettUnknownValue => 'Unknown';

  @override
  String get jackettNoTarget => 'Select a qBittorrent server before adding a download.';

  @override
  String get jackettAdded => 'Download submitted. Check the torrent list for its status.';

  @override
  String get jellyfinLibraryTitle => 'Jellyfin library';

  @override
  String get jellyfinSearchHint => 'Search your library';

  @override
  String get jellyfinSearchAction => 'Search';

  @override
  String get jellyfinEmptyLibrary => 'No matching library items.';

  @override
  String get jellyfinReadOnlyNotice => 'Browse your existing library. Playback is not available here yet.';

  @override
  String get jellyfinConnectionFailed => 'Could not connect to Jellyfin. Check the profile and try again.';

  @override
  String get jellyfinAuthenticationFailed => 'Jellyfin rejected the access token or user.';

  @override
  String get jellyfinInvalidResponse => 'Jellyfin returned an invalid or oversized response.';

  @override
  String get jellyfinInvalidProfile => 'Enter a valid server URL, access token and user ID.';

  @override
  String get jellyfinRedirectBlocked => 'Jellyfin redirected outside the configured server.';

  @override
  String get jellyfinRetry => 'Retry';

  @override
  String get jellyfinClose => 'Close';

  @override
  String get searchDownloadConfirmTitle => 'Confirm download';

  @override
  String searchDownloadTarget(String name) {
    return 'Target server: $name';
  }

  @override
  String get searchDownloadDataNotice => 'The link and torrent metadata will be sent to this qBittorrent server. URLs may contain tracker credentials.';

  @override
  String get searchResultUrlHidden => 'Source and download URLs are hidden because they may contain credentials.';

  @override
  String get searchProfileChanged => 'The selected server changed. Start a new search before downloading.';

  @override
  String get searchAlreadyAdded => 'This torrent is already on the selected server or has already been submitted.';

  @override
  String get searchAddOutcomeUnknown => 'The download request may have reached the server. Check its torrent list before trying again.';

  @override
  String get searchCheckServer => 'Check server';

  @override
  String get searchUnsupportedDownload => 'This result has no supported download link.';

  @override
  String get searchAddOptions => 'Download options';

  @override
  String get searchConfirmAdd => 'Confirm and add';

  @override
  String get torrentListFilterHint => 'Filter your current torrents';

  @override
  String get clearTorrentListFilter => 'Clear torrent filter';
}
