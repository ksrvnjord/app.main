import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_date_time_picker.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:universal_html/html.dart';

class CreateFormPage extends ConsumerStatefulWidget {
  const CreateFormPage({super.key});

  @override
  createState() => _CreateFormPageState();
}

class _CreateFormPageState extends ConsumerState<CreateFormPage> {
  final _questions = <FirestoreFormQuestion>[];

  final _description = TextEditingController();
  final _formName = TextEditingController();

  final _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  DateTime _openUntil = DateTime.now().add(const Duration(days: 7));

  File? _galleryFile;

  bool get _formHasUnfilledSingleChoiceQuestions {
    for (FirestoreFormQuestion question in _questions) {
      final questionOptions = question.options;
      if (question.type == FormQuestionType.singleChoice &&
          (questionOptions == null || questionOptions.isEmpty)) {
        return false;
      }
    }

    return true;
  }

  bool get _formsHasNoQuestions => _questions.isEmpty;

  Future<void> _showPicker({required BuildContext prevContext}) {
    return showModalBottomSheet(
      context: prevContext,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
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

  // ignore: avoid-long-functions
  Future<void> _handleSubmitForm(BuildContext context, WidgetRef ref) async {
    final currentState = _formKey.currentState;
    if (currentState?.validate() == false) {
      return;
    }
    currentState?.save();

    if (_formsHasNoQuestions) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Formulier moet minimaal 1 vraag hebben.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));

      return;
    }

    if (!_formHasUnfilledSingleChoiceQuestions) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'SingleChoice vraag moet minimaal een keuze bevatten.',
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));

      return;
    }

    final currentUser = ref.read(currentUserNotifierProvider);
    if (currentUser == null) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gebruiker is niet ingelogd.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );

      return;
    }
    try {
      final result = await FormRepository.createForm(
        form: FirestoreForm(
          createdTime: Timestamp.now(),
          title: _formName.text,
          questions: _questions,
          openUntil: Timestamp.fromDate(_openUntil),
          description: _description.text,
          authorId: currentUser.identifier.toString(),
          authorName: currentUser.fullName,
        ),
      );
      if (!context.mounted) return;
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Form gemaakt met id: ${result.id}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ));

      context.pop();
    } catch (error) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Er is iets fout gegaan bij het maken van de form: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _description.dispose();
    _formName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const sizedBoxHeight = 16.0;
    const sizedBoxWidthButton = 256.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Maak een form aan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:
              const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 64),
          children: [
            Text(
              'Let op: Forms kunnen niet worden aangepast na het maken.',
              style: TextStyle(color: colorScheme.outline),
            ),
            TextFormField(
              // Kies form naam.
              controller: _formName,
              decoration: const InputDecoration(labelText: 'Formulier naam'),
              maxLines: null,

              validator: (value) => (value == null || value.isEmpty)
                  ? 'Naam van de form kan niet leeg zijn.'
                  : null,
            ),
            TextFormField(
              // Kies beschrijving form.
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Beschrijving form',
              ),
              maxLines: null,
            ),
            const SizedBox(height: sizedBoxHeight),
            CreateFormDateTimePicker(
              initialDate: _openUntil,
              onDateTimeChanged: (DateTime dateTime) =>
                  setState(() => _openUntil = dateTime),
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
              ..._questions.asMap().entries.map((questionEntry) {
                return CreateFormQuestion(
                  index: questionEntry.key,
                  question: questionEntry.value,
                  onChanged: () => setState(() => {}),
                  deleteQuestion: (int index) =>
                      // ignore: avoid-collection-mutating-methods
                      setState(() => _questions.removeAt(index)),
                );
              }),
              const SizedBox(height: sizedBoxHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: sizedBoxWidthButton,
                    child: ElevatedButton(
                      onPressed: () => setState(
                        // ignore: avoid-collection-mutating-methods
                        () => _questions.add(FirestoreFormQuestion(
                          title: '',
                          type: FormQuestionType.singleChoice,
                          isRequired: false,
                          options: [],
                        )), // Add an empty label for the new TextFormField.
                      ),
                      child: const Text('Voeg vraag toe aan form'),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ],
        ),
      ),
      // Floatingactionbutton to submit a form.
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Maak nieuwe form',
        heroTag: 'submitForm',
        // ignore: avoid-async-call-in-sync-function
        onPressed: () => _handleSubmitForm(context, ref),
        icon: const Icon(Icons.send),
        label: const Text('Maak nieuwe form'),
      ),
    );
  }
}
