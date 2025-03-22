import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:t_release/constants.dart';
import 'package:t_release/models/t_release_model.dart';
import 'package:t_release/services/t_release_worker.dart';
import 'package:yaml/yaml.dart';

class TReleaseServices {
  static TReleaseServices instance = TReleaseServices._();
  TReleaseServices._();
  factory TReleaseServices() => instance;

  final _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 5),
      sendTimeout: Duration(seconds: 5),
    ),
  );

  Future<String> getChangeLog() async {
    final res = await getRelease();
    if (res == null) return '';
    final result = await _dio.get(res.changelogUrl);
    return result.data.toString();
  }

  Future<String> getLicense() async {
    final res = await getRelease();
    if (res == null) return '';
    final result = await _dio.get(res.licenseUrl);
    return result.data.toString();
  }

  Future<String> getReadme() async {
    final res = await getRelease();
    if (res == null) return '';
    final result = await _dio.get(res.readmeUrl);
    return result.data.toString();
  }

  Future<String> getDescription() async {
    final res = await getRelease();
    if (res == null) return '';
    return res.description;
  }
  ///
  /// is only work dev -> production not working!!!
  /// 
  Future<String> getVersion() async {
    final res = await getRelease();
    if (res == null) return '';
    return res.version;
  }

  Future<TReleaseModel?> getRelease() async {
    try {
      if (isDevReleaseFile) {
        final file = File('${Directory.current.path}/release.json');
        if (await file.exists()) {
          final res = jsonDecode(await file.readAsString());
          return TReleaseModel.fromMap(res);
        }
      } else {
        final file = File('${Directory.current.path}/pubspec.yaml');
        if (file.existsSync()) {
          final res = loadYaml(file.readAsStringSync());
          final pubspec = Map<String, dynamic>.from(res);
          String repository = pubspec['repository'] ?? '';
          String url = TReleaseWorker.instance.getRawUrl(
            repository,
            '${isDev ? 'example/' : ''}release.json',
          );
          final result = await _dio.get(url);
          return TReleaseModel.fromMap(jsonDecode(result.data.toString()));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
