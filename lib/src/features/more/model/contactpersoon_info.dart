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

@immutable
class MeldpersooncontactInfo extends GroupInfo {
  final String? wie;
  final String? wanneer;
  final String? waarvoor;
  final String? wat;
  final List<String>? lidnummers;
  final String? email;
  final String? link;

  const MeldpersooncontactInfo({
    required super.name,
    this.wie,
    this.wanneer,
    this.waarvoor,
    this.wat,
    this.lidnummers,
    this.email,
    this.link,
  });

  static List<String>? _parseLidnummers(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String) {
      return [value.toString()];
    }
    return null;
  }

  factory MeldpersooncontactInfo.fromMap(Map<String, dynamic> map) {
    return MeldpersooncontactInfo(
      name: map['name'] as String,
      wie: map['Wie'] != null ? map['Wie'] as String : null,
      wanneer: map['Wanneer'] != null ? map['Wanneer'] as String : null,
      waarvoor: map['Waarvoor'] != null ? map['Waarvoor'] as String : null,
      wat: map['Wat'] != null ? map['Wat'] as String : null,
      lidnummers: _parseLidnummers(map["Lidnummers"]),
      email: map['Email'] != null ? map['Email'] as String : null,
      link: map['Link'] != null ? map['Link'] as String : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'wie': wie,
      'wanneer': wanneer,
      'waarvoor': waarvoor,
      'wat': wat,
      'lidnummers': lidnummers,
      'email': email,
    };
  }
}
