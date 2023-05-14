import 'package:flutter/material.dart';

class Tag {
  const Tag({
    required this.label,
    required this.backgroundColor,
    required this.icon,
  });

  final String label;
  final Color backgroundColor;
  final IconData icon;
}
