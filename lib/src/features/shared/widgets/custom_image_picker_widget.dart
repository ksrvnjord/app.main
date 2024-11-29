// ignore_for_file: library_private_types_in_public_api, prefer-single-declaration-per-file, arguments-ordering

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum CustomImagePickerWidgetShape { circle, square }

class CustomImagePickerWidget extends StatefulWidget {
  const CustomImagePickerWidget({
    super.key,
    required this.diameter,
    required this.isEditable,
    required this.shouldCrop,
    required this.onChange,
    required this.shape,
    required this.iconSizeRatio,
    this.initialImageXFile,
    this.initialImageProvider,
    this.pickImageIconShouldRemainVisibleOnSelect = true,
  });

  final double diameter;
  final bool isEditable;
  final bool shouldCrop;
  final Function(XFile?) onChange;
  final CustomImagePickerWidgetShape shape;
  final double iconSizeRatio;
  final XFile? initialImageXFile;
  final ImageProvider? initialImageProvider;
  final bool pickImageIconShouldRemainVisibleOnSelect;

  @override
  _CustomImagePickerWidgetState createState() =>
      _CustomImagePickerWidgetState();
}

class _CustomImagePickerWidgetState extends State<CustomImagePickerWidget> {
  XFile? _imageFile;
  ImageProvider? _imageProvider;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialImageXFile != null) {
      _imageFile = widget.initialImageXFile;
    } else if (widget.initialImageProvider != null) {
      _imageProvider = widget.initialImageProvider;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        _imageProvider =
            null; // Clear the ImageProvider if a new image is picked
      });
      widget.onChange(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowIcon = (_imageFile == null && _imageProvider == null) ||
        widget.pickImageIconShouldRemainVisibleOnSelect;

    return GestureDetector(
      onTap: widget.isEditable ? _pickImage : null,
      child: SizedBox(
        width: widget.diameter,
        height: widget.diameter,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Container(
              width: widget.diameter,
              height: widget.diameter,
              constraints: BoxConstraints(
                maxWidth: widget.diameter,
                maxHeight: widget.diameter,
              ),
              decoration: BoxDecoration(
                shape: widget.shape == CustomImagePickerWidgetShape.circle
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                image: (_imageFile != null || _imageProvider != null)
                    ? DecorationImage(
                        image: _imageFile != null
                            ? (kIsWeb
                                    ? NetworkImage(_imageFile!.path)
                                    : FileImage(File(_imageFile!.path)))
                                as ImageProvider
                            : _imageProvider!,
                        fit: BoxFit.cover,
                      )
                    : null,
                border: Border.all(color: Colors.grey),
              ),
            ),
            if (shouldShowIcon)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.6)
                        : Colors.white
                            .withOpacity(0.6), // Background adapts to theme
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors
                          .grey.shade400, // Lighter border color for subtlety
                      width: 1.5,
                    ),
                  ),
                  padding:
                      EdgeInsets.all(3.0), // Adjust padding for better sizing
                  child: Icon(
                    Icons
                        .add_photo_alternate, // Circular arrows icon for "change"
                    color: Colors.grey.shade700, // Subtle color
                    size: widget.diameter *
                        widget.iconSizeRatio, // Slightly smaller icon
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
