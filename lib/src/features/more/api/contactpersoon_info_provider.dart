import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/asset_data.dart';
import 'package:ksrvnjord_main_app/src/features/more/model/contactpersoon_info.dart';
import 'package:ksrvnjord_main_app/src/features/shared/providers/yaml_map_provider.dart';
import 'package:yaml/yaml.dart';

const Map<String, String> contactAssetMap = {
  "Vertrouwenscontactpersonen": AssetData.vertrouwenscontactpersonen,
  "Bestuur": AssetData.bestuur,
};

// Provides names and email for VCP's and bestuur
final contactpersonenInfoProvider = FutureProvider.autoDispose
    .family<List<VertrouwenscontactpersoonInfo>, String>((ref, assetPath) async {
  final yamlMap = await ref
      .watch(yamlMapProvider(contactAssetMap[assetPath]!).future);
  final names = yamlMap.keys.map((e) => e.toString()).toList();
  final infos = await Future.wait(
    names.map((name) async {
      final YamlMap? contactPersoonMap = yamlMap[name];
      if (contactPersoonMap == null) {
        return null;
      }
      final map = <String, dynamic>{
        'name': name,
      };
      contactPersoonMap.forEach((key, value) {
        map[key.toString()] = value;
      });
      return VertrouwenscontactpersoonInfo.fromMap(map);
    })
  );
  return infos.whereType<VertrouwenscontactpersoonInfo>().toList();
});

// Provides info for internal and external helpsources
final contactmeldpersoonInfoProvider = FutureProvider.autoDispose
    .family<MeldpersooncontactInfo?, (bool, String)>((ref, params) async {
  final isIntern = params.$1;
  final name = params.$2;
  final meldpersonencontact = await ref.watch(yamlMapProvider(
          isIntern ? AssetData.meldpersooncontact : AssetData.externContact)
      .future);
  if (!meldpersonencontact.containsKey(name)) {
    return null;
  }
  final YamlMap? meldpersooncontact = meldpersonencontact[name];
  if (meldpersooncontact == null) {
    return null;
  }
  final map = <String, dynamic>{
    'name': name,
  };
  meldpersooncontact.forEach((key, value) {
    map[key.toString()] = value;
  });
  return MeldpersooncontactInfo.fromMap(map);
});

final meldpersooncontactNamesProvider = FutureProvider.autoDispose
    .family<List<String>, bool>((ref, isIntern) async {
  final meldpersooncontactMap = await ref.watch(yamlMapProvider(
          isIntern ? AssetData.meldpersooncontact : AssetData.externContact)
      .future);

  return meldpersooncontactMap.keys.map((e) => e.toString()).toList();
});

final meldpersonencontactInfoProvider =
    FutureProvider.autoDispose.family<dynamic, bool>((ref, isIntern) async {
  if (isIntern) {
    final names =
        await ref.watch(meldpersooncontactNamesProvider(isIntern).future);

    // Wait for all futures to complete.
    final infos = await Future.wait(
      names.map((name) =>
          ref.watch(contactmeldpersoonInfoProvider((isIntern, name)).future)),
    );
    return infos.whereType<MeldpersooncontactInfo>().toList();
  } else {
    final extern =
        await ref.watch(yamlMapProvider(AssetData.externContact).future);
    final Map<String, List<MeldpersooncontactInfo>> grouped = {};
    extern.forEach((category, subs) {
      final List<MeldpersooncontactInfo> subList = [];
      if (subs is Map) {
        subs.forEach((subName, subData) {
          if (subData is Map) {
            final map = <String, dynamic>{'name': subName.toString()};
            subData.forEach((key, value) {
              map[key.toString()] = value;
            });
            subList.add(MeldpersooncontactInfo.fromMap(map));
          }
        });
        grouped[category] = subList;
      }
    });
    return grouped;
  }
});
