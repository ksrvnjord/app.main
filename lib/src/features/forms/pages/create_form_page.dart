import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_date_time_picker.dart';
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
  TextEditingController? description = TextEditingController();
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
    final colorScheme = Theme.of(context).colorScheme;
    const double sizedBoxHeight = 16;
    const double sizedBoxWidth = 16;
    const double sizedBoxWidthButton = 256;

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
              // Kies form naam.
              controller: formName,
              decoration: const InputDecoration(labelText: 'Formulier naam'),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Naam van de form kan niet leeg zijn.'
                  : null,
            ),
            TextFormField(
              // Kies beschrijving form.
              controller: description,
              decoration: const InputDecoration(
                labelText: 'Beschrijving form',
              ),
            ),
            const SizedBox(
              height: sizedBoxHeight,
            ),
            CreateFormDateTimePicker(
              initialDate: openUntil,
              onDateTimeChanged: (DateTime dateTime) =>
                  setState(() => openUntil = dateTime),
            ),
            ...questions.asMap().entries.map((questionEntry) {
              return CreateFormQuestion(
                index: questionEntry.key,
                question: questionEntry.value,
                onChanged: () => setState(() {}),
                deleteQuestion: (int index) =>
                    setState(() => questions.removeAt(index)),
              );
            }).toList(),
            const SizedBox(
              height: sizedBoxHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SizedBox(
                  width: sizedBoxWidthButton,
                  child: ElevatedButton(
                    onPressed: () => setState(
                      () => questions.add(FirestoreFormQuestion(
                        label: '',
                        type: FormQuestionType.singleChoice,
                        options: [],
                      )), // Add an empty label for the new TextFormField.
                    ),
                    child: const Text('Voeg vraag toe aan form'),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: sizedBoxHeight,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              const Spacer(),
              SizedBox(
                width: sizedBoxWidthButton,
                child: ElevatedButton(
                  onPressed: () => submitForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: sizedBoxWidth),
                      Text('Maak nieuwe form'),
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Formulier moet minimaal 1 vraag hebben.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );

        return;
      }

      for (FirestoreFormQuestion question in questions) {
        if (question.type == FormQuestionType.singleChoice &&
            (question.options == null || question.options!.isEmpty)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'SingleChoice vraag moet minimaal een keuze bevatten.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );

          return;
        }

        if (question.type == FormQuestionType.singleChoice &&
            (question.options == null || question.options!.isEmpty)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Vraag moet minimaal 1 optie hebben.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );

          return;
        }
      }

      _formKey.currentState!.save();
      final form = FirestoreForm(
        createdTime: DateTime.now(),
        formName: formName.text,
        questions: questions,
        openUntil: openUntil,
        description: description?.text,
        authorId: firebaseUser?.identifier ?? '',
      );

      final result = await FormRepository.upsertCreateForm(form: form);

      if (result != null) {
        final snackBarMessage = 'Form gemaakt met id: ${result.id}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackBarMessage),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      context.goNamed(RouteName.forms);
    }
  }
}
