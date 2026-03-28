import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';

part 'django_group.g.dart';

@JsonSerializable()
class DjangoGroup {
  @JsonKey(includeFromJson: true, includeToJson: false)
  // ignore: prefer-correct-identifier-length
  final int? id;
  //TODO: should be non-nullable

  @JsonKey(includeFromJson: true, includeToJson: false)
  final List<GroupDjangoRelation>? users;

  /// Gebruik [name] voor UI, ander [officialName]
  final String name;

  /// Gebruik [officialName] voor vergelijken van strings
  final String officialName;

  @JsonKey(
    toJson: _typeToJson,
    fromJson: _typeFromJson,
  )
  final String type;
  final int year;

  // ignore: unused-code
  final List<String> rights;

  // ignore: sort_constructors_first
  factory DjangoGroup.fromJson(Map<String, dynamic> json) =>
      _$DjangoGroupFromJson(json);

  // ignore: sort_constructors_first
  const DjangoGroup({
    this.id,
    this.users,
    this.rights = const [],
    String? officialName,
    required this.name,
    required this.type,
    required this.year,
  }) : officialName = officialName ?? name;

  Map<String, dynamic> toJson() => _$DjangoGroupToJson(this);

  DjangoGroup copyWith({
    int? id,
    List<GroupDjangoRelation>? users,
    String? name,
    String? officialName,
    String? type,
    int? year,
    List<String>? rights,
  }) =>
      DjangoGroup(
        id: id ?? this.id,
        users: users ?? this.users,
        rights: rights ?? this.rights,
        name: name ?? this.name,
        officialName: officialName ?? this.officialName,
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

  void setOfficialName(String officialName) {
    state = state.copyWith(officialName: officialName);
  }

  void setType(String type) {
    state = state.copyWith(type: type);
  }

  void setYear(int year) {
    state = state.copyWith(year: year);
  }
}

// ignore: prefer-static-class
final djangoGroupNotifierProvider =
    NotifierProvider<DjangoGroupNotifier, DjangoGroup>(
  () => DjangoGroupNotifier(),
);
