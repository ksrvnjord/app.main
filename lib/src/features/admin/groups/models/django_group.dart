import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';

part 'django_group.g.dart';

@JsonSerializable()
class DjangoGroup {
  // ignore: prefer-correct-identifier-length
  final int? id;
  final List<GroupDjangoRelation>? users;
  final String name;

  @JsonKey(
    toJson: _typeToJson,
    fromJson: _typeFromJson,
  )
  final String type;
  final int year;

  DjangoGroup({
    this.id,
    this.users,
    required this.name,
    required this.type,
    required this.year,
  });

  factory DjangoGroup.fromJson(Map<String, dynamic> json) =>
      _$DjangoGroupFromJson(json);

  Map<String, dynamic> toJson() => _$DjangoGroupToJson(this);

  DjangoGroup copyWith({
    int? id,
    List<GroupDjangoRelation>? users,
    String? name,
    String? type,
    int? year,
  }) =>
      DjangoGroup(
        id: id ?? this.id,
        users: users ?? this.users,
        name: name ?? this.name,
        type: type ?? this.type,
        year: year ?? this.year,
      );

  static String? _typeToJson(String type) => type.toLowerCase();

  /// Convert first letter of role to uppercase.
  static String _typeFromJson(
    String type,
  ) =>
      ("${type.characters.getRange(0, 1).toUpperCase()}${type.characters.getRange(1)}");
}

class DjangoGroupNotifier extends Notifier<DjangoGroup> {
  @override
  DjangoGroup build() =>
      DjangoGroup(name: "", type: "Competitieploeg", year: getNjordYear());

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setType(String type) {
    state = state.copyWith(type: type);
  }

  void setYear(int year) {
    state = state.copyWith(year: year);
  }

  void reset() {
    state =
        DjangoGroup(name: "", type: "Competitieploeg", year: getNjordYear());
  }
}

// ignore: prefer-static-class
final djangoGroupNotifierProvider =
    NotifierProvider<DjangoGroupNotifier, DjangoGroup>(
  () => DjangoGroupNotifier(),
);
