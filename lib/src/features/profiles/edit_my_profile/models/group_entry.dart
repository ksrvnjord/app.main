import 'package:flutter/foundation.dart';

@immutable
class GroupEntry {
  final int year;
  final String name;

  final String groupType;
  final String? role;

  const GroupEntry({
    required this.groupType,
    required this.name,
    this.role,
    required this.year,
  });
}
