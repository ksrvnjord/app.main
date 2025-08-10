// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_info.dart';

@immutable
class VertrouwenscontactpersoonInfo extends GroupInfo {
  final String? email;

  const VertrouwenscontactpersoonInfo({
    required super.name,
    this.email,
  });

  factory VertrouwenscontactpersoonInfo.fromMap(Map<String, dynamic> map) {
    return VertrouwenscontactpersoonInfo(
      name: map['name'] as String,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
    };
  }
}
