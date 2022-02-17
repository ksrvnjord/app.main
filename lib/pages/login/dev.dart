import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/providers/authentication.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/input.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectDevelopmentServer extends StatefulHookConsumerWidget {
  static const routename = '/login/dev';
  const SelectDevelopmentServer({Key? key}) : super(key: key);

  @override
  _SelectDevelopmentServerState createState() =>
      _SelectDevelopmentServerState();
}

class _SelectDevelopmentServerState
    extends ConsumerState<SelectDevelopmentServer> {
  final GlobalKey fieldKey = GlobalKey(debugLabel: 'DevServer');
  final TextEditingController _baseURL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Input(label: 'Server URL', controller: _baseURL),
      Row(children: [
        Expanded(
          child: ElevatedButton(
              onPressed: () {
                ref.read(authenticationProvider).updateBaseURL(_baseURL.text);
                ref.read(heimdallProvider).updateBaseURL(_baseURL.text);
              },
              child: const Text('Use')),
        )
      ])
    ]);
  }
}
