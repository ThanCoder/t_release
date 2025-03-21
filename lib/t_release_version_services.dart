import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:t_release/t_release_worker.dart';
import 'package:yaml/yaml.dart';

class TReleaseVersionServices {
  static TReleaseVersionServices instance = TReleaseVersionServices._();
  TReleaseVersionServices._();
  factory TReleaseVersionServices() => instance;

  final bool _isDevFile = true;

  Future<void> getRelease() async {}

  Future<Map<String, dynamic>> getReleaseSource() async {
    try {
      if (_isDevFile) {
        final file = File('${Directory.current.path}/release.json');
        if (await file.exists()) {
          final res = jsonDecode(await file.readAsString());
          return Map<String, dynamic>.from(res);
        }
      } else {
        //online url
        final dio = Dio(
          BaseOptions(
            connectTimeout: Duration(milliseconds: 5),
            sendTimeout: Duration(milliseconds: 5),
          ),
        );

        final file = File('${Directory.current.path}/pubspec.yaml');
        if (file.existsSync()) {
          final res = loadYaml(file.readAsStringSync());
          final pubspec = Map<String, dynamic>.from(res);
          String repository = pubspec['repository'] ?? '';
          final result = await dio.get(
            TReleaseWorker.instance.getRawUrl(repository, 'release.json'),
          );
          return Map<String, dynamic>.from(jsonDecode(result.data.toString()));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return {};
  }
}
