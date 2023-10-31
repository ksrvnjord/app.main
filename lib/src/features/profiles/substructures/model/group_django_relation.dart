// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_user.dart';

part 'group_django_relation.g.dart';

@JsonSerializable()
class GroupDjangoRelation {
  // ignore: prefer-correct-identifier-length
  final int id;
  final GroupDjangoUser user;

  @JsonKey(
    toJson: _roleToJson,
    fromJson: _roleFromJson,
  )
  final String? role;
  final List<String>? permissions;

  GroupDjangoRelation({
    required this.id,
    required this.user,
    this.role,
    this.permissions,
  });

  factory GroupDjangoRelation.fromJson(Map<String, dynamic> json) =>
      _$GroupDjangoRelationFromJson(json);

  Map<String, dynamic> toJson() => _$GroupDjangoRelationToJson(this);

  static String? _roleToJson(String? role) => role?.toLowerCase();

  /// Convert first letter of role to uppercase.
  static String? _roleFromJson(
    String? role,
  ) => //
      role == null
          ? null
          : ("${role.characters.getRange(0, 1).toUpperCase()}${role.characters.getRange(1)}");
}
