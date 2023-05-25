import 'package:flutter/material.dart';

@immutable
class Tag {
  final String label;
  final Color backgroundColor;
  final IconData icon;

  const Tag({
    required this.label,
    required this.backgroundColor,
    required this.icon,
  });
}
