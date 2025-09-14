import 'dart:io';
import 'package:avd_laucher/avd_manager.dart';

void main() async {
  try {
    final avdManager = AvdManager();
    final avds = await avdManager.listAvds();

    if (avds.isEmpty) {
      print('No Android Virtual Devices found.');
      return;
    }

    print('Choose an AVD to launch (0 to exit):');
    for (var i = 0; i < avds.length; i++) {
      print('[${i + 1}] - ${avds[i]}');
    }

    while (true) {
      stdout.write('> ');
      int? choice;
      try {
        stdin.echoMode = false;
        stdin.lineMode = false;

        final input = stdin.readByteSync();

        print(String.fromCharCode(input));
        choice = int.tryParse(String.fromCharCode(input));
      } finally {
        stdin.lineMode = true;
        stdin.echoMode = true;
      }

      if (choice == 0) {
        exit(0);
      }

      if (choice != null && choice > 0 && choice <= avds.length) {
        final selectedAvd = avds[choice - 1];
        await avdManager.launchAvd(selectedAvd);
        break;
      } else {
        print('Invalid selection. Please enter a valid number.');
      }
    }
  } catch (e) {
    stderr.writeln('An error occurred: $e');
    exit(1);
  }
}
