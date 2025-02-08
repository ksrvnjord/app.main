import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/profile_edit_form_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/custom_image_picker_widget.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePictureWidget extends ConsumerStatefulWidget {
  const EditProfilePictureWidget({super.key});

  @override
  createState() => _EditProfilePictureWidgetState();
}

class _EditProfilePictureWidgetState
    extends ConsumerState<EditProfilePictureWidget> {
  @override
  Widget build(BuildContext context) {
    const double profilePictureSize = 240;
    final currentUser = ref.watch(currentFirestoreUserProvider);

    final myProfilePicture =
        ref.watch(profilePictureProvider(currentUser?.identifier ?? ""));

    return myProfilePicture.when(
      data: (image) => CustomImagePickerWidget(
        diameter: profilePictureSize,
        isEditable: true,
        shouldCrop: true,
        onChange: (XFile? xfile) {
          ref
              .read(profileEditFormNotifierProvider.notifier)
              .setProfilePicture(xfile);
        },
        shape: CustomImagePickerWidgetShape.circle,
        iconSizeRatio: 0.2,
        initialImageProvider: image,
      ),
      error: (error, stk) => CustomImagePickerWidget(
        diameter: profilePictureSize,
        isEditable: true,
        shouldCrop: true,
        onChange: (XFile? xfile) {
          ref
              .read(profileEditFormNotifierProvider.notifier)
              .setProfilePicture(xfile);
        },
        shape: CustomImagePickerWidgetShape.circle,
        iconSizeRatio: 0.2,
        initialImageProvider: AssetImage(Images.placeholderProfilePicture),
      ),
      loading: () => const ShimmerWidget(
        child: DefaultProfilePicture(
          radius: profilePictureSize / 2,
        ), // Profile picture size is the diameter.
      ),
    );
  }
}
