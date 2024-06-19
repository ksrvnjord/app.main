import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_controller.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/auth_constants.dart';

// ignore: prefer-static-class
final dioProvider = Provider<Dio>((ref) {
  final authConstants = GetIt.instance.get<AuthConstants>();
  final _ = ref.watch(authControllerProvider);

  return Dio(BaseOptions(baseUrl: authConstants.baseURL, headers: {
    'Authorization':
        // ignore: avoid-nullable-interpolation
        'Bearer ${ref.read(authControllerProvider).asData?.value.accessToken}',
  }));
});
