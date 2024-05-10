// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_info.dart';

@immutable
class CommissieInfo extends GroupInfo {
  final String? email;

  const CommissieInfo({
    required super.name,
    super.description,
    this.email,
  });

  factory CommissieInfo.fromMap(Map<String, dynamic> map) {
    return CommissieInfo(
      name: map['name'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'email': email,
    };
  }
}
