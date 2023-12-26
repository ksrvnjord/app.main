// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';

// ignore: prefer-static-class
final downloadCsvProvider = FutureProviderFamily<void, DownloadCsvParams>(
  (ref, params) async {
    final formName = params.formName;
    final snapshot = params.snapshot;

    if (snapshot.docs.isEmpty) {
      return;
    }
    final firstDocument = snapshot.docs.first;
    final questions =
        firstDocument.data().answers.map((a) => a.question).toList();

    final List<List<String?>> rows = snapshot.docs.map((formAnswer) {
      final answers = formAnswer.data().answers;
      final userId = formAnswer.data().userId;
      final answeredAt = formAnswer.data().answeredAt.toString();

      return [userId, for (final answer in answers) answer.answer, answeredAt];
    }).toList();

    final firstRow = [
      'Lidnummer',
      for (final question in questions) question,
      'Invultijdstip',
    ];
    rows.insert(0, firstRow);

    final csvData = const ListToCsvConverter().convert(rows);

    final currentTime = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd-HHmm').format(currentTime);

    if (!kIsWeb) {
      final directory = await getDownloadsDirectory();
      final file = File('${directory!.path}/${formName}_$formattedTime.csv');
      await file.writeAsString(csvData);
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

class DownloadCsvParams {
  final String formName;
  final QuerySnapshot<FormAnswer> snapshot;

  DownloadCsvParams({required this.formName, required this.snapshot});
}
