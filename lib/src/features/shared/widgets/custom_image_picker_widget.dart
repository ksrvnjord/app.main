import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum CustomImagePickerWidgetShape { circle, square }

class CustomImagePickerWidget extends StatefulWidget {
  const CustomImagePickerWidget({
    super.key,
    required this.diameter,
    required this.isEditable,
    required this.shouldCrop,
    required this.onChange,
    required this.shape,
    this.initialImage,
  });

  final double diameter;
  final bool isEditable;
  final bool shouldCrop;
  final Function(XFile?) onChange;
  final CustomImagePickerWidgetShape shape;
  final XFile? initialImage;

  @override
  _CustomImagePickerWidgetState createState() =>
      _CustomImagePickerWidgetState();
}

class _CustomImagePickerWidgetState extends State<CustomImagePickerWidget> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imageFile = widget.initialImage;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
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
        decoration: BoxDecoration(
          shape: widget.shape == CustomImagePickerWidgetShape.circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          image: _imageFile != null
              ? DecorationImage(
                  image: NetworkImage(_imageFile!.path),
                  fit: BoxFit.cover,
                )
              : null,
          border: Border.all(color: Colors.grey),
        ),
        child: _imageFile == null
            ? Icon(
                Icons.add_a_photo,
                size: widget.diameter / 2,
                color: Colors.grey,
              )
            : null,
      ),
    );
  }
}
