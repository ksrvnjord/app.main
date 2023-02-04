import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';

class EditProfilePictureWidget extends StatelessWidget {
  const EditProfilePictureWidget({
    Key? key,
    required this.initialImage,
  }) : super(key: key);

  final Image initialImage;

  @override
  Widget build(BuildContext context) {
    return ImagePickerWidget(
      diameter: 300,
      initialImage: initialImage.image,
      shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
      isEditable: true,
      onChange: (File file) async {
        try {
          await uploadMyProfilePicture(file);
          Fluttertoast.showToast(
            msg: "Your profile picture was updated successfully",
          );
        } on FirebaseException catch (e) {
          Fluttertoast.showToast(msg: "Error updating your profile picture");
          log(e.toString());
        }
      },
    );
  }
}
