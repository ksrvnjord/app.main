import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/documents/api/document_uint8_provider.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/pages/gallery_file_page.dart';

class DocumentsFilePage extends ConsumerWidget {
  final String path;

  const DocumentsFilePage({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (path.endsWith('pdf')) {
      final pdfData = ref.watch(documentUint8Provider(path));

      return Scaffold(
        appBar: AppBar(
          title: const Text("PDF File"),
        ),
        body: pdfData.when(
          data: (pdf) => PDFView(
            pdfData: pdf,
          ),
          error: (err, _) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
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
