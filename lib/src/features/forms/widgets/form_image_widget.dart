// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_image_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';

class FormImageWidget extends ConsumerWidget {
  const FormImageWidget({
    super.key,
    required this.docId,
    required this.questionName,
    required this.formIsOpen,
    required this.onChanged,
  });

  final String docId;
  final String questionName;
  final bool formIsOpen;
  final void Function(String?) onChanged;

  showSnackBar(BuildContext context, bool succes, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: succes ? Colors.green : Colors.red,
      ),
    );
  }

  Future<Uint8List?> getImageFromUser() async {
    final imageData =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageData != null) {
      return await imageData.readAsBytes();
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsyncValue = ref.watch(currentUserProvider);

    return currentUserAsyncValue.when(
      data: (user) {
        final asyncImageString =
            ref.watch(formAnswerImageProvider(FormAnswerImageParams(
          docId: docId,
          userId: user.identifierString,
          questionName: questionName,
        )));

        return Container(
          width:
              double.infinity, // Ensures the widget takes all available width
          padding:
              const EdgeInsets.all(8.0), // Optional padding for better styling
          child: asyncImageString.when(
            data: (url) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: Image.network(url),
                  ),
                  const Spacer(), // Pushes the buttons to the end
                  IconButton(
                    icon: const Icon(Icons.edit, size: 25),
                    onPressed: () async {
                      final imageBytes = await getImageFromUser();
                      if (imageBytes != null) {
                        bool success = await changeImage(
                            imageBytes, docId, questionName, ref);
                        if (success) {
                          onChanged(imageBytes.hashCode.toString());
                          showSnackBar(
                              context, success, 'Veranderen succesvol!');
                        } else {
                          showSnackBar(context, success,
                              'Veranderen mislukt, probeer het later opnieuw!');
                        }
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 25),
                    onPressed: () async {
                      bool success =
                          await deleteImage(docId, questionName, ref);
                      if (success) {
                        onChanged(null);
                        showSnackBar(
                            context, success, 'Verwijderen succesvol!');
                      } else {
                        showSnackBar(context, success,
                            'Verwijderen mislukt, probeer het later opnieuw!');
                      }
                    },
                  ),
                ],
              );
            },
            loading: () => const CircularProgressIndicator.adaptive(),
            error: (error, stackTrace) {
              if (error is FirebaseException &&
                  error.code == 'object-not-found') {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_a_photo, size: 40),
                      onPressed: () async {
                        final imageBytes = await getImageFromUser();
                        if (imageBytes != null) {
                          bool success = await addImage(
                              imageBytes, docId, questionName, ref);
                          if (success) {
                            onChanged(imageBytes.hashCode.toString());
                            showSnackBar(context, success, 'Upload succesvol!');
                          } else {
                            showSnackBar(context, success,
                                'Upload mislukt, probeer het later opnieuw!');
                          }
                        }
                      },
                    ),
                  ],
                );
              } else {
                return ErrorTextWidget(
                    errorMessage: 'Error loading image: ${error.toString()}');
              }
            },
          ),
        );
      },
      loading: () => const CircularProgressIndicator.adaptive(),
      error: (error, stackTrace) => ErrorTextWidget(
          errorMessage: 'Error Loading user:${error.toString()}'),
    );
  }
}
