import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/all_form_answers_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

class FormResultsPage extends ConsumerWidget {
  const FormResultsPage({Key? key, required this.formId}) : super(key: key);

  final String formId;

  void _handleDownloadButtonTap({
    required QuerySnapshot<FormAnswer> answersSnapshot,
    required DocumentSnapshot<FirestoreForm> formSnapshot,
  }) async {
    final answerDocs = answersSnapshot.docs;

    // Form is guaranteed to exist if user can access this page.
    // ignore: avoid-non-null-assertion
    final form = formSnapshot.data()!;

    final rows = [
      // HEADER ROW.
      [
        'Lidnummer',
        ...form.questions.map((formQuestion) => formQuestion.title),
        'Invultijdstip',
      ],
      // DATA ROWS.
      ...answerDocs.map((formAnswerSnapshot) {
        final formAnswer = formAnswerSnapshot.data();

        return [
          formAnswer.userId,
          // This is a list of all the answers to the questions in the form ordered by the order of the questions.
          ...form.questions.map((formQuestion) {
            // Find answer in formQuestionAnswers based on questionTitle.
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
          }),
          DateFormat('dd-MM-yyyy HH:mm:ss')
              .format(formAnswer.answeredAt.toDate()),
        ];
      }),
    ];

    final csvString = const ListToCsvConverter().convert(rows);

    final exportTimeFormatted =
        DateFormat('yyyy-MM-dd-HHmm').format(DateTime.now());
    final fileName = "${form.title}_$exportTimeFormatted.csv";

    if (kIsWeb) {
      _handleDownloadForWeb(csvString, fileName);
    } else {
      await _handleDownloadForMobile(csvString, fileName);
    }
  }

  Future<void> _handleDownloadForMobile(
    String csvData,
    String fileName,
  ) async {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final completedAnswersVal = ref.watch(allCompletedAnswersProvider(formId));
    final formVal = ref.watch(formProvider(formsCollection.doc(formId)));

    return Scaffold(
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
        data: (formSnapshot) => completedAnswersVal.maybeWhen(
          data: (answersSnapshot) => FloatingActionButton.extended(
            tooltip: 'Download resultaten als CSV',
            heroTag: 'downloadCSV',
            onPressed: () => _handleDownloadButtonTap(
              answersSnapshot: answersSnapshot,
              formSnapshot: formSnapshot,
            ),
            icon: const Icon(Icons.download),
            label: const Text('Download resultaten als CSV'),
          ),
          orElse: () => null,
        ),
        orElse: () => null,
      ),
    );
  }
}
