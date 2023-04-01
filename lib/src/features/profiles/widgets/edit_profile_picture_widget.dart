import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';

class EditProfilePictureWidget extends StatefulWidget {
  const EditProfilePictureWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final void Function(File) onChanged;

  @override
  createState() => _EditProfilePictureWidgetState();
}

class _EditProfilePictureWidgetState extends State<EditProfilePictureWidget> {
  ImageProvider? imageProvider;

  void onChange(File file) {
    setState(() {
      imageProvider = Image.file(file).image;
    });
    widget.onChanged.call(file);
  }

  @override
  Widget build(BuildContext context) {
    const double profilePictureSize = 240;

    return FutureWrapper(
      future: CachedProfilePicture.getMyProfilePicture(),
      success: (image) => ImagePickerWidget(
        diameter: profilePictureSize,
        initialImage: image,
        shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
        isEditable: true,
        shouldCrop: true,
        onChange: widget.onChanged,
      ),
      error: (error) => ImagePickerWidget(
        // error means that the user has no profle picture set
        diameter: profilePictureSize,
        shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
        initialImage: Image.asset(Images.placeholderProfilePicture).image,
        isEditable: true,
        shouldCrop: true,
        onChange: widget.onChanged,
      ),
      loading: const ShimmerWidget(
        child: DefaultProfilePicture(
          radius: profilePictureSize / 2,
        ), // profilepicture size is the diameter
      ),
    );
  }
}
