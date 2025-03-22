import 'dart:io';
import 'package:t_release/models/t_release_version_model.dart';
import 'package:t_release/services/t_release_services.dart';

class TReleaseVersionServices {
  static TReleaseVersionServices instance = TReleaseVersionServices._();
  TReleaseVersionServices._();
  factory TReleaseVersionServices() => instance;

  Future<bool> isLatestVersion(String currentVersion) async {
    var res = false;
    final versions = await getVersionList();
    if (versions.isEmpty) return true;
    for (var version in versions) {
      if (version.platform == Platform.operatingSystem &&
          currentVersion.compareTo(version.version) == -1) {
        //is version update
        res = true;
        break;
      }
    }
    return res;
  }

  Future<TReleaseVersionModel?> getLatestVersion(String currentVersion) async {
    TReleaseVersionModel? res;
    final versions = await getVersionList();
    if (versions.isEmpty) return null;
    for (var version in versions) {
      if (version.platform == Platform.operatingSystem &&
          currentVersion.compareTo(version.version) == -1) {
        //is version update
        res = version;
        break;
      }
    }
    return res;
  }

  Future<List<TReleaseVersionModel>> getVersionList() async {
    List<TReleaseVersionModel> list = [];
    final res = await TReleaseServices.instance.getRelease();
    if (res == null) return list;
    return res.versions;
  }
}
