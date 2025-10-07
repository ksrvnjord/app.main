import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/commissie_edit_service.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/commissie_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class AlmanakCommissieEditPage extends ConsumerStatefulWidget {
  const AlmanakCommissieEditPage({
    super.key,
    required this.name,
    required this.year,
    required this.groupId,
  });

  final String name;
  final int year;
  final int groupId;

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
  String? initialDescription = '';

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

    final descriptionAsyncValue = ref.watch(
      commissieDescriptionProvider(
          Tuple3(widget.name, widget.year, widget.groupId)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Bewerk Commissie'),
      ),
      body: descriptionAsyncValue.when(
        data: (description) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              if (_galleryFile == null) ...[
                TextButton(
                  onPressed: () => unawaited(_showPicker(prevContext: context)),
                  child: const Text("Afbeelding toevoegen/aanpassen"),
                ),
                SizedBox(
                  height: 16.0,
                ),
              ] else ...[
                Image(
                  image: Image.file(
                    _galleryFile!,
                    semanticLabel: "Geselecteerde Afbeelding",
                  ).image,
                  semanticLabel: "Geselecteerde afbeelding",
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _galleryFile = null;
                    });
                  },
                  child: const Text("Afbeelding verwijderen"),
                ),
              ],
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
                  initialValue: description, // Set the initial value
                ),
              ),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stackTrace) =>
            const SizedBox.shrink(), // Display nothing on error
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

    formState.save(); // Save form state populates content

    try {
      // Update the commissie description
      await CommissieEditService.updateCommissieDescription(
        name: widget.name,
        content: content,
        year: widget.year,
        groupId: widget.groupId,
      );

      // Optional: Upload image if provided
      if (_galleryFile != null) {
        await CommissieEditService.uploadCommissieImage(
          name: widget.name,
          year: widget.year,
          image: _galleryFile!,
          groupId: widget.groupId,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Velden aangepast, afbeelding kan even duren voordat je het ziet.')),
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
