import 'package:flutter/foundation.dart';

@immutable
abstract class GroupInfo {
  final String name;
  final String? description;

  const GroupInfo({
    required this.name,
    this.description,
  });
}
