import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';

abstract class RemoteConfigRepository {
  String getRequiredMinimumVersion();
}

class RemoteConfigImplementation implements RemoteConfigRepository {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    // Set configuration
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    // These will be used before the values are fetched from Firebase Remote Config.
    await remoteConfig.setDefaults(const {
      'requiredMinimumVersion': '2.0.9',
    });

    // Fetch the values from Firebase Remote Config
    await remoteConfig.fetchAndActivate();

    // Optional: listen for and activate changes to the Firebase Remote Config values
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
    });
  }

  // Helper methods to simplify using the values in other parts of the code
  @override
  String getRequiredMinimumVersion() {
    final requiredVersion = _remoteConfig.getString('requiredMinimumVersion');

    if (requiredVersion.isEmpty) {
      return '2.0.9';
    }

    return requiredVersion;
  }
}
