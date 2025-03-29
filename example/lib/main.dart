import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:t_release/services/t_release_services.dart';

void main() async {
  await TReleaseServices.instance.initial('release.json');
  // await TReleaseServices.instance.initial(
  //   'https://raw.githubusercontent.com/ThanCoder/t_release/refs/heads/main/example/release.json',
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // TReleaseServices.instance.initial(source);

    // final isLatest = await TReleaseVersionServices.instance.isLatestVersion(
    //   '1.0.1',
    // );

    // print(isLatest);
    // final version = await TReleaseVersionServices.instance.getLatestVersion(
    //   '1.0.1',
    // );
    // print(version);

    // final versionList = await TReleaseVersionServices.instance.getVersionList();
    // print(versionList);

    // //release
    // final changeLogText = await TReleaseServices.instance.getChangeLog();
    // print(changeLogText);
    // final descriptionText = await TReleaseServices.instance.getDescription();
    // print(descriptionText);
    // final licenseText = await TReleaseServices.instance.getLicense();
    // print(licenseText);
    // final readmeText = await TReleaseServices.instance.getReadme();
    // print(readmeText);
    // final versionText = await TReleaseServices.instance.getVersion();
    // print(versionText);
    // TReleaseModel? release = await TReleaseServices.instance.getRelease();
    // print(release);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: FutureBuilder(
          future: TReleaseServices.instance.getDescription(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Loading...'));
            }
            if (snapshot.hasData) {
              return Markdown(data: snapshot.data.toString());
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
