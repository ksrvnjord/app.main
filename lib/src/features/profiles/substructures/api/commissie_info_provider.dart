import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/asset_data.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/commissie_info.dart';
import 'package:ksrvnjord_main_app/src/features/shared/providers/yaml_map_provider.dart';
import 'package:yaml/yaml.dart';

/// A provider that fetches the substructure info for a given substructure name.
/// We don't use Firestore, as this content is mostly static and Firestore Console doesn't support multiline strings.
// ignore: prefer-static-class
final commissieInfoProvider = FutureProvider.autoDispose
    .family<CommissieInfo?, String>((ref, name) async {
  final commissies =
      await ref.watch(yamlMapProvider(AssetData.commissies).future);
  // Check if the name exists in the yaml file.
  if (!commissies.containsKey(name)) {
    return null;
  }
  final YamlMap? commissie = commissies[name];
  if (commissie == null) {
    return null;
  }

  final map = <String, dynamic>{
    'name': name,
  };
  commissie.forEach((key, value) {
    map[key.toString()] = value;
  });

  return CommissieInfo.fromMap(map);
});

// ignore: prefer-static-class
final commissieNamesProvider =
    FutureProvider.autoDispose<SplayTreeSet<String>>((ref) async {
  final commissieMap =
      await ref.watch(yamlMapProvider(AssetData.commissies).future);

  return SplayTreeSet.of(commissieMap.keys.map((e) => e.toString()));
});

// ignore: prefer-static-class
final commissiesInfoProvider =
    FutureProvider.autoDispose<List<CommissieInfo>>((ref) async {
  final names = await ref.watch(commissieNamesProvider.future);

  // Wait for all futures to complete.
  final infos = await Future.wait(
    names.map((name) => ref.watch(commissieInfoProvider(name).future)),
  );

  return infos.whereType<CommissieInfo>().toList()
    ..sort((a, b) => a.name.compareTo(b.name));
});

// ignore: prefer-static-class
final commissieDescriptionProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, name) async {
  final info = await ref.watch(commissieInfoProvider(name).future);

  return info?.description;
});
