import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateFormFillerImage extends StatefulWidget {
  const CreateFormFillerImage({
    super.key,
    required this.initialImage,
    required this.onChanged,
  });

  final XFile? initialImage;
  final void Function(XFile?) onChanged;

  @override
  State<CreateFormFillerImage> createState() => _CreateFormFillerImageState();
}

class _CreateFormFillerImageState extends State<CreateFormFillerImage> {
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.initialImage;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
      widget.onChanged(imageFile);
    }
  }

  void _removeImage() {
    setState(() {
      imageFile = null;
    });
    widget.onChanged(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text("Voeg eventueel afbeelding toe"),
        ),
      );
    }

    return FutureBuilder<Uint8List>(
      future: imageFile!.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _removeImage,
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text(
                    "Verwijder afbeelding",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.shortestSide - 150,
                  height: MediaQuery.of(context).size.shortestSide - 150,
                  child: Image.memory(snapshot.data!),
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('Fout bij het laden van de afbeelding.');
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.shortestSide - 150,
            width: MediaQuery.of(context).size.shortestSide - 150,
            child: const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          );
        }
      },
    );
  }
}
