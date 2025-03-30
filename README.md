## TRelease dart package

- app version control system
- github is hosting
- release.json
- auto add CHANGELOG.md

## Auto Release File Command
- auto create release.json file
```bash
dart run t_release:main init 
```

## flutter main init
```Dart
void main() async {
  await TReleaseServices.instance.initial('release.json');
  // await TReleaseServices.instance.initial(
  //   'https://raw.githubusercontent.com/ThanCoder/t_release/refs/heads/main/example/release.json',
  // );
  runApp(const MyApp());
}
```

## Custom pubspec.yaml
```yaml
t_release:
  platfoms: android,linux 
  cover_path: "assets/cover.webp" 
  changelog_url: "changelog url"
  readme_url: "readme url" 
  cover_url: "" #is will override -> cover_path:[path]
```

## Version

```Dart
final isLatest = await TReleaseVersionServices.instance.isLatestVersion('1.0.1');

print(isLatest);
final version = await TReleaseVersionServices.instance.getLatestVersion('1.0.1');
print(version);

final versionList = await TReleaseVersionServices.instance.getVersionList();
print(versionList);

```

## Release
```Dart
final changeLogText = await TReleaseServices.instance.getChangeLog();
print(changeLogText);

final descriptionText = await TReleaseServices.instance.getDescription();
print(descriptionText);

final licenseText = await TReleaseServices.instance.getLicense();
print(licenseText);

final readmeText = await TReleaseServices.instance.getReadme();
print(readmeText);

final versionText = await TReleaseServices.instance.getVersion();
print(versionText);

TReleaseModel? release = await TReleaseServices.instance.getRelease();
print(release);
```

## Generated Release.json
```Json
{
 "description": "Demonstrates how to use the t_release plugin.",
 "version": "1.1.4",
 "repository": "https://github.com/ThanCoder/t_release",
 "changelog_url": "https://raw.githubusercontent.com/ThanCoder/t_release/refs/heads/main/CHANGELOG.md",
 "readme_url": "https://raw.githubusercontent.com/ThanCoder/t_release/refs/heads/main/README.md",
 "cover_url": "https://raw.githubusercontent.com/ThanCoder/t_release/refs/heads/main/assets/cover.webp",
 "license_url": "https://raw.githubusercontent.com/ThanCoder/t_release/refs/heads/main/LICENSE",
 "versions": [
  {
   "version": "1.1.4",
   "platform": "linux",
   "url": "",
   "description": "",
   "date": 1742602599887
  },
  {
   "version": "1.1.4",
   "platform": "android",
   "url": "",
   "description": "",
   "date": 1742602599887
  }
 ]
}
```