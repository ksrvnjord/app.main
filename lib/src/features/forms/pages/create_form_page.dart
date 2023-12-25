import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:styled_widget/styled_widget.dart';

class CreateFormPage extends ConsumerStatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends ConsumerState<CreateFormPage> {
  List<FirestoreFormQuestion> questions = [];

  DateTime openUntil = DateTime.now();
  TextEditingController? description;
  TextEditingController formName = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  FirestoreUser? firebaseUser;

  @override
  void initState() {
    super.initState();
    firebaseUser = ref.read(
      currentFirestoreUserProvider,
    ); // TODO: Moet dit in deze specifieke state?
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maak een form aan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField( // Kies form naam.
              controller: formName,
              decoration: const InputDecoration(labelText: 'Formulier naam'),
            ),
            TextFormField( // Kies beschrijving form.
              controller: description,
              decoration: const InputDecoration(
                labelText: 'Beschrijving form',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InputDatePickerFormField( // Kies sluitdatum form.
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              // ignore: prefer-extracting-callbacks
              onDateSaved: (DateTime selectedDate) {
                setState(() {
                  openUntil = selectedDate;
                });
              },
              fieldLabelText: 'Open tot:',
            ),
            ...questions.asMap().entries.map((questionEntry) {
              return CreateFormQuestion(
                key: ValueKey(questionEntry.key),
                index: questionEntry.key,
                question: questionEntry.value,
                onChanged: () => setState(() {}),
                deleteQusetion: (int index) =>
                    setState(() => questions.removeAt(index)),
              );
            }).toList(),
            ElevatedButton(
              onPressed: () => setState(
                () => questions.add(FirestoreFormQuestion(
                  label: '',
                  type: FormQuestionType.singleChoice,
                  options: [],
                )), // Add an empty label for the new TextFormField
              ),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: submitForm,
        icon: const Icon(Icons.send),
        label: const Text('Maak nieuwe form.'),
      ),
    );
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FormRepository.upsertCreateForm(
        form: FirestoreForm(
          formName: formName.text,
          questions: questions,
          openUntil: openUntil,
          description: description?.text,
          authorId: firebaseUser?.identifier ??
              '', //TODO: Beter om een error te geven voor non-users.
        ),
      );

      context.goNamed(RouteName.forms);
    }
  }
}
