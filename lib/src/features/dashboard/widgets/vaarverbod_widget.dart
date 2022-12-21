import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_widget/styled_widget.dart';

class VaarverbodWidget extends StatelessWidget {
  const VaarverbodWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vaarverbod = Dio().get('https://heimdall.njord.nl/api/v1/vaarverbod/');

    return FutureWrapper(
        future: vaarverbod,
        success: (data) {
            dynamic r = data.data;
            final Color bgColor =
                r['status'] ? Colors.redAccent : Colors.lightBlue;
            final Color fgColor = r['status'] ? Colors.black : Colors.white;

            return <Widget>[
              r['status']
                  ? Icon(Icons.priority_high, color: fgColor).padding(all: 10)
                  : Icon(Icons.favorite_outlined, color: fgColor)
                      .padding(all: 10),
              Text(r['message'],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: fgColor))
                  .padding(all: 10)
                  .expanded()
            ]
                .toRow()
                .card(color: bgColor, elevation: 0)
                .padding(all: 15, bottom: 0);
        },
        loading: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: <Widget>[
              const Icon(Icons.downloading, color: Colors.white)
                  .padding(all: 10),
              const Text('Laden...',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Colors.white))
                  .padding(all: 10)
                  .expanded()
            ]
                .toRow()
                .card(color: Colors.grey, elevation: 0)
                .padding(all: 15, bottom: 0)));
  }
}
