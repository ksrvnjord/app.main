// ignore_for_file: avoid_web_libraries_in_flutter, avoid-long-functions

import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';

// ignore: prefer-static-class
final downloadCsvProvider = FutureProviderFamily<void, DownloadCsvParams>(
  (ref, params) async {
    final formName = params.formName;
    final allQuestions = params.formQuestions;
    final snapshot = params.snapshot;

    if (snapshot.docs.isEmpty) {
      return;
    }

    final rows = snapshot.docs.map((formAnswer) {
      final individualAnswers =
          formAnswer.data().answers.map((e) => e.answer).toList();
      final individualQuestions =
          formAnswer.data().answers.map((e) => e.questionTitle).toList();
      final userId = formAnswer.data().userId;
      final answeredAt = DateFormat('dd-MM-yyyy HH:mm:ss')
          .format(formAnswer.data().answeredAt.toDate());

      final sortedAnswers = List.filled(allQuestions.length, '');

      for (int i = 0; i < allQuestions.length; i += 1) {
        // ignore: avoid-unsafe-collection-methods
        final index = individualQuestions.indexOf(allQuestions[i]);
        if (index != -1) {
          sortedAnswers[i] = individualAnswers.elementAtOrNull(index) ?? '';
        }
      }

      return [userId, ...sortedAnswers, answeredAt];
    }).toList();

    final firstRow = [
      'Lidnummer',
      for (final question in allQuestions) question,
      'Invultijdstip',
    ];
    rows.insert(0, firstRow);

    final csvData = const ListToCsvConverter().convert(rows);

    final currentTime = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd-HHmm').format(currentTime);

    // ignore: avoid-negated-conditions
    if (!kIsWeb) {
      final csvBytes = Uint8List.fromList(utf8.encode(csvData));

      // ignore: avoid-ignoring-return-values
      await Share.shareXFiles(
        [
          XFile.fromData(
            csvBytes,
            mimeType: "text/csv",
            name: "${formName}_$formattedTime.csv",
            length: csvBytes.lengthInBytes,
          ),
        ],
        subject: "$formName antwoorden",
      );
    } else {
      final blob = html.Blob([Uint8List.fromList(utf8.encode(csvData))]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = '${formName}_$formattedTime.csv'
        ..click();

      html.Url.revokeObjectUrl(url);
    }
  },
);

// ignore: prefer-match-file-name
class DownloadCsvParams {
  final String formName;
  final List<String> formQuestions;
  final QuerySnapshot<FormAnswer> snapshot;

  const DownloadCsvParams({
    required this.formName,
    required this.formQuestions,
    required this.snapshot,
  });
}
