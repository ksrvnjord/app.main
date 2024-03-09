import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/documents/api/document_uint8_provider.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/pages/gallery_file_page.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class DocumentsFilePage extends ConsumerWidget {
  final String path;

  const DocumentsFilePage({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPDF = path.endsWith('pdf');
    final isImage = path.endsWith('jpg') || path.endsWith('jpeg');
    // Extract the filename extension.
    final fileNameWithExtension = path.split('/').last;
    final fileExtension = fileNameWithExtension.split('.').last;

    if (isPDF) {
      final pdfData = ref.watch(documentUint8Provider(path));
      final filename = fileNameWithExtension.characters
          .getRange(0, fileNameWithExtension.lastIndexOf("."));

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
    } else if (isImage) {
      return GalleryFilePage(path: path);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Foutmelding")),
      body: Center(
        child: ErrorCardWidget(
          errorMessage: "Bestandstype $fileExtension niet ondersteund",
        ),
      ),
    );
  }
}
