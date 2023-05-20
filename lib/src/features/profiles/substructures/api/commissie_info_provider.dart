import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/asset_data.dart';
import 'package:yaml/yaml.dart';

/// A provider that fetches the substructure info for a given substructure name.
/// We don't use Firestore, as this content is mostly static and Firestore Console doesn't support multiline strings.
// ignore: prefer-static-class
final commissieInfoProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, name) async {
  String yaml = await rootBundle.loadString(AssetData.commissies);
  final YamlMap doc = loadYaml(yaml);
  // Check if the name exists in the yaml file.
  if (!doc.containsKey(name)) {
    return null;
  }
  final YamlMap commissie = doc[name];
  if (!commissie.containsKey('description')) {
    return null;
  }

  return commissie['description'];
});
