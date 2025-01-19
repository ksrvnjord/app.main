import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_image_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AllFormsListTileImageLeadingWidget extends ConsumerWidget {
  const AllFormsListTileImageLeadingWidget({
    super.key,
    required this.formId,
    required this.userId,
  });

  final String formId;
  final String userId;

  void _downloadImage(String url) {
    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formAnswerImageFuture = ref.watch(formAnswerImageProvider(
      FormAnswerImageParams(docId: formId, userId: userId),
    ).future);

    return FutureBuilder<String>(
      future: formAnswerImageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.image_not_supported);
        } else if (snapshot.hasData && snapshot.data != null) {
          return GestureDetector(
            onTap: () => _downloadImage(snapshot.data!),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Image.network(snapshot.data!),
            ),
          );
        } else {
          return const Icon(Icons.image_not_supported);
        }
      },
    );
  }
}
