import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture_provider.dart';

// USED ONLY IN THE BEGINNING OF THE YEAR FOR UPLOADING ASPI PROFILE PICTURES
class UploadAspiProfilePictures extends StatelessWidget {
  const UploadAspiProfilePictures({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
      ),
      itemCount: 319,
      itemBuilder: (context, index) {
        final number = 25000 + index;
        return UploadGridCell(lidnummer: number);
      },
    );
  }
}

class UploadGridCell extends ConsumerStatefulWidget {
  const UploadGridCell({super.key, required this.lidnummer});
  final int lidnummer;

  @override
  ConsumerState<UploadGridCell> createState() => _UploadGridCellState();
}

class _UploadGridCellState extends ConsumerState<UploadGridCell> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> pickImage(
      BuildContext context, WidgetRef ref, String lidnummer) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Handle the selected image
      try {
        debugPrint("uploading...");
        final storageRef =
            _storage.ref('people/$lidnummer/profile_picture.png');
        final metadata = SettableMetadata(contentType: 'image/png');
        await storageRef.putData(await image.readAsBytes(), metadata);
        debugPrint("uploaded $lidnummer's profile picture");
        // return await storageRef.getDownloadURL();
      } catch (e) {
        debugPrint('Error uploading image: $e');
        return;
      }
      // final profileEditFormNotifier =
      //     ref.watch(profileEditFormNotifierProvider.notifier);
      // profileEditFormNotifier.setProfilePicture(image);
      // debugPrint("uploaded");
    }
  }

  @override
  Widget build(BuildContext context) {
    final lidnummer = widget.lidnummer.toString();
    final colorScheme = Theme.of(context).colorScheme;
    final profilePicture = ref.watch(profilePictureProvider(lidnummer));

    return GestureDetector(
      onTap: () => pickImage(context, ref, lidnummer),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          border: Border.all(color: colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Image(
                image: profilePicture.when(
                  data: (imageProvider) => imageProvider,
                  loading: () => const AssetImage(Images.loadingPicture),
                  error: (_, __) =>
                      const AssetImage(Images.placeholderProfilePicture),
                ),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Text(lidnummer),
              ),
            ),
            Center(
              child: Container(
                color: const Color.fromARGB(185, 0, 0, 0),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  lidnummer,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
