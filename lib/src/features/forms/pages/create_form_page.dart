import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_repository.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_type.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_meta_fields_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_questions_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/select_group_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

class CreateFormPage extends ConsumerStatefulWidget {
  const CreateFormPage({super.key});

  @override
  createState() => CreateFormPageState();
}

class CreateFormPageState extends ConsumerState<CreateFormPage> {
  final questions = <FirestoreFormQuestion>[];

  final description = TextEditingController();
  final formName = TextEditingController();
  final author = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isGroupSpecific = false;
  List<String> visibleForGroups = [];

  DateTime openUntil = DateTime.now().add(const Duration(days: 7));

  bool isDraft = true;

  bool hasMaximumNumberOfAnswers = false;
  int? maximumNumberOfAnswers;
  bool maximumNumberOfAnswersIsVisible = false;

  bool get _formHasUnfilledSingleChoiceQuestions {
    for (FirestoreFormQuestion question in questions) {
      final questionOptions = question.options;
      if (question.type == FormQuestionType.singleChoice &&
          (questionOptions == null || questionOptions.isEmpty)) {
        return false;
      }
    }

    return true;
  }

  bool get _formsHasNoQuestions => questions.isEmpty;

  void updateState() {
    setState(() {});
  }

  void updateAuthor(String newAuthor) {
    setState(() {
      author.text = newAuthor;
    });
  }

  void updateMaximumNumberOfAnswers(int? newValue) {
    setState(() {
      maximumNumberOfAnswers = newValue;
    });
  }

  void updateHasMaximumNumberOfAnswers(bool? newValue) {
    setState(() {
      hasMaximumNumberOfAnswers = newValue ?? false;
    });
  }

  void updateMaximumNumberOfAnswersIsVisible(bool? newValue) {
    setState(() {
      maximumNumberOfAnswersIsVisible = newValue ?? false;
    });
  }

  void updateIsGroupSpecific(bool? newIsGroupSpecific) {
    setState(() {
      isGroupSpecific = newIsGroupSpecific ?? false;
      visibleForGroups = [];
    });
  }

  void updateGroupSettings(bool isOn, String value) {
    setState(() {
      if (isOn && !visibleForGroups.contains(value)) {
        visibleForGroups.add(value);
      } else if (visibleForGroups.contains(value)) {
        visibleForGroups.remove(value);
      }
    });
  }

  void updateIsDraft(bool? newValue) {
    setState(() {
      isDraft = newValue ?? true;
    });
  }

  void updateOpenUntil(DateTime newDateTime) {
    setState(() {
      openUntil = newDateTime;
    });
  }

  void removeQuestion(int index) {
    setState(() {
      questions.removeAt(index);
    });
  }

  void addQuestion(FirestoreFormQuestion question) {
    setState(() {
      questions.add(question);
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
          createdTimeTimeStamp: Timestamp.now(),
          title: formName.text,
          questions: questions,
          openUntilTimeStamp: Timestamp.fromDate(openUntil),
          description: description.text,
          authorId: currentUser.identifier.toString(),
          authorName: currentUser.isAdmin
              ? author.text
              : currentUser.canCreateFormsFor[author.text]!,
          groupId: currentUser.isAdmin ? null : author.text,
          hasMaximumNumberOfAnswers: hasMaximumNumberOfAnswers,
          maximumNumberOfAnswers: maximumNumberOfAnswers ??
              100000, //Default value mimicing infinity
          maximumNumberIsVisible: maximumNumberOfAnswersIsVisible,
          isDraft: isDraft,
          visibleForGroups: await _convertToIds(visibleForGroups),
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

  Future<List<int>> _convertToIds(List<String> visibleForGroups) async {
    final dio = ref.watch(dioProvider);

    if (visibleForGroups.isNotEmpty) {
      final visibleForGroupIDs = <int>[];
      for (String groupString in visibleForGroups) {
        switch (groupString) {
          case GroupChoices.wedstrijd || GroupChoices.competitie:
            {
              final result = await GroupRepository.listGroups(
                type: (groupString == GroupChoices.wedstrijd)
                    ? GroupType.wedstrijdsectie
                    : GroupType.competitieploeg,
                year: getNjordYear(),
                dio: dio,
                ordering: "name",
              );

              visibleForGroupIDs.addAll(result.map((group) => group.id!));
              break;
            }

          case GroupChoices.club8Plus ||
                GroupChoices.topC4Plus ||
                GroupChoices.sjaarzen:
            {
              if (groupString == GroupChoices.sjaarzen) {
                groupString = "Lichting";
              }

              final result = await GroupRepository.listGroups(
                search: groupString,
                year: getNjordYear(),
                dio: dio,
                ordering: "name",
              );
              visibleForGroupIDs.addAll(result.map((group) => group.id!));
              break;
            }

          default:
        }
      }

      return visibleForGroupIDs;
    }

    return [];
  }

  @override
  void dispose() {
    description.dispose();
    formName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            const SizedBox(
              height: 16,
            ),
            CreateFormMetaFieldsWidget(),
            CreateFormQuestionsWidget(),
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
