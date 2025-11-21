// ignore_for_file: avoid-long-functions, avoid-non-ascii-symbols

import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/all_form_answers_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_image_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answers_export_options.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:universal_html/html.dart' as html;

// This is used for the export options, the key is the name of the option, the value is a function that returns the value of the option, this makes it possible to asynchronously look up the user's name and allergies if necessary.
typedef ExportOptionFunction = Future<String> Function(String userId);

class FormResultsPage extends ConsumerStatefulWidget {
  const FormResultsPage({super.key, required this.formId});

  final String formId;

  @override
  FormResultsPageState createState() => FormResultsPageState();
}

class FormResultsPageState extends ConsumerState<FormResultsPage> {
  bool _isLoading = false;
  int _progressCounter = 0;

  /// Returns the answer for a specific question in a form.
  ///
  /// This method takes a [FirestoreFormQuestion] and a [FormAnswer] as parameters.
  /// It tries to find the user's answer to the given question in the form answer.
  /// If the user has answered the question, it returns the answer.
  /// If the user has not answered the question, it returns an empty string.
  /// If the user has explicitly answered with nothing, it also returns an empty string.
  /// If an error occurs while searching for the answer, it returns an empty string.

  // Utility method to increment the progress counter and return the user ID.
  // This is used to keep track of the progress of the CSV generation.
  // Dart doesn't let us modify the progress counter inside the main loop of the CSV generation.
  // It's a bit of a hack, but it works.

  void _handleDownloadButtonTapDeprecated({
    //TODO questionUpdate: remove this
    required BuildContext context,
    required WidgetRef ref,
    required QuerySnapshot<FormAnswer> answersSnapshot,
    required DocumentSnapshot<FirestoreForm> formSnapshot,
  }) async {
    final exportOptions = await _showExportOptionsDialog(context, ref);
    if (exportOptions == null) return;

    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      final answerDocs = answersSnapshot.docs;
      final form = formSnapshot.data()!;
      final answers = answerDocs.map((doc) => doc.data()).toList();

      // Choose question list based on version
      final questions =
          form.isV2 ? form.questionsMap.values.toList() : form.questions;

      final headerRow = [
        'Lidnummer',
        ...exportOptions.extraFields.keys,
        ...questions.map((q) => q.title),
        'Invultijdstip',
      ];

      final dataRows = await Future.wait(
        answers.map((answer) async {
          final userId = answer.userId;

          // Map questionTitle → answer for lookup
          final answerMap = {
            for (var a in answer.answers) a.questionTitle: a.answer,
          };

          final extraFieldValues = await Future.wait(
            exportOptions.extraFields.values.map((func) => func(userId)),
          );

          // Use the right question list here as well
          final questionAnswers = questions.map((q) {
            final raw = answerMap[q.title];
            if (raw is String && raw.startsWith('[') && raw.endsWith(']')) {
              // Handle multiple-choice answer formatting
              final content = raw.substring(1, raw.length - 1);
              if (content.isEmpty) return '';
              return content;
            }
            return raw ?? '';
          }).toList();

          final timestamp = DateFormat('dd-MM-yyyy HH:mm:ss')
              .format(answer.answeredAt.toDate());

          if (mounted) {
            setState(() {
              _progressCounter++;
            });
          }
          return [
            userId,
            ...extraFieldValues,
            ...questionAnswers,
            timestamp,
          ];
        }),
      );

      final rows = <List<String>>[
        headerRow,
        ...dataRows,
      ];

      final csvString = ListToCsvConverter(
        fieldDelimiter: exportOptions.delimiter,
      ).convert(rows);

      final exportTimeFormatted =
          DateFormat('yyyy-MM-dd-HHmm').format(DateTime.now());
      final fileName = "${form.title}_$exportTimeFormatted.csv";

      if (kIsWeb) {
        _handleDownloadForWeb(csvString, fileName);
      } else {
        _handleDownloadForMobile(csvString, fileName);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _progressCounter = 0;
        });
      }
    }
  }

  void _handleDownloadButtonTap({
    required BuildContext context,
    required WidgetRef ref,
    required QuerySnapshot<FormAnswer> answersSnapshot,
    required DocumentSnapshot<FirestoreForm> formSnapshot,
  }) async {
    final exportOptions = await _showExportOptionsDialog(context, ref);
    if (exportOptions == null) return;

    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      final answerDocs = answersSnapshot.docs;
      final form = formSnapshot.data()!;
      final answers = answerDocs.map((doc) => doc.data()).toList();

      // Choose question list based on version
      final questions = form.questionsMap.values.toList();

      final headerRow = [
        'Lidnummer',
        ...exportOptions.extraFields.keys,
        ...questions.map((q) => q.title),
        'Invultijdstip',
      ];

      final dataRows = await Future.wait(
        answers.map((answer) async {
          final userId = answer.userId;

          // Map questionTitle → answer for lookup
          final answerMap = {
            for (var a in answer.answers) a.questionId.toString(): a.answerList,
          };

          final extraFieldValues = await Future.wait(
            exportOptions.extraFields.values.map((func) => func(userId)),
          );

          // Use the right question list here as well
          final questionAnswers = questions.map((q) {
            var rawList = answerMap[q.id.toString()];
            String? raw;
            if (q.type == FormQuestionType.text ||
                q.type == FormQuestionType.singleChoice ||
                q.type == FormQuestionType.image ||
                q.type == FormQuestionType.date) {
              if (rawList != null) {
                raw = rawList[0];
              }
            } else {
              raw = rawList != null ? rawList.join(',') : '';
            }

            return raw ?? '';
          }).toList();

          final timestamp = DateFormat('dd-MM-yyyy HH:mm:ss')
              .format(answer.answeredAt.toDate());

          if (mounted) {
            setState(() {
              _progressCounter++;
            });
          }
          return [
            userId,
            ...extraFieldValues,
            ...questionAnswers,
            timestamp,
          ];
        }),
      );

      final rows = <List<String>>[
        headerRow,
        ...dataRows,
      ];

      final csvString = ListToCsvConverter(
        fieldDelimiter: exportOptions.delimiter,
      ).convert(rows);

      final exportTimeFormatted =
          DateFormat('yyyy-MM-dd-HHmm').format(DateTime.now());
      final fileName = "${form.title}_$exportTimeFormatted.csv";

      if (kIsWeb) {
        _handleDownloadForWeb(csvString, fileName);
      } else {
        _handleDownloadForMobile(csvString, fileName);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _progressCounter = 0;
        });
      }
    }
  }

  Future<FormAnswersExportOptions?> _showExportOptionsDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
    // ignore: avoid-inferrable-type-arguments
    return showModalBottomSheet<FormAnswersExportOptions>(
      context: context,
      builder: (outerContext) {
        // This map will contain the options the user selected.
        // The key is the name of the option, the value is a function that returns the value of the option.
        // ignore: avoid-explicit-type-declaration
        final LinkedHashMap<String, ExportOptionFunction> availableOptions =
            LinkedHashMap.from({
          'Volledige naam': (String userId) async =>
              (await ref.read(userProvider(userId).future)).fullName,
          'Allergieën': (String userId) async =>
              (await ref.read(userProvider(userId).future))
                  .allergies
                  .join(', '),
          'E-mail': (String userId) async =>
              (await ref.read(userProvider(userId).future)).email,
          'mobiel nummer': (String userId) async =>
              (await ref.read(userProvider(userId).future)).phonePrimary ?? '',
        });

        LinkedHashMap<String, ExportOptionFunction> options =
            LinkedHashMap.from({});

        String delimiter = ';';

        return StatefulBuilder(
          builder: (innerContext, setState) {
            final textTheme = Theme.of(outerContext).textTheme;

            const sheetPadding = 16.0;
            const sheetBottomPadding = 32.0;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(sheetPadding)
                    .copyWith(bottom: sheetBottomPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exporteer naar CSV',
                      style: Theme.of(context).textTheme.titleLarge,
                    ).alignment(Alignment.centerLeft),
                    const SizedBox(height: 8), // ignore: avoid-magic-numbers
                    Text("Extra gegevens exporteren",
                            style: textTheme.titleMedium)
                        .alignment(Alignment.centerLeft),
                    Text(
                      'Let op: Exporteer alleen extra gegevens die je écht nodig hebt, zo ben je in overeenstemming met de AVG.',
                      style: textTheme.labelMedium?.copyWith(
                        color: Theme.of(outerContext).colorScheme.error,
                      ),
                    ),
                    for (final MapEntry(key: fieldName, value: callBack)
                        in availableOptions.entries)
                      CheckboxListTile(
                        value: options.containsKey(fieldName),
                        onChanged: (bool? selected) => setState(() {
                          if (selected == true) {
                            options[fieldName] = callBack;
                          } else {
                            // ignore: avoid-ignoring-return-values
                            options.remove(fieldName);
                          }
                        }),
                        title: Text(fieldName),
                      ),
                    // Dropdown to select delimiter of the CSV file.
                    const SizedBox(height: 16), // ignore: avoid-magic-numbers
                    Text("CSV opties", style: textTheme.titleMedium)
                        .alignment(Alignment.centerLeft),
                    ListTile(
                      title: const Text('Kies een scheidingsteken'),
                      subtitle: Text(
                        'Voor de meeste programma\'s is een komma (,) het standaard scheidingsteken. Als je problemen hebt met het importeren van het CSV bestand, probeer dan een puntkomma (;).',
                        style: textTheme.labelMedium,
                      ),
                      trailing: DropdownButton<String>(
                        items: const [
                          DropdownMenuItem<String>(
                            value: ',',
                            child: Text('Komma (,)'),
                          ),
                          DropdownMenuItem<String>(
                            value: ';',
                            child: Text('Puntkomma (;)'),
                          ),
                        ],
                        value: delimiter,
                        onChanged: (String? value) => setState(() {
                          delimiter = value ?? ';';
                        }),
                      ),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(innerContext).pop(
                        FormAnswersExportOptions(
                          extraFields: options,
                          delimiter: delimiter,
                        ),
                      ),
                      child: const Text('Start export'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      isScrollControlled: true,
    );
  }

  void _handleDownloadForMobile(String csvData, String fileName) async {
    // Add UTF-8 BOM
    final bom = [0xEF, 0xBB, 0xBF];
    final csvBytes = Uint8List.fromList(bom + utf8.encode(csvData));

    // ignore: avoid-ignoring-return-values
    await Share.shareXFiles(
      [
        XFile.fromData(
          csvBytes,
          mimeType: "text/csv",
          name: fileName,
          length: csvBytes.lengthInBytes,
        ),
      ],
      subject: "$fileName antwoorden",
    );
  }

  void _handleDownloadForWeb(String csvData, String fileName) {
    // Add UTF-8 BOM
    final bom = [0xEF, 0xBB, 0xBF];
    final blob = html.Blob([Uint8List.fromList(bom + utf8.encode(csvData))]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  bool _formContainsImageQuestion(FirestoreForm? form) {
    if (form == null) {
      return false;
    }
    if (form.isV2) {
      return form.questionsMap.values
          .any((question) => question.type == FormQuestionType.image);
    } else {
      return form.questions
          .any((question) => question.type == FormQuestionType.image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedAnswersVal =
        ref.watch(allCompletedAnswersProvider(widget.formId));
    final formVal = ref
        .watch(formProvider(FirestoreForm.firestoreConvert.doc(widget.formId)));

    return [
      Scaffold(
          appBar: AppBar(
            title: Text('Volledige Reacties (${completedAnswersVal.maybeWhen(
              data: (answers) => "${answers.size}",
              orElse: () => "",
            )})'),
          ),
          body: completedAnswersVal.when(
            data: (answers) {
              return answers.size == 0
                  ? const Center(
                      child: Text(
                        'Er zijn nog geen (volledige ingevulde) reacties op deze form',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemBuilder: (innerContext, index) {
                        // ignore: avoid-unsafe-collection-methods
                        final answer = answers.docs[index].data();

                        final dateFormat = DateFormat('dd-MM-yyyy HH:mm');

                        final userId = answer.userId;

                        final userVal = ref.watch(userProvider(userId));

                        return ListTile(
                          title: userVal.when(
                            data: (user) => Text(user.fullName),
                            error: (error, stack) {
                              FirebaseCrashlytics.instance
                                  .recordError(error, stack);
                              return Center(
                                child: ErrorTextWidget(
                                  errorMessage: error.toString(),
                                ),
                              );
                            },
                            loading: () => Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(userId),
                                  const SizedBox(width: 8),
                                  const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child:
                                          CircularProgressIndicator.adaptive()),
                                ],
                              ),
                            ),
                          ),
                          subtitle: Text(
                            "Geantwoord op ${dateFormat.format(answer.answeredAt.toDate())}",
                          ),
                        );
                      },
                      itemCount: answers.docs.length,
                    );
            },
            error: (error, stackTrace) {
              return Center(
                child: ErrorTextWidget(errorMessage: error.toString()),
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
          floatingActionButton: formVal.maybeWhen(
            data: (formSnapshot) {
              final formData = formSnapshot.data()!;
              final hasImageQuestions = _formContainsImageQuestion(formData);
              return completedAnswersVal.maybeWhen(
                data: (answersSnapshot) =>
                    Column(mainAxisSize: MainAxisSize.min, children: [
                  FloatingActionButton.extended(
                    tooltip: 'Exporteer antwoorden naar CSV',
                    heroTag: 'downloadCSV',
                    onPressed: () => formData.isV2
                        ? _handleDownloadButtonTap(
                            context: context,
                            ref: ref,
                            answersSnapshot: answersSnapshot,
                            formSnapshot: formSnapshot,
                          )
                        : _handleDownloadButtonTapDeprecated(
                            context: context,
                            ref: ref,
                            answersSnapshot: answersSnapshot,
                            formSnapshot: formSnapshot,
                          ),
                    icon: const Icon(Icons.download),
                    label: const Text('Exporteer antwoorden naar CSV'),
                  ),
                  if (hasImageQuestions) ...[
                    const SizedBox(
                        height: 16), // Add some spacing between the buttons
                    FloatingActionButton.extended(
                      tooltip: 'Download Bijbehorende Foto\'s',
                      heroTag: 'downloadImages',
                      onPressed: () {
                        if (kIsWeb) {
                          downloadAllFormImageAnswers(widget.formId);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Deze functie is alleen beschikbaar op de webversie van de app.',
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Download Bijbehorende Foto\'s'),
                    ),
                  ],
                ]),
                orElse: () => null,
              );
            },
            orElse: () => null,
          )),
      if (_isLoading) // Show a loading indicator when the user is exporting the CSV.
        Positioned.fill(
          child: Container(
            // ignore: no-magic-number
            color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator.adaptive(),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    "Bezig met exporteren van ($_progressCounter/${completedAnswersVal.value?.size ?? "0"}) antwoorden",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontFamily: 'Courier'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
    ].toStack();
  }
}
