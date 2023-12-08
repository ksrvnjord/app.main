import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_topics_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  CreatePostPageState createState() {
    return CreatePostPageState();
  }
}

class CreatePostPageState extends ConsumerState<CreatePostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String selectedTopic = ""; // Default value.
  String title = '';
  String content = '';
  File? galleryFile;
  final picker = ImagePicker();

  bool postCreationInProgress = false;

  @override
  void initState() {
    super.initState();
    selectedTopic = ref.read(postTopicsProvider).elementAt(1);
  }

  @override
  Widget build(BuildContext context) {
    const int maxTitleLength = 40;
    const int maxContentLength = 1726;

    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nieuwe post'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              [
                DropdownButtonFormField<String>(
                  items: ref
                      .watch(postTopicsProvider)
                      .map((topic) => DropdownMenuItem<String>(
                            value: topic,
                            child: Text(topic),
                          ))
                      .toList(),
                  value: selectedTopic,
                  onChanged: (value) => selectedTopic = value ?? 'Wandelgangen',
                  decoration: const InputDecoration(
                    labelText: 'Categorie',
                    hintText: 'Selecteer een categorie',
                  ),
                  onSaved: (newValue) =>
                      selectedTopic = newValue ?? 'Wandelgangen',
                  validator: (value) =>
                      value == null ? 'Kies alsjeblieft een onderwerp.' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Titel',
                    hintText: 'Coach gezocht voor morgen om 7:00',
                  ),
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLength: maxTitleLength,
                  onSaved: (value) => title = value ?? '',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Je titel mist!' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Inhoud',
                    hintText: "Om 7:00 's ochtends heb je toch niks te doen",
                  ),
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  maxLength: maxContentLength,
                  onSaved: (value) => content = value ?? '',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Zonder inhoud kom je nergens.'
                      : null,
                ),
                if (galleryFile == null) ...[
                  TextButton(
                    onPressed: () => showPicker(context: context),
                    child: Text("Afbeelding toevoegen"),
                  ),
                ] else ...[
                  Image(image: Image.file(galleryFile!).image),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        galleryFile = null;
                      });
                      print("Galleryfile is $galleryFile");
                    },
                    child: Text("Afbeelding verwijderen"),
                  )
                ]
              ].toColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                separator: const SizedBox(height: 16),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: submitForm,
          icon: const Icon(LucideIcons.send),
          label: const Text('Verstuur'),
        ),
      ),
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }

  void submitForm() async {
    final formstate = _formKey.currentState;
    if (formstate != null && !formstate.validate()) {
      return;
    }
    formstate?.save();

    postCreationInProgress = true;

    await PostService.create(
        topic: selectedTopic,
        title: title,
        content: content,
        image: galleryFile);

    if (!mounted) {
      return;
    }
    // ignore: avoid-ignoring-return-values
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Niewe post aangemaakt!')),
    );

    // ignore: avoid-ignoring-return-values
    context.goNamed("Posts");
  }

  void showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
