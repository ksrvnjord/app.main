import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:styled_widget/styled_widget.dart';

class VaarverbodWidget extends StatelessWidget {
  const VaarverbodWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vaarverbod = Dio().get('https://heimdall.njord.nl/api/v1/vaarverbod/');

    return FutureWrapper(
        future: vaarverbod,
        success: (data) {
          if (data != null) {
            dynamic r = data.data;
            final Color color =
                r['status'] ? Colors.redAccent : Colors.greenAccent;

            return <Widget>[
              r['status']
                  ? Icon(Icons.warning_amber_rounded, color: color, size: 50)
                  : Icon(Icons.check, color: color, size: 50),
              Text(r['message']).padding(all: 10)
            ].toRow().card(color: color);
          }

          return Container();
        });
  }
}
