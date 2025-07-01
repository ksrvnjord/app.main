// ignore_for_file: prefer-static-class
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/group_django_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

final groupsForDjangoUserProvider =
    StreamProvider.autoDispose.family<List<GroupDjangoEntry>, String>(
  (ref, identifier) async* {
    final dio = ref.watch(dioProvider);
    final userResult = await dio.get("/api/v2/users/$identifier");
    final userResultData =
        jsonDecode(userResult.toString()) as Map<String, dynamic>;
    final djangoUser = DjangoUser.fromJson(userResultData);

    final commissies = djangoUser.groups;

    yield commissies;
  },
);
