import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';

class VaarverbodCardWidget extends StatelessWidget {
  const VaarverbodCardWidget(this.status, this.message, {Key? key})
      : super(key: key);

  final bool status;
  final String message;

  @override
  Widget build(BuildContext context) {
    final Color color = status ? Colors.red.shade800 : Colors.green.shade800;

    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: color, width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            leading: status
                ? Icon(Icons.warning_amber_rounded, color: color, size: 50)
                : Icon(Icons.check, color: color, size: 50),
            title: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                    status ? 'Er is een vaarverbod' : 'Er is geen vaarverbod',
                    style: TextStyle(color: color, fontSize: 22))),
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
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
            future: vaarverbod,
            builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('not started');
                case ConnectionState.waiting:
                  return const Loading();
                default:
                  var vaarverbod = snapshot.data?.data;
                  return VaarverbodCardWidget(
                      vaarverbod['status'], vaarverbod['message']);
              }
            }));
  }
}
