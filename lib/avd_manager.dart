import 'dart:io';
import 'package:path/path.dart' as p;

/// A class to manage and interact with Android Virtual Devices.
class AvdManager {
  late final String _sdkRoot;
  late final String _emulatorPath;
  late final String _avdManagerPath;

  /// Initializes the AvdManager, finding the necessary Android SDK paths.
  AvdManager() {
    // Attempt to find the Android SDK root from environment variables.
    final sdkRoot =
        Platform.environment['ANDROID_HOME'] ??
        Platform.environment['ANDROID_SDK_ROOT'];

    if (sdkRoot != null && Directory(sdkRoot).existsSync()) {
      _sdkRoot = sdkRoot;
    } else {
      // Fallback to the default Windows path if environment variables are not set.
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile == null) {
        throw Exception('Could not determine user profile directory.');
      }
      final defaultPath = p.join(
        userProfile,
        'AppData',
        'Local',
        'Android',
        'Sdk',
      );
      if (!Directory(defaultPath).existsSync()) {
        throw Exception(
          'Could not find Android SDK. Please set the ANDROID_HOME environment variable.',
        );
      }
      _sdkRoot = defaultPath;
    }

    _emulatorPath = p.join(_sdkRoot, 'emulator', 'emulator.exe');
    _avdManagerPath = p.join(
      _sdkRoot,
      'cmdline-tools',
      'latest',
      'bin',
      'avdmanager.bat',
    );
  }

  /// Lists all available AVDs.
  /// Returns a list of AVD names.
  Future<List<String>> listAvds() async {
    final processResult = await Process.run(
      _avdManagerPath,
      ['list', 'avd'],
      runInShell: true,
      stdoutEncoding:
          const SystemEncoding(), // Use system encoding for Windows paths
    );

    if (processResult.exitCode != 0) {
      throw Exception('Failed to list AVDs: ${processResult.stderr}');
    }

    final output = processResult.stdout.toString();
    final avds = <String>[];
    final regex = RegExp(r'Name:\s+(\S+)');
    for (final match in regex.allMatches(output)) {
      avds.add(match.group(1)!);
    }
    return avds;
  }

  /// Launches a specified AVD.
  Future<void> launchAvd(String avdName) async {
    if (!File(_emulatorPath).existsSync()) {
      throw Exception('Emulator executable not found at $_emulatorPath');
    }

    print('Launching AVD: $avdName.');

    // Start the process without waiting for it to complete.
    await Process.start(_emulatorPath, ['@$avdName'], runInShell: true);

    print('AVD has been launched.');
    exit(0);
  }
}
