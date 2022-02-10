import 'package:flutter/material.dart';
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
  final GlobalKey qrKey = GlobalKey(debugLabel: 'DevServer');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const <Widget>[Card(child: Text('Placeholder'))],
      ),
    );
  }
}
