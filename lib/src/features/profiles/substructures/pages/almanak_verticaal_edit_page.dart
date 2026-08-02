import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/group_edit_service.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/vertical_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class AlmanakVerticalEditPage extends ConsumerStatefulWidget {
  const AlmanakVerticalEditPage({
    super.key,
    required this.name,
    required this.id,
  });

  final String name;
  final int id;

  @override
  AlmanakVerticalEditPageState createState() {
    return AlmanakVerticalEditPageState();
  }
}

class AlmanakVerticalEditPageState
    extends ConsumerState<AlmanakVerticalEditPage> {
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
                  _getImage(ImageSource.gallery, context);
                  if (mounted) Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                // ignore: prefer-extracting-callbacks
                onTap: () {
                  // ignore: avoid-async-call-in-sync-function, prefer-async-await
                  _getImage(ImageSource.camera, context);
                  if (mounted) Navigator.of(context).pop();
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
      verticalDescriptionProvider(
          Tuple2(widget.name, widget.id.toString())),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Bewerk Verticaal'),
      ),
      body: descriptionAsyncValue.when(
        data: (description) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              if (_galleryFile == null) ...[
                TextButton(
                  onPressed: () => unawaited(_showPicker(prevContext: context)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image),
                      SizedBox(width: 8),
                      Text("Afbeelding toevoegen/aanpassen"),
                    ],
                  ),
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
      // Update the vertical description
      await GroupEditService.updateVerticalDescription(
        name: widget.name,
        content: content,
        verticaalId: widget.id.toString(),
      );

      // Upload image if provided
      if (_galleryFile != null) {
        await GroupEditService.uploadVerticalImage(
          name: widget.name,
          image: _galleryFile!,
          verticaalId: widget.id.toString(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Velden aangepast, afbeelding kan even duren voordat je het ziet.')),
      );

      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save content: $e')),
      );
    }
  }
}
