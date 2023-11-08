import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer-static-class
final bestuurUsersProvider =
    FutureProvider.autoDispose.family<DjangoGroup?, int>(
  (ref, year) async {
    final besturenForYear = await ref.watch(groupsProvider(
      Tuple2("bestuur", year),
    ).future);

    return besturenForYear.isNotEmpty ? besturenForYear.first : null;
  },
);
