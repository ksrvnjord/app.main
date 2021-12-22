import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrv_njord_app/assets/images.dart';
import 'package:ksrv_njord_app/providers/heimdall.dart';
import 'package:ksrv_njord_app/widgets/app_icon_widget.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var api = ref.watch(heimdallProvider);
    var vaarverbod = api.get('api/v1/vaarverbod', null);

    return Scaffold(
      appBar: AppBar(
        title: const AppIconWidget(image: Images.appLogo),
      ),
      body: Center(
          child: Column(children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/announcements');
          },
          child: const Text('Aankondigingen'),
        ),
        FutureBuilder(
            future: vaarverbod,
            builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('not started');
                case ConnectionState.waiting:
                  return const Text('loading');
                default:
                  var vaarverbod = snapshot.data?.data;
                  return Text(vaarverbod.toString());
              }
            })
      ])),
    );
  }
}
