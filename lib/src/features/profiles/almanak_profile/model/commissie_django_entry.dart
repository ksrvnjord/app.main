import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';

part 'commissie_django_entry.g.dart';

@JsonSerializable()
class GroupDjangoEntry {
  final int id;
  final DjangoGroup group;
  final String? role;
  final List<String> permissions;

  GroupDjangoEntry({
    required this.id,
    required this.group,
    required this.role,
    required this.permissions,
  });

  factory GroupDjangoEntry.fromJson(Map<String, dynamic> json) =>
      _$GroupDjangoEntryFromJson(json);

  Map<String, dynamic> toJson() => _$GroupDjangoEntryToJson(this);
}
