import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';

part 'group_django_entry.g.dart';

@JsonSerializable()
class GroupDjangoEntry {
  // ignore: prefer-correct-identifier-length
  final int id;
  final DjangoGroup group;

  @JsonKey(fromJson: _roleFromJson)
  final String? role;
  final List<String> permissions;

  // ignore: sort_constructors_first
  GroupDjangoEntry({
    required this.id,
    required this.group,
    required this.role,
    required this.permissions,
  });

  // ignore: sort_constructors_first
  factory GroupDjangoEntry.fromJson(Map<String, dynamic> json) =>
      _$GroupDjangoEntryFromJson(json);

  Map<String, dynamic> toJson() => _$GroupDjangoEntryToJson(this);

  static String? _roleFromJson(String? role) => role != null
      ? "${role.characters.getRange(0, 1).toUpperCase()}${role.characters.getRange(1)}"
      : null;
}
