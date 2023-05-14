import 'package:flutter/material.dart';

class Tag {
  const Tag({
    required this.label,
    this.backgroundColor,
    this.icon,
  });

  final String label;
  final Color? backgroundColor;
  final IconData? icon;
}
