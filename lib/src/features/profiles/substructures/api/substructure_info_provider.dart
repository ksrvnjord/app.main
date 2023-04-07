import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaml/yaml.dart';

/// A provider that fetches the substructure info for a given substructure name.
/// We don't use Firestore, as this content is mostly static and Firestore Console doesn't support multiline strings.
final substructureDescriptionProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, name) async {
  String yaml = await rootBundle.loadString('assets/data/commissie_info.yaml');
  final YamlMap doc = loadYaml(yaml);

  return doc[name]['description'];
});
