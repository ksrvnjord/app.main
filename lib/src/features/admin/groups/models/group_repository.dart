import 'package:dio/dio.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_type.dart';

class GroupRepository {
  static Future<List<DjangoGroup>> listGroups({
    String? search,
    GroupType? type,
    int? year,
    required Dio dio,
    String? ordering,
  }) async {
    final typeValue = type?.value;

    final res = await dio.get(
      "/api/users/groups/",
      queryParameters: {
        "ordering": ordering,
        "search": search,
        "type": typeValue,
        "year": year,
      },
    );

    return (res.data['results'] as List).map<DjangoGroup>((e) {
      return DjangoGroup.fromJson(e);
    }).toList();
  }
}
