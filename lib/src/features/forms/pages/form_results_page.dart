// ignore_for_file: avoid-long-functions, avoid-non-ascii-symbols

import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
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
import 'package:share_plus/share_plus.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:math' as math;

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
  String _getAnswerForQuestion(
    FirestoreFormQuestion formQuestion,
    FormAnswer formAnswer,
  ) {
    try {
      // ignore: avoid-unsafe-collection-methods
      final usersAnswerToAQuestion = formAnswer.answers.firstWhere(
        (formQuestionAnswer) =>
            formQuestionAnswer.questionTitle == formQuestion.title,
      );

      return usersAnswerToAQuestion.answer ??
          ""; // If user explicitly answered with nothing, return that.
    } catch (_) {
      // Error can occur when firstWhere if no element satisfies the condition.
      // This is fine, because it means the user didn't answer this question at all.

      return "";
    }
  }

  // Utility method to increment the progress counter and return the user ID.
  // This is used to keep track of the progress of the CSV generation.
  // Dart doesn't let us modify the progress counter inside the main loop of the CSV generation.
  // It's a bit of a hack, but it works.
  Future<String> _incrementProgressCounterAndReturnUserId(
    String userId,
    int answersLength,
  ) async {
    setState(() {
      _progressCounter += 1;
    });

    // This is a intentional delay to prevent our bare-bones Google Cloud SQL server from getting overwhelmed.
    // The delay is exponential, so the first few answers are generated quickly, but the last few slow.
    const growthRate = 0.1874;
    const maximum = 1726 * 4;
    final randomMax = maximum /
        (1 + math.exp(-growthRate * (_progressCounter - answersLength)));

    // ignore: avoid-ignoring-return-values
    await Future.delayed(
      Duration(
        milliseconds: math.Random().nextInt(1 + randomMax.ceil()) +
            // ignore: no-magic-number
            1726 ~/ 8 +
            (randomMax.ceil() ~/ answersLength),
      ),
    );

    return userId;
  }

  void _handleDownloadButtonTap({
    required BuildContext context,
    required WidgetRef ref,
    required QuerySnapshot<FormAnswer> answersSnapshot,
    required DocumentSnapshot<FirestoreForm> formSnapshot,
  }) async {
    final exportOptions = await _showExportOptionsDialog(context, ref);
    if (exportOptions == null) {
      // User cancelled the dialog.
      return;
    }
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      final answerDocs = answersSnapshot.docs;

      // Form is guaranteed to exist if user can access this page.
      // ignore: avoid-non-null-assertion
      final form = formSnapshot.data()!;

      final answers = answerDocs.map((doc) => doc.data()).toList();
      final rows = <List<String>>[
        // HEADER ROW.
        [
          'Lidnummer',
          ...exportOptions
              .extraFields.keys, // Include the export options as headers.
          ...form.questions.map((formQuestion) => formQuestion.title),
          'Invultijdstip',
        ],
        // DATA ROWS.
        // This lets us to asynchronously generate a CSV row for each form answer.
        for (final answer in answers)
          // This List represents a single DATA row in the CSV.
          [
            await _incrementProgressCounterAndReturnUserId(
              answer.userId,
              answers.length,
            ),
            for (final function in exportOptions.extraFields.values)
              await function(answer.userId),
            for (final formQuestion in form.questions)
              _getAnswerForQuestion(formQuestion, answer),
            DateFormat('dd-MM-yyyy HH:mm:ss')
                .format(answer.answeredAt.toDate()),
          ],
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
        });

        LinkedHashMap<String, ExportOptionFunction> options =
            LinkedHashMap.from({});

        String delimiter = ',';

        return StatefulBuilder(
          builder: (innerContext, setState) {
            final textTheme = Theme.of(outerContext).textTheme;

            const sheetPadding = 16.0;
            const sheetBottomPadding = 32.0;

            return [
              Text(
                'Exporteer naar CSV',
                style: Theme.of(context).textTheme.titleLarge,
              ).alignment(Alignment.centerLeft),
              const SizedBox(height: 8), // ignore: avoid-magic-numbers
              Text("Extra gegevens exporteren", style: textTheme.titleMedium)
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
                    delimiter = value ?? ',';
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
            ]
                .toColumn(mainAxisSize: MainAxisSize.min)
                .padding(all: sheetPadding, bottom: sheetBottomPadding);
          },
        );
      },
      isScrollControlled: true,
    );
  }

  void _handleDownloadForMobile(String csvData, String fileName) async {
    final csvBytes = Uint8List.fromList(utf8.encode(csvData));

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
    final blob = html.Blob([Uint8List.fromList(utf8.encode(csvData))]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final completedAnswersVal =
        ref.watch(allCompletedAnswersProvider(widget.formId));
    final formVal = ref.watch(formProvider(formsCollection.doc(widget.formId)));

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

                        return ListTile(
                          title: Text(userId),
                          subtitle: Text(
                            "Geantwoord op ${dateFormat.format(answer.answeredAt.toDate())}",
                          ),
                        );
                      },
                      itemCount: answers.docs.length,
                    );
            },
            error: (error, stackTrace) {
              return Center(child: Text('Error: $error'));
            },
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
          floatingActionButton: formVal.maybeWhen(
            data: (formSnapshot) {
              final hasImageQuestions = formSnapshot
                  .data()!
                  .questions
                  .any((question) => question.type == FormQuestionType.image);
              return completedAnswersVal.maybeWhen(
                data: (answersSnapshot) =>
                    Column(mainAxisSize: MainAxisSize.min, children: [
                  FloatingActionButton.extended(
                    tooltip: 'Exporteer antwoorden naar CSV',
                    heroTag: 'downloadCSV',
                    onPressed: () => _handleDownloadButtonTap(
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
                    "Bezig met exporteren... ($_progressCounter /  ${completedAnswersVal.value?.size ?? "??"})",
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
