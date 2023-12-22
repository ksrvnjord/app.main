import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
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
            TextFormField(
              controller: formName,
              decoration: const InputDecoration(labelText: 'Formulier naam'),
            ),
            TextFormField(
              controller: description,
              decoration: const InputDecoration(
                labelText: 'Beschrijving form',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InputDatePickerFormField(
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
              int index = questionEntry.key;
              FirestoreFormQuestion question = questionEntry.value;

              return Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Vraag ${index + 1}',
                    ),
                    onChanged: (String value) => question.label = value,
                  ),
                  DropdownButton<FormQuestionType>(
                    items: FormQuestionType.values
                        .map<DropdownMenuItem<FormQuestionType>>(
                      (FormQuestionType value) {
                        return DropdownMenuItem<FormQuestionType>(
                          value: value,
                          child: Text(value.name.toString()),
                        );
                      },
                    ).toList(),
                    value: question.type,
                    onChanged: (FormQuestionType? newValue) => setState(
                      () => question.type = newValue!,
                    ),
                  ),
                  if (question.type == FormQuestionType.singleChoice)
                    ...(question.options ?? [])
                        .asMap()
                        .entries
                        .map((optionEntry) {
                      int optionIndex = optionEntry.key;
                      String option = optionEntry.value;

                      return TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Optie ${optionIndex + 1}',
                        ),
                        onChanged: (String value) => option = value,
                      );
                    }).toList(),
                  if (question.type == FormQuestionType.singleChoice)
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => question.options!.add('')),
                      child: const Icon(Icons.add),
                    ),
                  ElevatedButton(
                    onPressed: () => setState(() => questions.removeAt(index)),
                    child: const Text("Verwijder vraag"),
                  ),
                  const SizedBox(height: 32),
                ],
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
          authorId: firebaseUser?.identifier ?? '', //TODO: Beter om een error te geven voor non-users.
        ),
      );

      context.goNamed('Admin');
    }
  }
}
