import 'package:flutter/foundation.dart';

@immutable
class GroupEntry {
  final int year;
  final String name;
  final String firstName;
  final String lastName;
  final String identifier; // Lidnummer.
  final String groupType;
  final String? role;

  const GroupEntry({
    required this.year,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.identifier,
    required this.groupType,
    this.role,
  });
}
