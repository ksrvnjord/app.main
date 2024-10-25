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
    this.initialImageXFile,
    this.initialImageProvider,
  });

  final double diameter;
  final bool isEditable;
  final bool shouldCrop;
  final Function(XFile?) onChange;
  final CustomImagePickerWidgetShape shape;
  final XFile? initialImageXFile;
  final ImageProvider? initialImageProvider;

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
    return GestureDetector(
      onTap: widget.isEditable ? _pickImage : null,
      child: Container(
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
          image: DecorationImage(
            image: _imageFile != null
                ? (kIsWeb
                    ? NetworkImage(_imageFile!.path)
                    : FileImage(File(_imageFile!.path))) as ImageProvider
                : (widget.initialImageProvider ??
                    AssetImage('assets/placeholder.png')),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: Colors.grey),
        ),
        child: _imageFile == null && _imageProvider == null
            ? Icon(
                Icons.add_a_photo,
                color: Colors.grey,
              )
            : null,
      ),
    );
  }
}
