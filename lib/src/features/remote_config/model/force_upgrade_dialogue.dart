import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/pages/home_page.dart';
import 'package:ksrvnjord_main_app/src/features/remote_config/api/remote_config_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ksrvnjord_main_app/src/features/remote_config/model/mellotippet_package_info.dart';

import 'package:version/version.dart';

class ForceUpgradePage extends StatefulWidget {
  const ForceUpgradePage({super.key});

  @override
  State<ForceUpgradePage> createState() => _ForceUpgradeState();
}

class _ForceUpgradeState extends State<ForceUpgradePage> {
  // Get the necessary classes using get_it
  final packageInfo = GetIt.I.get<MellotippetPackageInfo>();
  final featureFlagRepository = GetIt.I.get<RemoteConfigRepository>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the current app version
      final appVersion = Version.parse(packageInfo.version);

      // Get the required min version from Firebase Remote Config
      final requiredMinVersion =
          Version.parse(featureFlagRepository.getRequiredMinimumVersion());

      // Compare the versions and display a dialog if the app version is lower than
      // the required or recommended version
      if (appVersion < requiredMinVersion) {
        _showUpdateVersionDialog(context);
      } else {
        // If the current version is higher than the required and recommended version,
        //navgiate to the next Page - in this case the LoginPage()
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  // Helper method to compare two semver versions.
  // int _getExtendedVersionNumber(String version) {
  //   List versionCells = version.split('.');
  //   versionCells = versionCells.map((i) => int.parse(i)).toList();
  //   return versionCells[0] _ 100000 + versionCells[1] _ 1000 + versionCells[2];
  // }

  Future<void> _showUpdateVersionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("New version available"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Please update to the latest version of the app."),
              ],
            ),
          ),
          actions: <Widget>[
            Container(),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                // _launchAppOrPlayStore()
              },
            ),
          ],
        );
      },
    );
  }
}
