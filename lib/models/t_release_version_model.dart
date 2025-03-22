// ignore_for_file: public_member_api_docs, sort_constructors_first
class TReleaseVersionModel {
  String version;
  String platform;
  String url;
  String description;
  int date;
  TReleaseVersionModel({
    required this.version,
    required this.platform,
    required this.url,
    required this.description,
    required this.date,
  });

  factory TReleaseVersionModel.fromMap(Map<String, dynamic> map) {
    return TReleaseVersionModel(
      version: map['version'] ?? '',
      platform: map['platform'] ?? '',
      url: map['url'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? 0,
    );
  }
  @override
  String toString() {
    return '\nversion: $version\nplatform: $platform\nurl: $url\ndesc: $description\n';
  }
}
