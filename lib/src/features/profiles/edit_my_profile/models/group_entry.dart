import 'package:flutter/foundation.dart';

@immutable
class GroupEntry {
  final int year;
  final String name;
  final String officialName;

  final String groupType;
  final String? role;
  // ignore: sort_constructors_first
  const GroupEntry({
    required this.groupType,
    required this.name,
    required this.officialName,
    this.role,
    required this.year,
  });
}
