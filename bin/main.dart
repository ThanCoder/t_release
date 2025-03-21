import 'package:t_release/t_release_worker.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart run t_release:main init');
    return;
  }
  for (var arg in args) {
    if (arg == 'init') {
      TReleaseWorker.instance.init();
      break;
    }
  }
  // print('command not found!');
}
