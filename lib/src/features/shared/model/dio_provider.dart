import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_controller.dart';

// ignore: prefer-static-class
final dioProvider = Provider<Dio>((ref) {
  final auth = ref.watch(authControllerProvider).asData?.value;

  return Dio(BaseOptions(baseUrl: auth?.constants?.baseURL, headers: {
    'Authorization':
        // ignore: avoid-nullable-interpolation
        'Bearer ${auth?.accessToken}',
  }));
});
