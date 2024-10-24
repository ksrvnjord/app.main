// ignore_for_file: prefer-single-declaration-per-file, prefer-extracting-function-callbacks

import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:ksrvnjord_main_app/src/features/posts/api/post_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_topics_provider.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  CreatePostPageState createState() {
    return CreatePostPageState();
  }
}

class CreatePostPageState extends ConsumerState<CreatePostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _picker = ImagePicker();

  String selectedTopic = ""; // Default value.
  String title = '';
  String content = '';
  File? _galleryFile;
  bool postCreationInProgress = false;

  @override
  void initState() {
    super.initState();
    selectedTopic = ref.read(postTopicsProvider).elementAt(1);
  }

  Future<void> _showPicker({required BuildContext prevContext}) {
    return showModalBottomSheet(
      context: prevContext,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Fotogallerij'),
                // ignore: prefer-extracting-callbacks
                onTap: () {
                  // ignore: avoid-async-call-in-sync-function, prefer-async-await
                  _getImage(ImageSource.gallery, context).then((_) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                // ignore: prefer-extracting-callbacks
                onTap: () {
                  // ignore: avoid-async-call-in-sync-function, prefer-async-await
                  _getImage(ImageSource.camera, context).then((_) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  });
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
                if (_galleryFile == null) ...[
                  TextButton(
                    onPressed: () =>
                        unawaited(_showPicker(prevContext: context)),
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

    final currentUser = ref.watch(currentUserNotifierProvider);
    if (currentUser == null) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Er is iets misgegaan!')),
      );
      FirebaseCrashlytics.instance.recordFlutterFatalError(
        FlutterErrorDetails(
          exception: Exception("No current user when making Post."),
        ),
      );

      return;
    }

    try {
      await PostService.create(
        topic: selectedTopic,
        title: title,
        content: content,
        currentUser: currentUser,
        image: _galleryFile,
      );
      if (mounted) {
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Niewe post aangemaakt!')),
        );
        // ignore: avoid-ignoring-return-values
        context.goNamed("Posts");
      }
    } on Exception {
      if (mounted) {
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Het is niet gelukt om de post te maken, melding gemaakt naar de AppCo!',
            ),
          ),
        );
      }
      rethrow;
    } finally {
      postCreationInProgress = false;
    }
  }
}
