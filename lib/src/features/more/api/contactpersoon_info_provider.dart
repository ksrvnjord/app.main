import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/asset_data.dart';
import 'package:ksrvnjord_main_app/src/features/more/model/contactpersoon_info.dart';
import 'package:ksrvnjord_main_app/src/features/shared/providers/yaml_map_provider.dart';
import 'package:yaml/yaml.dart';

final vertrouwenscontactpersoonInfoProvider = FutureProvider.autoDispose
    .family<VertrouwenscontactpersoonInfo?, String>((ref, name) async {
  final vertrouwenscontactpersonen = await ref
      .watch(yamlMapProvider(AssetData.vertrouwenscontactpersonen).future);
  // Check if the name exists in the yaml file.
  if (!vertrouwenscontactpersonen.containsKey(name)) {
    return null;
  }
  final YamlMap? vertrouwenscontactpersoon = vertrouwenscontactpersonen[name];
  if (vertrouwenscontactpersoon == null) {
    return null;
  }

  final map = <String, dynamic>{
    'name': name,
  };
  vertrouwenscontactpersoon.forEach((key, value) {
    map[key.toString()] = value;
  });

  return VertrouwenscontactpersoonInfo.fromMap(map);
});

// ignore: prefer-static-class
final vertrouwenscontactpersoonNamesProvider =
    FutureProvider.autoDispose<SplayTreeSet<String>>((ref) async {
  final vertrouwenscontactpersoonMap = await ref
      .watch(yamlMapProvider(AssetData.vertrouwenscontactpersonen).future);

  return SplayTreeSet.of(
      vertrouwenscontactpersoonMap.keys.map((e) => e.toString()));
});

// ignore: prefer-static-class
final vertrouwenscontactpersonenInfoProvider =
    FutureProvider.autoDispose<List<VertrouwenscontactpersoonInfo>>(
        (ref) async {
  final names = await ref.watch(vertrouwenscontactpersoonNamesProvider.future);

  // Wait for all futures to complete.
  final infos = await Future.wait(
    names.map((name) =>
        ref.watch(vertrouwenscontactpersoonInfoProvider(name).future)),
  );

  return infos.whereType<VertrouwenscontactpersoonInfo>().toList();
});
