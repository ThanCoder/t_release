import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TReleaseServices {
  static Widget getChangeLogWidget() {
    return Markdown(data: getChangelog());
  }

  static Widget getReadmeWidget() {
    return Markdown(data: getReadme());
  }

  static Widget getLicenseWidget() {
    return Markdown(data: getLicense());
  }

  static String getChangelog() {
    final currentPath = Directory.current.path;
    final file = File('$currentPath/CHANGELOG.md');
    if (!file.existsSync()) return '';
    return file.readAsStringSync();
  }

  static String getReadme() {
    final currentPath = Directory.current.path;
    final file = File('$currentPath/README.md');
    if (!file.existsSync()) return '';
    return file.readAsStringSync();
  }

  static String getLicense() {
    final currentPath = Directory.current.path;
    final file = File('$currentPath/LICENSE');
    if (!file.existsSync()) return '';
    return file.readAsStringSync();
  }
}
