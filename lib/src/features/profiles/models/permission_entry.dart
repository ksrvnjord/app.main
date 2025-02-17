// ignore_for_file: sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'permission_entry.g.dart';

@immutable
@JsonSerializable()
class PermissionEntry {
  // ignore: prefer-correct-identifier-length
  final int id;
  final String name;
  final String description;

  const PermissionEntry({
    required this.id,
    required this.name,
    required this.description,
  });

  factory PermissionEntry.fromJson(Map<String, dynamic> json) =>
      _$PermissionEntryFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionEntryToJson(this);
}
