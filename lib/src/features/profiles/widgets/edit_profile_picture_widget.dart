import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';

class EditProfilePictureWidget extends StatelessWidget {
  const EditProfilePictureWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double profilePictureSize = 240;

    return FutureWrapper(
      future: getMyProfilePicture(),
      success: (snapshot) => ImagePickerWidget(
        diameter: profilePictureSize,
        initialImage: Image.memory(snapshot as Uint8List).image,
        shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
        isEditable: true,
        onChange: tryUploadProfilePicture,
      ),
      error: (error) => ErrorCardWidget(errorMessage: error.toString()),
      loading: const ShimmerWidget(
        child: DefaultProfilePicture(radius: profilePictureSize / 2),
      ),
    );
  }

  void tryUploadProfilePicture(File file) {
    try {
      uploadMyProfilePicture(file);
      Fluttertoast.showToast(
        msg: "Your profile picture was updated successfully",
      );
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: "Error updating your profile picture");
      log(e.toString());
    }
  }
}
