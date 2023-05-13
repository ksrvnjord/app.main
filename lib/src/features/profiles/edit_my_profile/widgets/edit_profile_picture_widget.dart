import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/profile_edit_form_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/user_id.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';

class EditProfilePictureWidget extends ConsumerStatefulWidget {
  const EditProfilePictureWidget({
    Key? key,
  }) : super(key: key);

  @override
  createState() => _EditProfilePictureWidgetState();
}

class _EditProfilePictureWidgetState
    extends ConsumerState<EditProfilePictureWidget> {
  @override
  Widget build(BuildContext context) {
    const double profilePictureSize = 240;

    final myProfilePicture =
        ref.watch(profilePictureProvider(getCurrentUserId()));

    return myProfilePicture.when(
      data: (image) => ImagePickerWidget(
        diameter: profilePictureSize,
        initialImage: image,
        shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
        isEditable: true,
        shouldCrop: true,
        onChange: ref
            .read(profileEditFormNotifierProvider.notifier)
            .setProfilePicture, // update form,
      ),
      error: (error, stk) => ImagePickerWidget(
        // error means that the user has no profle picture set
        diameter: profilePictureSize,
        shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
        initialImage: Image.asset(Images.placeholderProfilePicture).image,
        isEditable: true,
        shouldCrop: true,
        onChange: ref
            .read(profileEditFormNotifierProvider.notifier)
            .setProfilePicture,
      ),
      loading: () => const ShimmerWidget(
        child: DefaultProfilePicture(
          radius: profilePictureSize / 2,
        ), // profilepicture size is the diameter
      ),
    );
  }
}
