import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_widget/styled_widget.dart';

class VaarverbodWidget extends StatelessWidget {
  const VaarverbodWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<Response<Map<String, dynamic>>> vaarverbod =
        Dio().get('https://heimdall.njord.nl/api/v1/vaarverbod/');

    const double textSize = 16;
    const double innerPadding = 8;

    return FutureWrapper(
      future: vaarverbod,
      success: (data) {
        Map<String, dynamic> r = data.data!;
        final Color bgColor =
            r['status'] == true ? Colors.redAccent : Colors.lightBlue;
        final Color fgColor = r['status'] == true ? Colors.black : Colors.white;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(r['status'] == true
                    ? Icons.priority_high
                    : Icons.favorite_outlined)
                .iconColor(fgColor),
            Text(
              r['message'],
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: textSize,
                color: fgColor,
              ),
            ).padding(right: innerPadding),
          ],
        ).padding(all: innerPadding).card(
              color: bgColor,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            );
      },
      loading: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: <Widget>[
          const Icon(Icons.downloading, color: Colors.white)
              .padding(all: innerPadding),
        ].toRow().card(
              color: Colors.grey,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
      ),
      error: (error) {
        return const ErrorCardWidget(
          errorMessage:
              "Het is niet gelukt om het vaarverbod op te halen van de server. Heb je internet?",
        );
      },
    );
  }
}
