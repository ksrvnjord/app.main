import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/form_results_page.dart';

@immutable
class FormAnswersExportOptions {
  final LinkedHashMap<String, ExportOptionFunction> extraFields;
  final String delimiter;

  // ignore: sort_constructors_first
  const FormAnswersExportOptions({
    required this.extraFields,
    required this.delimiter,
  });
}
