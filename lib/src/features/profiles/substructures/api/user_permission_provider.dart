import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:tuple/tuple.dart';

final permissionsProvider =
    FutureProvider.family<List<String>, Tuple2<int, int>>(
        (ref, groupAndUser) async {
  final groupId = groupAndUser.item1;
  final userId = groupAndUser.item2;
  final dio = ref.read(dioProvider);

  try {
    final response = await dio.get("/api/v2/groups/$groupId/$userId");
    final List<String> permissions =
        (response.data['permissions'] as List<dynamic>)
            .map((e) => e as String)
            .toList();
    return permissions;
  } catch (e, stack) {
    debugPrintStack(stackTrace: stack);
    return [];
  }
});
