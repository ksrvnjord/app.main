import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/group_entry.dart';

// ignore: prefer-static-class
final groupsForUserProvider =
    StreamProvider.autoDispose.family<List<GroupEntry>, String>(
  (ref, userId) async* {
    if (ref.watch(firebaseAuthUserProvider).value == null) {
      yield const [];

      return;
    }

    final groups = await ref.watch(groupsForDjangoUserProvider(userId).future);

    final List<GroupEntry> groupEntries = groups.map((e) {
      return GroupEntry(
        groupType: e.group.type,
        name: e.group.name,
        role: e.role,
        year: e.group.year,
      );
    }).toList();

    // Sort by year, then by name.
    groupEntries.sort((a, b) {
      int compare = b.year.compareTo(a.year);
      if (compare != 0) return compare;

      return a.name.compareTo(b.name);
    });

    yield groupEntries;
  },
);
