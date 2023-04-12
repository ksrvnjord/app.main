import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/model/vaarverbod.dart';

final vaarverbodProvider = FutureProvider<Vaarverbod>(
  (ref) async {
    final Response<Map<String, dynamic>> response =
        await Dio().get('https://heimdall.njord.nl/api/v1/vaarverbod/');
    await Future.delayed(
      const Duration(milliseconds: 1726 ~/ 2),
    ); // add delay so people believe it's loading

    return Vaarverbod.fromJson(response.data!);
  },
);
