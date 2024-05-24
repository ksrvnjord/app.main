import 'package:flutter/foundation.dart';

@immutable
abstract class GroupInfo {
  final String name;
  final String? description;

  // ignore: sort_constructors_first
  const GroupInfo({
    required this.name,
    this.description,
  });
}
