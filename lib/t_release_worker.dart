import 'dart:convert';
import 'dart:io';
import 'package:yaml/yaml.dart';

class TReleaseWorker {
  static TReleaseWorker instance = TReleaseWorker._();
  TReleaseWorker._();
  factory TReleaseWorker() => instance;

  Map<String, dynamic> pubspec = {};
  String currentPath = '';

  Future<void> init() async {
    try {
      currentPath = Directory.current.path;
      final file = File('$currentPath/pubspec.yaml');
      if (!file.existsSync()) {
        print('file မရှိပါ');
        return;
      }
      final res = loadYaml(file.readAsStringSync());
      pubspec = Map<String, dynamic>.from(res);

      await initChangeLog();
      await initReleaseFile();
      print('Created Successfully');
    } catch (e) {
      print('init: ${e.toString()}');
    }
  }

  Future<void> initReleaseFile() async {
    try {
      Map<String, dynamic> release = {};
      final file = File('$currentPath/release.json');
      if (await file.exists()) {
        release = jsonDecode(await file.readAsString());
      }
      List<dynamic> versions = release['versions'] ?? [];

      String desc = pubspec['description'] ?? '';
      String version = pubspec['version'] ?? '';
      String repository = pubspec['repository'] ?? '';
      //set
      release['description'] = desc;
      release['version'] = version;
      release['repository'] = repository;

      release['changelog_url'] = "";
      release['readme_url'] = "";
      release['cover_url'] = "";
      var genReleasePlatforms = [Platform.operatingSystem];
      //auto
      if (repository.isNotEmpty) {
        //auto ထည့်မယ်
        release['changelog_url'] = getRawUrl(repository, 'CHANGELOG.md');
        release['readme_url'] = getRawUrl(repository, 'README.md');
        release['license_url'] = getRawUrl(repository, 'LICENSE');
      }
      //custom t_release
      final releasePubspecMap = pubspec['t_release'];
      if (releasePubspecMap != null) {
        final coverPath = releasePubspecMap['cover_path'];
        final coverUrl = releasePubspecMap['cover_url'];

        if (releasePubspecMap['changelog_url'] != null) {
          release['changelog_url'] = releasePubspecMap['changelog_url'];
        }
        if (releasePubspecMap['readme_url'] != null) {
          release['readme_url'] = releasePubspecMap['readme_url'];
        }
        //cover path
        if (coverPath != null && coverPath.toString().isNotEmpty) {
          if (repository.isNotEmpty) {
            release['cover_url'] = getRawUrl(repository, coverPath.toString());
          }
        }
        //cover url
        if (coverUrl != null && coverUrl.toString().isNotEmpty) {
          release['cover_url'] = coverUrl.toString();
        }
        //platforms
        if (releasePubspecMap['platfoms'] != null) {
          String platforms =
              releasePubspecMap['platfoms'] ?? Platform.operatingSystem;
          genReleasePlatforms = platforms.split(',');
        }
      }

      //version မတူညီရင် ထည့်မယ်
      if (versions.isEmpty || versions.first['version'] != version) {
        //add version
        for (var plaform in genReleasePlatforms) {
          versions.insert(0, {
            "version": version,
            "plaform": plaform,
            "url": "",
            "description": "",
            "date": DateTime.now().millisecondsSinceEpoch,
          });
        }
      }
      //version list
      release['versions'] = versions;

      //save
      await file.writeAsString(JsonEncoder.withIndent(' ').convert(release));
    } catch (e) {
      print('initReleaseFile: ${e.toString()}');
    }
  }

  String getCoverFileName() {
    final dir = Directory('$currentPath/assets');
    if (!dir.existsSync()) return 'cover.png';
    for (var file in dir.listSync()) {
      final name = file.path.split('/').last;
      if (name.startsWith('cover')) {
        return name;
      }
    }
    return 'cover.png';
  }

  //init change log file
  Future<void> initChangeLog() async {
    final currentVersion = pubspec['version'];
    final file = File('$currentPath/CHANGELOG.md');
    if (!await file.exists()) {
      //မရှိရင်
      String res = '''## $currentVersion\n\n- init todo''';
      await file.writeAsString(res);

      return;
    }
    //ရှိနေရင်
    if (file.readAsLinesSync().isEmpty) {
      String res = '''## $currentVersion\n\n- init todo''';
      await file.writeAsString(res);
      return;
    }
    final latestVersion = file.readAsLinesSync().first.split(' ').last;
    if (latestVersion.compareTo(currentVersion) == -1) {
      //need add
      String res = '''## $currentVersion\n\n- init todo''';
      String oldDoc = await file.readAsString();
      oldDoc = '''$res\n\n$oldDoc''';
      await file.writeAsString(oldDoc);
    }
  }

  String getRawUrl(String repository, String filePath) {
    var rawHost = repository.replaceAll('github', 'raw.githubusercontent');
    return '$rawHost/refs/heads/main/$filePath';
  }
}

  // "github_url": "https://github.com/ThanCoder/novelv3",
  // "cover_url": "https://raw.githubusercontent.com/ThanCoder/novelv3/refs/heads/main/assets/online.webp",
  // "changelog_url": "https://raw.githubusercontent.com/ThanCoder/novelv3/refs/heads/main/README.md",
  // "reademe_url": "https://raw.githubusercontent.com/ThanCoder/novelv3/refs/heads/main/CHANGELOG.md",
