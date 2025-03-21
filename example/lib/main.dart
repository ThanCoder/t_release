import 'package:flutter/material.dart';
import 'package:t_release/t_release_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: TReleaseServices.getChangeLogWidget()),
      ),
    );
  }
}
