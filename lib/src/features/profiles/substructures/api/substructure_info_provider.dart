import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/asset_data.dart';
import 'package:yaml/yaml.dart';

/// A provider that fetches the substructure info for a given substructure name.
/// We don't use Firestore, as this content is mostly static and Firestore Console doesn't support multiline strings.
// ignore: prefer-static-class
final substructureDescriptionProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, name) async {
  String yaml = await rootBundle.loadString(AssetData.substructuren);
  final YamlMap doc = loadYaml(yaml);

  final contains = doc.containsKey(name);
  if (!contains) {
    return null;
  }

  final bool hasDescription = doc[name].containsKey('description');

  if (!hasDescription) {
    return null;
  }

  // ignore: prefer-returning-conditional-expressions
  return doc[name]['description'];
});
