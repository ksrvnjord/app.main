import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/zwanehals_unit8_provider.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/pages/gallery_file_page.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class ZwanehalzenFilePage extends ConsumerWidget {
  final String path;

  const ZwanehalzenFilePage({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (path.endsWith('pdf')) {
      final pdfData = ref.watch(zwanehalsUint8Provider(path));
      final fileNameFull = path.split('/').last;
      final filename =
          fileNameFull.characters.getRange(0, fileNameFull.lastIndexOf("."));

      return Scaffold(
        appBar: AppBar(
          title: Text(filename.string),
        ),
        body: pdfData.when(
          data: (pdf) => PDFView(
            pdfData: pdf,
          ),
          error: (err, _) => ErrorCardWidget(errorMessage: err.toString()),
          loading: () => const CircularProgressIndicator.adaptive().center(),
        ),
      );
    }

    if (path.endsWith('jpg') || path.endsWith('jpeg')) {
      return GalleryFilePage(path: path);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("File not supported."),
      ),
    );
  }
}
