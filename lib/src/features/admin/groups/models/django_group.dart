import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';

part 'django_group.g.dart';

@JsonSerializable()
class DjangoGroup {
  // ignore: prefer-correct-identifier-length
  final int id;
  final List<GroupDjangoRelation>? users;
  final String name;
  final String type;
  final int year;

  DjangoGroup({
    required this.id,
    required this.users,
    required this.name,
    required this.type,
    required this.year,
  });

  factory DjangoGroup.fromJson(Map<String, dynamic> json) =>
      _$DjangoGroupFromJson(json);

  Map<String, dynamic> toJson() => _$DjangoGroupToJson(this);
}
