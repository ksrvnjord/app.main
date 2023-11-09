import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/group_entry.dart';

// ignore: prefer-static-class
final groupsForUserProvider =
    StreamProvider.autoDispose.family<List<GroupEntry>, String>(
  (ref, userId) async* {
    if (ref.watch(firebaseAuthUserProvider).value == null) {
      yield const [];

      return;
    }
    final user = await ref.watch(userProvider(userId).future);

    final groups = await ref.watch(groupsForDjangoUserProvider(userId).future);

    final List<GroupEntry> groupEntries = groups.map(
      (e) {
        return GroupEntry(
          year: e.group.year,
          name: e.group.name,
          firstName: user.firstName,
          lastName: user.lastName,
          identifier: userId,
          groupType: e.group.type,
          role: e.role,
        );
      },
    ).toList();

    // Sort by year, then by name.
    groupEntries.sort((a, b) {
      int compare = b.year.compareTo(a.year);
      if (compare != 0) return compare;

      return a.name.compareTo(b.name);
    });

    yield groupEntries;
  },
);
