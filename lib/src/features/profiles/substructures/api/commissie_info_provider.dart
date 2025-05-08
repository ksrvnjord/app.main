import 'dart:convert';
import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ksrvnjord_main_app/assets/asset_data.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/commissie_info.dart';
import 'package:ksrvnjord_main_app/src/features/shared/providers/yaml_map_provider.dart';
import 'package:yaml/yaml.dart';
import 'package:tuple/tuple.dart';

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

// A provider that fetches the substructure info for a given substructure name from firebase
Future<String?> fetchDescription(String name, int year) async {
  final filePath = '/almanak/commissies/$name/$year/${name}Omschrijving.txt';
  final storageRef = FirebaseStorage.instance.ref(filePath);
  try {
    final data = await storageRef.getData();
    if (data != null) {
      return utf8.decode(data);
    } else {
      throw Exception("Geen omschrijving gevonden.");
    }
  } catch (error) {
    return null;
  }
}

// ignore: prefer-static-class
final commissieDescriptionProvider =
    FutureProvider.autoDispose.family<String?, Tuple2<String, int>>((ref, params) async {
  return await fetchDescription(params.item1, params.item2);
});
