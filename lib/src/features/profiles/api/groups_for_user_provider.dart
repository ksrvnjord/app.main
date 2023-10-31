import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/group_django_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/heimdall_almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/ploegen_for_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/commissie_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/group_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';

// ignore: prefer-static-class
final groupsForUserProvider =
    StreamProvider.autoDispose.family<List<GroupEntry>, String>(
  (ref, userId) async* {
    if (ref.watch(firebaseAuthUserProvider).value == null) {
      yield const [];

      return;
    }
    final heimdallUser =
        // ignore: avoid-non-null-assertion
        (await ref.watch(heimdallAlmanakProfileProvider(userId).future))!;

    final commissies = ref.watch(commissiesForUserProvider(userId).future);

    final ploegen = ref.watch(ploegenForUserProvider(userId).future);

    // Await for both futures to complete.
    final snapshots = await Future.wait([commissies, ploegen]);

    final List<GroupEntry> groupEntries = [];

    for (final snapshot in snapshots) {
      final type = snapshot.runtimeType;
      switch (type) {
        case const (List<GroupDjangoEntry>):
          final list = snapshot as List<GroupDjangoEntry>;
          final commissies = list
              .where((element) => element.group.type == "commissie")
              .toList();
          groupEntries.addAll(
            commissies.map(
              (e) => CommissieEntry(
                startYear: e.group.year,
                endYear: e.group.year + 1,
                // ignore: avoid-non-null-assertion
                firstName: heimdallUser.fullContact.public.first_name!,
                // ignore: avoid-non-null-assertion
                lastName: heimdallUser.fullContact.public.last_name!,
                identifier: userId,
                name: e.group.name,
                function: e.role,
              ),
            ),
          );
          break;
        default:
          groupEntries.addAll((snapshot as QuerySnapshot<PloegEntry>)
              .docs
              .map((e) => e.data()));
      }
    }
    groupEntries.sort((a, b) => b.year.compareTo(a.year));

    yield groupEntries;
  },
);
