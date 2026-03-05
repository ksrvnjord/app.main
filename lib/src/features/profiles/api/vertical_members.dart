import 'package:dio/dio.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';

// ignore: prefer-static-class
Future<List<DjangoGroup>> getPloegenForVertical(
    {required Dio dio, required int verticaal_id}) async {
  final res = await dio.get("/api/v2/groups/", queryParameters: {
    "type": "competitieploeg",
    "verticaal_id": verticaal_id,
  });
  return (res.data['results'] as List)
      .map((e) => DjangoGroup.fromJson(e))
      .toList();
}

Future<DjangoGroup> addPloegToVertical(
    {required int verticaal_id,
    required int ploeg_id,
    required Dio dio}) async {
  final res = await dio.get(
    "/api/v2/groups/$ploeg_id",
    data: {"verticaal_id": verticaal_id},
  );
  return DjangoGroup.fromJson(res.data);
}

Future<DjangoGroup> removePloegFromVertical({
  required int verticaal_id,
  required int ploeg_id,
  required Dio dio,
}) async {
  final res = await dio.get(
    "api/v2/groups/$ploeg_id",
    data: {
      "verticaal_id": null,
    },
  );
  return DjangoGroup.fromJson(res.data);
}
