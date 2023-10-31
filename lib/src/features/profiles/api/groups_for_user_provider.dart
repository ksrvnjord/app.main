import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/group_django_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/commissie_entry.dart';
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

    final List<GroupEntry> groupEntries = groups
        .map(
          (e) => CommissieEntry(
            startYear: e.group.year,
            endYear: e.group.year + 1,
            // ignore: avoid-non-null-assertion
            firstName: user.firstName,
            // ignore: avoid-non-null-assertion
            lastName: user.lastName,
            identifier: userId,
            name: e.group.name,
            function: e.role,
          ),
        )
        .toList();

    groupEntries.sort((a, b) => b.year.compareTo(a.year));

    yield groupEntries;
  },
);
