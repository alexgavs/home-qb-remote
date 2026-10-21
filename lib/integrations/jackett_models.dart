/// Optional service credentials. Persist only in the protected integration store.
class JackettProfile {
  const JackettProfile({
    required this.id,
    required this.name,
    required this.url,
    required this.apiKey,
  });
  final String id;
  final String name;
  final String url;
  final String apiKey;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'apiKey': apiKey,
  };
  factory JackettProfile.fromJson(Map<String, dynamic> json) => JackettProfile(
    id: json['id'] as String,
    name: json['name'] as String,
    url: json['url'] as String,
    apiKey: json['apiKey'] as String,
  );
}

/// Download URLs may contain private tracker credentials: never log or hand
/// these URLs to qBittorrent. Download bytes through JackettClient instead.
class JackettResult {
  const JackettResult({
    required this.title,
    required this.downloadUri,
    this.magnetUri,
    this.size,
    this.seeders,
    this.indexer,
  });
  final String title;
  final Uri downloadUri;
  final Uri? magnetUri;
  final int? size;
  final int? seeders;
  final String? indexer;
}

/// Stable, redacted codes for localized presentation by the caller.
class JackettException implements Exception {
  const JackettException(this.code, {this.statusCode});
  final String code;
  final int? statusCode;
  @override
  String toString() => 'JackettException($code)';
}
