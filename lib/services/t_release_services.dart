import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:t_release/models/t_release_model.dart';

class TReleaseServices {
  static TReleaseServices instance = TReleaseServices._();
  TReleaseServices._();
  factory TReleaseServices() => instance;

  String? _source;

  ///
  /// source -> [release.json] path or release.json url
  ///
  /// example https://raw.githubusercontent.com/ThanCoder/t_release/refs/heads/main/release.json
  ///
  Future<void> initial(String source) async {
    _source = source;
  }

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
    if (_source == null) {
      throw Exception('you should called: `TReleaseServices.instance.initial`');
    }
    if (_source!.isEmpty) {
      throw Exception(
        'you should called: `TReleaseServices.instance.initial(`source is not empty`)`',
      );
    }
    try {
      if (_source!.startsWith('http')) {
        // String url = TReleaseWorker.instance.getRawUrl(
        //   _source!,
        //   '${isDev ? 'example/' : ''}release.json',
        // );
        final result = await _dio.get(_source!);
        return TReleaseModel.fromMap(jsonDecode(result.data.toString()));
      } else {
        final file = File(_source!);
        if (await file.exists()) {
          final res = jsonDecode(await file.readAsString());
          return TReleaseModel.fromMap(res);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
