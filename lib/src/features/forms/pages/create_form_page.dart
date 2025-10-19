import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_repository.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_type.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/firestorm_filler_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_meta_fields_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_questions_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/select_group_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

class CreateFormPage extends ConsumerStatefulWidget {
  const CreateFormPage({super.key, this.existingFormId});

  final String? existingFormId;

  @override
  createState() => CreateFormPageState();
}

class CreateFormPageState extends ConsumerState<CreateFormPage> {
  bool _isLoading = false;
  bool _isInitialized = false;
  final questions = <int, FirestoreFormQuestion>{};
  final fillers = <int, FirestoreFormFillerNotifier>{};
  final formContentObjectIds = <int>[];

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
  bool formAnswersAreUntretractable = false;

  bool get _formHasUnfilledSingleChoiceQuestions {
    for (FirestoreFormQuestion question in questions.values) {
      final questionOptions = question.options;
      if (question.type == FormQuestionType.singleChoice &&
          (questionOptions == null || questionOptions.isEmpty)) {
        return false;
      }
    }

    return true;
  }

  bool get _formsHasNoQuestions => questions.isEmpty;

  void _populateFromForm(FirestoreForm form) {
    // Text fields
    formName.text = form.title;
    description.text = form.description ?? '';
    author.text = form.authorName;

    // Form metadata
    isDraft = form.isDraft;
    isGroupSpecific = form.visibleForGroups.isNotEmpty;
    visibleForGroups = List.from(form.visibleForGroups);
    openUntil = form.openUntil;

    hasMaximumNumberOfAnswers = form.hasMaximumNumberOfAnswers;
    maximumNumberOfAnswers = form.maximumNumberOfAnswers;
    maximumNumberOfAnswersIsVisible = form.maximumNumberIsVisible;
    formAnswersAreUntretractable = form.formAnswersAreUnretractable;

    // Questions
    questions.addEntries(form.questionsMap.entries);

    fillers.addEntries(form.fillers.entries);

    fillers.forEach((id, fillerNotifier) {
      if (fillerNotifier.hasImage) {
        FormRepository.downloadFillerImage(
                widget.existingFormId!, fillerNotifier.id)
            .then((xfile) {
          if (xfile != null) {
            setState(() {
              fillerNotifier.updateImage(xfile);
            });
          }
        });
      }
    });

    // Other form content IDs
    formContentObjectIds.addAll(form.formContentObjectIds);

    _isInitialized = true; // mark as initialized to avoid double population
  }

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

  void updateFormAnswersAreUntretractable(bool? newValue) {
    setState(() {
      formAnswersAreUntretractable = newValue ?? false;
    });
  }

  void updateForm(bool? newValue) {
    setState(() {
      maximumNumberOfAnswersIsVisible = newValue ?? false;
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

  void removeQuestion(int contentIDNumber) {
    setState(() {
      formContentObjectIds.remove(contentIDNumber);
      questions.remove(contentIDNumber);
    });
  }

  void removeFiller(int contentIDNumber) {
    setState(() {
      formContentObjectIds.remove(contentIDNumber);
      fillers.remove(contentIDNumber);
    });
  }

  void addQuestion(FirestoreFormQuestion question) {
    setState(() {
      formContentObjectIds.add(question.id!);
      questions[question.id!] = question;
    });
  }

  void addFiller(FirestoreFormFillerNotifier filler) {
    setState(() {
      formContentObjectIds.add(filler.id);
      fillers[filler.id] = filler;
    });
  }

  void moveQuestionOrFiller(int id, bool directionLeft) {
    setState(() {
      final swapIndex = directionLeft ? id - 1 : id + 1;

      final temp = formContentObjectIds[id];
      formContentObjectIds[id] = formContentObjectIds[swapIndex];
      formContentObjectIds[swapIndex] = temp;
    });
  }

  // ignore: avoid-long-functions
  Future<void> handleSubmitForm(BuildContext context, WidgetRef ref) async {
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

    setState(() {
      _isLoading = true;
    });
    try {
      final result = await FormRepository.createForm(
        form: FirestoreForm(
          createdTimeTimeStamp: Timestamp.now(),
          title: formName.text,
          formContentObjectIds: formContentObjectIds,
          questionsMap: questions,
          fillers: fillers,
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
          visibleForGroups: await convertToIds(visibleForGroups),
          formAnswersAreUnretractable: formAnswersAreUntretractable,
          isV2: true,
        ),
      );

      await FormRepository.createFormImages(
          formId: result.id, fillers: fillers);
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<List<int>> convertToIds(List<String> visibleForGroups) async {
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

    // If editing a draft, watch the form provider
    Widget body;
    if (widget.existingFormId != null) {
      final doc = FirestoreForm.firestoreConvert.doc(widget.existingFormId!);
      final formVal = ref.watch(formProvider(doc));

      body = formVal.when(
        data: (form) {
          // Populate state only once
          if (!_isInitialized) {
            _populateFromForm(form.data()!);
            _isInitialized = true;
          }

          return buildFormListView(colorScheme);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading form: $e')),
      );
    } else {
      // Creating a new form
      body = buildFormListView(colorScheme);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Maak een form aan')),
      body: body,
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Maak nieuwe form',
        heroTag: 'submitForm',
        onPressed: _isLoading ? null : () => handleSubmitForm(context, ref),
        icon: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.send),
        label: Text(_isLoading ? 'Bezig...' : 'Maak nieuwe form'),
      ),
    );
  }

// Helper to keep your existing ListView clean
  Widget buildFormListView(ColorScheme colorScheme) {
    return Form(
      key: _formKey,
      child: ListView(
        padding:
            const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 64),
        children: [
          Text(
            'Let op: Forms kunnen niet worden aangepast na het maken.',
            style: TextStyle(color: colorScheme.outline),
          ),
          const SizedBox(height: 16),
          CreateFormMetaFieldsWidget(),
          CreateFormQuestionsWidget(),
        ],
      ),
    );
  }
}
