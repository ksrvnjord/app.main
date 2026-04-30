import 'package:dio/dio.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_type.dart';

class GroupRepository {
  static Future<List<DjangoGroup>> listGroups({
    String? search,
    GroupType? type,
    int? year,
    required Dio dio,
  }) async {
    Response<dynamic> res;
    if (type == null) {
      res = await dio.get(
        "/api/v2/groups/",
        queryParameters: {
          "search": search,
          "year": year,
        },
      );
    } else {
      final typeValue = type.value;

      res = await dio.get(
        "/api/v2/groups/",
        queryParameters: {
          "search": search,
          "type": typeValue,
          "year": year,
        },
      );
    }

    return (res.data['items'] as List).map<DjangoGroup>((e) {
      return DjangoGroup.fromJson(e);
    }).toList();
  }
}
