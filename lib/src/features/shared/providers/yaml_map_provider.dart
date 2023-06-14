import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaml/yaml.dart';

// Use a provider to only read once, so we don't have to read the file every time we need the data.
// ignore: prefer-static-class
final yamlMapProvider =
    FutureProvider.autoDispose.family<YamlMap, String>((ref, filename) async {
  String yaml = await rootBundle.loadString(filename);

  return loadYaml(yaml);
});
