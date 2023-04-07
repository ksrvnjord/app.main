import 'package:flutter/foundation.dart';

@immutable
class SubstructureInfo {
  final String name;
  final String description;

  const SubstructureInfo({
    required this.name,
    required this.description,
  });

  factory SubstructureInfo.fromJson(Map<String, dynamic> json) {
    return SubstructureInfo(
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}
