import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_date_time_picker.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';

class CreateFormPage extends ConsumerStatefulWidget {
  const CreateFormPage({Key? key}) : super(key: key);

  @override
  createState() => _CreateFormPageState();
}

class _CreateFormPageState extends ConsumerState<CreateFormPage> {
  final _questions = <FirestoreFormQuestion>[];

  final _description = TextEditingController();
  final _formName = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime _openUntil = DateTime.now();
  FirestoreUser? _firebaseUser;

  @override
  void initState() {
    super.initState();
    _firebaseUser = ref.read(currentFirestoreUserProvider);
  }

  Future<void> _handleSubmitForm(BuildContext context) async {
    final currentState = _formKey.currentState;
    if (currentState?.validate() ?? false) {
      if (_questions.isEmpty) {
        const snackBar = SnackBar(
          content: Text('Formulier moet minimaal 1 vraag hebben.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        );
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        return;
      }

      for (FirestoreFormQuestion question in _questions) {
        final questionOptions = question.options;
        if (question.type == FormQuestionType.singleChoice &&
            (questionOptions == null || questionOptions.isEmpty)) {
          const snackBar = SnackBar(
            content: Text(
              'SingleChoice vraag moet minimaal een keuze bevatten.',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          );

          // ignore: avoid-ignoring-return-values
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }

      currentState?.save();
      final form = FirestoreForm(
        createdTime: Timestamp.now(),
        title: _formName.text,
        questions: _questions,
        openUntil: Timestamp.fromDate(_openUntil),
        description: _description.text,
        authorId: _firebaseUser?.identifier ?? '',
      );

      final result = await FormRepository.upsertCreateForm(form: form);

      final snackBarMessage = 'Form gemaakt met id: ${result.id}';
      final snackBar = SnackBar(
        content: Text(snackBarMessage),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      );
      if (!mounted) return;
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      context.pop();
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
            ..._questions.asMap().entries.map((questionEntry) {
              return CreateFormQuestion(
                index: questionEntry.key,
                question: questionEntry.value,
                onChanged: () => setState(() => {}),
                deleteQuestion: (int index) =>
                    // ignore: avoid-collection-mutating-methods
                    setState(() => _questions.removeAt(index)),
              );
            }).toList(),
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
                        isRequired: true,
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
        ),
      ),
      // Floatingactionbutton to submit a form.
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Maak nieuwe form',
        heroTag: 'submitForm',
        // ignore: avoid-async-call-in-sync-function
        onPressed: () => _handleSubmitForm(context),
        icon: const Icon(Icons.send),
        label: const Text('Maak nieuwe form'),
      ),
    );
  }
}
