// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../api/commissie_edit_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlmanakCommissieEditPage extends ConsumerStatefulWidget {
  const AlmanakCommissieEditPage(
      {super.key, required this.name, required this.year});
  final String name;
  final int year;

  @override
  AlmanakCommissieEditPageState createState() {
    return AlmanakCommissieEditPageState();
  }
}

class AlmanakCommissieEditPageState
    extends ConsumerState<AlmanakCommissieEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _picker = ImagePicker();
  File? _galleryFile;
  String content = '';
  bool postCreationInProgress = false;
  String initialDescription = '';

  Future<void> _showPicker({required BuildContext prevContext}) {
    return showModalBottomSheet(
      context: prevContext,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                // ignore: prefer-extracting-callbacks
                onTap: () {
                  // ignore: avoid-async-call-in-sync-function, prefer-async-await
                  _getImage(ImageSource.gallery, context)
                      .then((value) => Navigator.of(context).pop());
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                // ignore: prefer-extracting-callbacks
                onTap: () {
                  // ignore: avoid-async-call-in-sync-function, prefer-async-await
                  _getImage(ImageSource.camera, context)
                      .then((value) => Navigator.of(context).pop());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _getImage(ImageSource img, BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: img);
    if (!mounted) return;
    setState(() {
      if (pickedFile == null) {
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected')),
        );
      } else {
        _galleryFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const int maxContentLength = 1726;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Commissie'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Commissie-Omschrijving',
              ),
              maxLines: null,
              maxLength: maxContentLength,
              onSaved: (value) => content = value ?? '',
              validator: (value) => value == null || value.isEmpty
                  ? 'Zonder omschrijving kom je nergens.'
                  : null,
              // FIXME: initial valiue is current description
              initialValue: initialDescription,
            ),
          ),
          if (_galleryFile == null) ...[
            TextButton(
              onPressed: () => unawaited(_showPicker(prevContext: context)),
              child: const Text("Afbeelding toevoegen"),
            ),
          ] else ...[
            Image(
              image: Image.file(
                // Can't be null because of null check above.
                // ignore: avoid-non-null-assertion
                _galleryFile!,
                semanticLabel: "Geselecteerde Afbeelding",
              ).image,
              semanticLabel: "Geselecteerde afbeelding",
            ),
            TextButton(
              // ignore: prefer-extracting-callbacks
              onPressed: () {
                setState(() {
                  _galleryFile = null;
                });
              },
              child: const Text("Afbeelding verwijderen"),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitEdit,
        child: const Icon(Icons.save),
      ),
    );
  }

  void submitEdit() async {
    final formState = _formKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    formState.save(); // Save form state (populates `content`).

    try {
      // Update the commissie description
      await CommissieEditService.updateCommissieDescription(
        name: widget.name,
        content: content,
      );

      // Optional: Upload image if provided
      if (_galleryFile != null) {
        await CommissieEditService.uploadCommissieImage(
          name: widget.name,
          year: widget.year,
          image: _galleryFile!,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content saved successfully')),
      );

      context.goNamed(
        "Commissie",
        pathParameters: {
          "name": widget.name,
        },
        queryParameters: {
          "year": widget.year.toString(),
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save content: $e')),
      );
    }
  }
}
