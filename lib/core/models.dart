class ServerProfile {
  const ServerProfile({
    required this.id,
    required this.name,
    required this.url,
    required this.username,
    required this.password,
    this.apiKey = '',
    this.basicAuthUsername = '',
    this.basicAuthPassword = '',
    this.customCaPem = '',
    this.clientCertificatePem = '',
    this.clientKeyPem = '',
    this.clientKeyPassword = '',
    this.localUrl = '',
    this.localSsid = '',
  });

  final String id;
  final String name;
  final String url;
  final String username;
  final String password;

  /// qBittorrent 5.2+ WebUI API key. When non-empty it replaces the
  /// username/password login. Empty for legacy profiles.
  final String apiKey;
  final String basicAuthUsername;
  final String basicAuthPassword;
  final String customCaPem;
  final String clientCertificatePem;
  final String clientKeyPem;
  final String clientKeyPassword;
  final String localUrl;
  final String localSsid;

  ServerProfile withUrl(String value) => ServerProfile(
    id: id,
    name: name,
    url: value,
    username: username,
    password: password,
    apiKey: apiKey,
    basicAuthUsername: basicAuthUsername,
    basicAuthPassword: basicAuthPassword,
    customCaPem: customCaPem,
    clientCertificatePem: clientCertificatePem,
    clientKeyPem: clientKeyPem,
    clientKeyPassword: clientKeyPassword,
    localUrl: localUrl,
    localSsid: localSsid,
  );
}

class Torrent {
  const Torrent({
    required this.hash,
    required this.name,
    required this.size,
    required this.progress,
    required this.dlspeed,
    required this.upspeed,
    required this.state,
    required this.eta,
    required this.category,
    required this.ratio,
    this.addedOn = 0,
  });

  factory Torrent.fromJson(Map<String, dynamic> json) => Torrent(
    hash: _string(json['hash']),
    name: _string(json['name']),
    size: _number(json['size']).toInt(),
    progress: _number(json['progress']).toDouble(),
    dlspeed: _number(json['dlspeed']).toInt(),
    upspeed: _number(json['upspeed']).toInt(),
    state: _string(json['state']),
    eta: _number(json['eta']).toInt(),
    category: _string(json['category']),
    ratio: _number(json['ratio']).toDouble(),
    addedOn: _timestamp(json['added_on']),
  );

  final String hash;
  final String name;
  final int size;
  final double progress;
  final int dlspeed;
  final int upspeed;
  final String state;
  final int eta;
  final String category;
  final double ratio;

  /// Server-provided Unix seconds, or 0 when absent/unknown.
  final int addedOn;

  static int _timestamp(Object? value) {
    final number = _number(value);
    return number > 0 ? number.toInt() : 0;
  }

  static String _string(Object? value) => value is String ? value : '';
  static num _number(Object? value) {
    final number = value is num ? value : num.tryParse('$value') ?? 0;
    return number.isFinite ? number : 0;
  }
}

class TorrentDetails {
  const TorrentDetails({
    required this.properties,
    required this.files,
    required this.trackers,
  });

  final Map<String, dynamic> properties;
  final List<Map<String, dynamic>> files;
  final List<Map<String, dynamic>> trackers;
}
