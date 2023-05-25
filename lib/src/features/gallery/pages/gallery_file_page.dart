import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_image_provider.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_storage.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:styled_widget/styled_widget.dart';

const double padding = 12;

class GalleryFilePage extends ConsumerWidget {
  final String path;

  const GalleryFilePage({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageVal = ref.watch(galleryImageProvider(path));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Foto"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
        actions: [
          imageVal.when(
            data: (image) => IconButton(
              onPressed: () => Share.shareXFiles(
                [
                  XFile.fromData(
                    image.bytes,
                    mimeType: "image/jpeg",
                    name: "image",
                  ),
                ],
                subject: "Foto",
              ),
              icon: const Icon(Icons.share),
            ),
            error: (err, _) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: imageVal.when(
        data: (image) => ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(padding)),
          child: InkWell(
            child: Image.memory(image.bytes, fit: BoxFit.cover),
            onTap: () => showImageViewer(
              context,
              image,
              swipeDismissible: true,
              doubleTapZoomable: true,
            ),
          ),
        ).padding(all: padding),
        error: (err, trace) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () => const LoadingWidget(),
      ),
    );
  }
}
