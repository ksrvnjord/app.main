import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

// ignore: prefer-static-class
final groupsProvider = FutureProvider<List>((ref) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get("/api/users/groups/");

  return res.data['results'];
});

// ignore: prefer-static-class
final groupByIdProvider =
    FutureProvider.family<List, String>((ref, String id) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get("/api/users/groups/$id/");

  return res.data['users'];
});
