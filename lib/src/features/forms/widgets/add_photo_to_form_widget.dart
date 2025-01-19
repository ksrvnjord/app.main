// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_image_provider.dart';

class AddPhotoToFormWidget extends ConsumerWidget {
  const AddPhotoToFormWidget({
    super.key,
    required this.docId,
  });

  final String docId;

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
    final asyncImageString = ref.watch(myFormAnswerImageProvider(docId));

    return Column(children: [
      const Divider(),
      const Text(
        'Foto Toevoegen',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 16),
      asyncImageString.when(
        data: (url) {
          return Row(children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.network(url),
            ),
            Spacer(),
            IconButton(
                icon: const Icon(Icons.edit, size: 30),
                onPressed: () async {
                  final imageBytes = await getImageFromUser();
                  if (imageBytes != null) {
                    bool succes = await changeImage(imageBytes, docId, ref);
                    if (succes) {
                      showSnackBar(context, succes, 'Veranderen succesvol!');
                    } else {
                      showSnackBar(context, succes,
                          'Veranderen mislukt, probeer het later opnieuw!');
                    }
                  }
                }),
            IconButton(
              icon: const Icon(Icons.delete, size: 30),
              onPressed: () async {
                bool succes = await deleteImage(docId, ref);
                if (succes) {
                  showSnackBar(context, succes, 'Verwijderen succesvol!');
                } else {
                  showSnackBar(context, succes,
                      'Verwijderen mislukt, probeer het later opnieuw!');
                }
              },
            ),
          ]);
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) {
          if (error is FirebaseException && error.code == 'object-not-found') {
            return IconButton(
              icon: const Icon(Icons.add_a_photo, size: 64),
              onPressed: () async {
                final imageBytes = await getImageFromUser();
                if (imageBytes != null) {
                  bool succes = await addImage(imageBytes, docId, ref);
                  if (succes) {
                    showSnackBar(context, succes, 'Upload succesvol!');
                  } else {
                    showSnackBar(context, succes,
                        'Upload mislukt, probeer het later opnieuw!');
                  }
                }
              },
            );
          } else {
            return Text('Error loading image: $error');
          }
        },
      )
    ]);
  }
}

//   Widget _buildImageWidget(
//       ImageState imageState, FormAnswerImageParams params) {
//     return Column(
//       children: [
//         const Divider(),
//         const Text(
//           'Foto Toevoegen',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         if (imageState.status == ImageStateStatus.loading)
//           const CircularProgressIndicator()
//         else if (imageState.status == ImageStateStatus.found)
//           Row(
//             children: [
//               SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: Image.network(imageState.url!),
//               ),
//               const SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: () async {
//                   final imageData = await ImagePicker()
//                       .pickImage(source: ImageSource.gallery);
//                   if (imageData != null) {
//                     final imageBytes = await imageData.readAsBytes();
//                     ref
//                         .read(formAnswerImageNotifierProvider(params).notifier)
//                         .changeImage(imageBytes);
//                   }
//                 },
//                 child: const Text('Foto veranderen'),
//               ),
//             ],
//           )
//         else
//           IconButton(
//             icon: const Icon(Icons.add_a_photo, size: 50),
//             onPressed: () async {
//               final imageData =
//                   await ImagePicker().pickImage(source: ImageSource.gallery);
//               if (imageData != null) {
//                 final imageBytes = await imageData.readAsBytes();
//                 ref
//                     .read(formAnswerImageNotifierProvider(params).notifier)
//                     .addImage(imageBytes);
//               }
//             },
//           ),
//       ],
//     );
//   }
// }
