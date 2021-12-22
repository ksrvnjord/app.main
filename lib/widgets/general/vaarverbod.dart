import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrv_njord_app/providers/heimdall.dart';

class VaarverbodCardWidget extends StatelessWidget {
  const VaarverbodCardWidget(this.status, this.message, {Key? key})
      : super(key: key);

  final bool status;
  final String message;

  @override
  Widget build(BuildContext context) {
    final Color color = status ? Colors.amber.shade800 : Colors.green.shade800;

    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: color, width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
            leading: status
                ? Icon(Icons.warning_amber_rounded, color: Colors.amber[900])
                : Icon(Icons.check, color: color),
            title: Text(status ? 'Geen vaarverbod!' : 'Vaarverbod!'),
            subtitle: Text(message)));
  }
}

class VaarverbodWidget extends HookConsumerWidget {
  const VaarverbodWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var api = ref.watch(heimdallProvider);
    var vaarverbod = api.get('api/v1/vaarverbod', null);

    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: FutureBuilder(
            future: vaarverbod,
            builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('not started');
                case ConnectionState.waiting:
                  return const Text('loading');
                default:
                  var vaarverbod = snapshot.data?.data;
                  return VaarverbodCardWidget(
                      vaarverbod['status'], vaarverbod['message']);
              }
            }));
  }
}
