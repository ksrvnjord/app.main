import 'package:flutter/material.dart';

@immutable
class Tag {
  final String label;
  final Color backgroundColor;
  final IconData icon;
  // ignore: sort_constructors_first
  const Tag({
    required this.label,
    required this.backgroundColor,
    required this.icon,
  });
}
