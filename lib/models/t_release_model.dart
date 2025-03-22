// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:t_release/constants.dart';
import 'package:t_release/models/t_release_version_model.dart';

class TReleaseModel {
  String description;
  String version;
  String repository;
  String changelogUrl;
  String readmeUrl;
  String coverUrl;
  String licenseUrl;
  List<TReleaseVersionModel> versions;
  TReleaseModel({
    required this.description,
    required this.version,
    required this.repository,
    required this.changelogUrl,
    required this.readmeUrl,
    required this.coverUrl,
    required this.licenseUrl,
    required this.versions,
  });

  factory TReleaseModel.fromMap(Map<String, dynamic> map) {
    List<dynamic> versions = map['versions'] ?? [];
    var changelogUrl = map['changelog_url'] ?? '';
    var readmeUrl = map['readme_url'] ?? '';
    var coverUrl = map['cover_url'] ?? '';
    var licenseUrl = map['license_url'] ?? '';
    return TReleaseModel(
      description: map['description'] ?? '',
      version: map['version'] ?? '',
      repository: map['repository'] ?? '',
      changelogUrl: _getDevUrl(changelogUrl),
      readmeUrl: _getDevUrl(readmeUrl),
      coverUrl: _getDevUrl(coverUrl),
      licenseUrl: _getDevUrl(licenseUrl),
      versions:
          versions.map((map) => TReleaseVersionModel.fromMap(map)).toList(),
    );
  }

  static String _getDevUrl(String url) {
    if (isDev) {
      url = url.replaceAll('refs/heads/main', 'refs/heads/main/example');
    }
    return url;
  }
}
