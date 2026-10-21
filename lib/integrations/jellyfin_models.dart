/// Independent service credentials. Persist only in the OS protected store.
class JellyfinProfile {
  const JellyfinProfile({
    required this.id,
    required this.name,
    required this.url,
    required this.accessToken,
    required this.userId,
  });

  final String id;
  final String name;
  final String url;
  final String accessToken;
  final String userId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'accessToken': accessToken,
    'userId': userId,
  };

  factory JellyfinProfile.fromJson(Map<String, dynamic> json) =>
      JellyfinProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        url: json['url'] as String,
        accessToken: json['accessToken'] as String,
        userId: json['userId'] as String,
      );
}

class JellyfinUser {
  const JellyfinUser({required this.id, required this.name});
  final String id;
  final String name;
}

class JellyfinItem {
  const JellyfinItem({
    required this.id,
    required this.title,
    this.year,
    this.type,
    this.overview,
  });

  final String id;
  final String title;
  final int? year;
  final String? type;
  final String? overview;

  factory JellyfinItem.fromJson(Map<String, dynamic> json) => JellyfinItem(
    id: json['Id'] as String,
    title: json['Name'] as String,
    year: (json['ProductionYear'] as num?)?.toInt(),
    type: json['Type'] as String?,
    overview: json['Overview'] as String?,
  );
}
