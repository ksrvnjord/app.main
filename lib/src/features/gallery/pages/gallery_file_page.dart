import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_storage.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';
import 'package:styled_widget/styled_widget.dart';

const double padding = 12;

class GalleryFilePage extends ConsumerWidget {
  final String? path;

  const GalleryFilePage({
    Key? key,
    this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (path == null) {
      return const LoadingWidget();
    }

    final fileURL = ref.watch(galleryFile(path!));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Foto"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: fileURL.when(
        data: (url) => ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(padding)),
          child: Image.network(url, fit: BoxFit.cover),
        ).padding(all: padding),
        error: (err, trace) => Text(err.toString()),
        loading: () => const LoadingWidget(),
      ),
    );
  }
}
