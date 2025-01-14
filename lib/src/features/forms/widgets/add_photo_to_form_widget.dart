import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_image_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class AddPhotoToFormWidget extends ConsumerWidget {
  const AddPhotoToFormWidget({
    super.key,
    required this.docId,
  });
  final String docId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(currentUserProvider);

    return userAsyncValue.when(
      data: (user) {
        final params =
            FormAnswerImageParams(docId: docId, userId: user.identifierString);
        final imageUrlAsyncValue = ref.watch(formAnswerImageProvider(params));
        final imageNotifier =
            ref.watch(formAnswerImageNotifierProvider.notifier);
        final ImagePicker picker = ImagePicker();

        return Row(
          children: [
            imageUrlAsyncValue.when(
              data: (imageUrl) {
                if (imageUrl == null) {
                  return IconButton(
                    icon: const Icon(Icons.add_a_photo, size: 50),
                    onPressed: () async {
                      final imageData =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (imageData != null) {
                        final imageBytes = await imageData.readAsBytes();
                        await imageNotifier.addImage(
                            docId, user.identifierString, imageBytes);
                      }
                    },
                  );
                }
                return Row(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(imageUrl),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final imageData =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (imageData != null) {
                          final imageBytes = await imageData.readAsBytes();
                          await imageNotifier.changeImage(
                              docId, user.identifierString, imageBytes);
                        }
                      },
                      child: const Text('Foto veranderen'),
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => const Text(
                  'Kan geen connectie met de server maken. Probeer het later opnieuw.'),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => const Text('Error loading user'),
    );
  }
}
