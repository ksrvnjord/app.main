import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';

class BeleidPage extends StatelessWidget {
  const BeleidPage({Key? key}) : super(key: key);

  Future<Uint8List> loadAsset(String path, BuildContext context) async {
    return (await DefaultAssetBundle.of(context).load(path))
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beleid'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
      ),
      body: FutureWrapper(
        future: loadAsset("assets/documents/beleid-149e-bestuur.pdf", context),
        success: (data) {
          return PDFView(
            pdfData: data,
            onError: (error) => ErrorCardWidget(errorMessage: error.toString()),
            onPageError: (page, error) =>
                ErrorCardWidget(errorMessage: error.toString()),
          );
        },
        error: (error) => ErrorCardWidget(errorMessage: error.toString()),
      ),
    );
  }
}
