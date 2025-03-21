import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_date_time_picker.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class CreateFormPage extends ConsumerStatefulWidget {
  const CreateFormPage({super.key});

  @override
  createState() => _CreateFormPageState();
}

class _CreateFormPageState extends ConsumerState<CreateFormPage> {
  final _questions = <FirestoreFormQuestion>[];

  final _description = TextEditingController();
  final _formName = TextEditingController();
  final _author = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime _openUntil = DateTime.now().add(const Duration(days: 7));

  bool _isDraft = true;

  bool _hasMaximumNumberOfAnswers = false;
  int? _maximumNumberOfAnswers;
  bool? _maximumNumberOfAnswersIsVisible;

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
          authorName: currentUser.isAdmin
              ? _author.text
              : currentUser.canCreateFormsFor[_author.text]!,
          groupId: currentUser.isAdmin ? null : _author.text,
          hasMaximumNumberOfAnswers: _hasMaximumNumberOfAnswers,
          maximumNumberOfAnswers: _maximumNumberOfAnswers,
          maximumNumberIsVisible: _maximumNumberOfAnswersIsVisible,
          isDraft: _isDraft,
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

    final currentUserAsync = ref.watch(currentUserProvider);

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
            currentUserAsync.when(data: (user) {
              if (user.isAdmin) {
                _author.text = user.fullName;
                return TextFormField(
                  controller: _author,
                  decoration: const InputDecoration(labelText: 'Auteur'),
                  maxLines: null,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Auteur kan niet leeg zijn.'
                      : null,
                );
              } else {
                _author.text = user.canCreateFormsFor.keys.first;
                return DropdownButtonFormField<String>(
                  value: _author.text,
                  decoration: const InputDecoration(labelText: 'Auteur'),
                  items: user.canCreateFormsFor.entries
                      .map((entry) => DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _author.text = newValue ?? '';
                    });
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Auteur kan niet leeg zijn.'
                      : null,
                );
              }
            }, loading: () {
              return const CircularProgressIndicator.adaptive();
            }, error: (error, stack) {
              return Text('Error: $error');
            }),
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
            Row(
              children: [
                Checkbox(
                  value: _hasMaximumNumberOfAnswers,
                  onChanged: (bool? value) {
                    setState(() {
                      _hasMaximumNumberOfAnswers = value ?? false;
                    });
                  },
                ),
                const Text('Maximum aantal antwoorden toestaan'),
              ],
            ),
            if (_hasMaximumNumberOfAnswers)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Maximum aantal antwoorden',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _maximumNumberOfAnswers = int.tryParse(value);
                  });
                },
                validator: (value) {
                  if (_hasMaximumNumberOfAnswers &&
                      (value == null || value.isEmpty)) {
                    return 'Vul het maximum aantal antwoorden in.';
                  }
                  return null;
                },
              ), //TODO disable feature later
            Row(
              children: [
                Checkbox(
                  value: _maximumNumberOfAnswersIsVisible ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      _maximumNumberOfAnswersIsVisible = value;
                    });
                  },
                ),
                const Text('Maximum aantal antwoorden zichtbaar in app'),
              ],
            ),
            currentUserAsync.when(data: (user) {
              return Row(
                children: [
                  AbsorbPointer(
                      absorbing: !user.isAdmin,
                      child: Checkbox(
                        value: _isDraft,
                        onChanged: (bool? value) {
                          setState(() {
                            _isDraft = value ?? false;
                          });
                        },
                      )),
                  const Text('Form is een concept'),
                ],
              );
            }, loading: () {
              return const CircularProgressIndicator.adaptive();
            }, error: (error, stack) {
              return Text('Error: $error');
            }),
            const SizedBox(height: sizedBoxHeight),
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
        onPressed: () => _handleSubmitForm(context, ref),
        icon: const Icon(Icons.send),
        label: const Text('Maak nieuwe form'),
      ),
    );
  }
}
