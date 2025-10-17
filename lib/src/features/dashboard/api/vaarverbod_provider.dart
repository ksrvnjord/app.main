import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/model/vaarverbod.dart';

// ignore: prefer-static-class
final vaarverbodProvider = FutureProvider<Vaarverbod>(
  (ref) async {
    final Response<Map<String, dynamic>> response =
        await Dio().get('https://heimdall.njord.nl/api/v2/vaarverbod/');

    return Vaarverbod.fromJson(response.data ?? {});
  },
);
