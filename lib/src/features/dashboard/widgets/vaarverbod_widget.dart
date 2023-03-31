import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/vaarverbod_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/model/vaarverbod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_widget/styled_widget.dart';

class VaarverbodWidget extends ConsumerWidget {
  const VaarverbodWidget({Key? key}) : super(key: key);

  Widget showVaarverbod(
    Vaarverbod data,
    double innerPadding,
  ) {
    bool status = data.status;
    String message = data.message;
    final Color bgColor = status ? Colors.redAccent : Colors.lightBlue;
    final Color fgColor = status ? Colors.black : Colors.white;
    const double textSize = 16;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(status ? Icons.priority_high : Icons.favorite_outlined)
            .iconColor(fgColor),
        Text(
          message,
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaarverbodRef = ref.watch(vaarverbodProvider);

    const double innerPadding = 8;

    return vaarverbodRef.when(
      data: (data) => showVaarverbod(data, innerPadding),
      loading: () => Shimmer.fromColors(
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
      error: (_, __) => const ErrorCardWidget(
        errorMessage:
            "Het is niet gelukt om het vaarverbod op te halen van de server. Heb je internet?",
      ),
    );
  }
}
