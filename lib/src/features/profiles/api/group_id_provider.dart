import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_repository.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:tuple/tuple.dart';

final groupIDProvider = FutureProvider.autoDispose
    .family<int?, Tuple2<String, int>>((ref, nameAndYear) async {
  final dio = ref.watch(dioProvider);

  final groups = await GroupRepository.listGroups(
    search: nameAndYear.item1,
    year: nameAndYear.item2,
    dio: dio,
  );

  return groups.firstOrNull?.id;
});
