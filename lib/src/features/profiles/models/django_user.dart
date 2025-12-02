// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer-named-parameters
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/group_django_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/contact.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/info.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/knrb.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/permission_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

part 'django_user.g.dart';

/// Model representing user data from ONLY Django.
@JsonSerializable()
class DjangoUser {
  // ignore: prefer-correct-identifier-length
  final int id;

  @JsonKey(name: "is_superuser")
  final bool isSuperuser;

  final String username;

  @JsonKey(name: "first_name")
  final String firstName;

  @JsonKey(name: "last_name")
  final String lastName;

  final String infix;

  String email;

  @JsonKey(name: "is_staff")
  final bool isStaff;

  @JsonKey(name: "iid")
  final int identifier;

  @JsonKey(name: "birth_date")
  final String? birthDate;

  String iban;

  final String initials;

  Address address;

  Contact contact;

  final KNRB? knrb;

  Info info;

  final List<GroupDjangoEntry> groups;

  final List<PermissionEntry> permissions;

  DjangoUser({
    required this.id,
    required this.isSuperuser,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.infix,
    required this.email,
    required this.isStaff,
    required this.birthDate,
    required this.initials,
    required this.iban,
    required this.address,
    required this.contact,
    this.knrb,
    required this.permissions,
    required this.info,
    // Required this.phonePrimary,.
    required this.identifier,
    required this.groups,
  });

  factory DjangoUser.fromJson(Map<String, dynamic> json) =>
      _$DjangoUserFromJson(json);

  Map<String, dynamic> toJson() => _$DjangoUserToJson(this);

  bool get isBirthday {
    final currentDate = DateTime.now();
    if (birthDate == null) return false;
    final birthDateTime = DateTime.parse(birthDate!);
    return currentDate.month == birthDateTime.month &&
        currentDate.day == birthDateTime.day;
  }

  static Future<DjangoUser> getByIdentifier(
    Ref ref,
    String lidnummer,
  ) async {
    final dio = ref.watch(dioProvider);

    final res = await dio.get("/api/v2/users/$lidnummer/");
    final data = jsonDecode(res.toString()) as Map<String, dynamic>;

    return DjangoUser.fromJson(data);
  }

  static Future<DjangoUser> getById(
    String id,
    Ref ref,
  ) async {
    final dio = ref.watch(dioProvider);

    final res = await dio.get("/api/v2/users/$id/");
    final data = jsonDecode(res.toString()) as Map<String, dynamic>;
    final user = data;

    return DjangoUser.fromJson(user);
  }

  static Future<bool> updateByIdentifier(
    WidgetRef ref,
    DjangoUser updatedUser,
  ) async {
    final List<String> unchangedAbleFields = [
      'id',
      'iid',
      'is_admin',
      'is_staff',
      'is_active',
      'is_superuser',
      'username',
      'knrb',
      'permissions',
      'groups',
      'birth_date',
      'info.blikken',
      'info.stuurblikken',
      'info.taarten',
      'info.honorary',
    ];
    final dio = ref.watch(dioProvider);
    var jsonUser = updatedUser.toJson();
    jsonUser['info'] = updatedUser.info.toJson();
    for (var elementToRemove in unchangedAbleFields) {
      final keys = elementToRemove.split('.');
      if (keys.length == 1) {
        jsonUser.remove(elementToRemove);
      } else if (keys.length == 2) {
        jsonUser[keys[0]].remove(keys[1]);
      }
    }

    try {
      final res = await dio.patch(
        "/api/v2/users/${updatedUser.identifier}/",
        data: jsonEncode(jsonUser),
      );

      // ignore: no-magic-number
      return res.statusCode == 200;
    } catch (error) {
      // Handle any exceptions that might occur.
      return false;
    }
  }

  void updateWithPartialData(Map<String, dynamic> partialData) {
    partialData.forEach((key, value) {
      // ignore: prefer-correct-switch-length
      switch (key) {
        case 'city':
          address.city = value;
          break;

        case 'email':
          email = value;
          contact.email = value;
          break;

        case 'houseNumber':
          address.houseNumber = value;
          break;

        case 'houseNumberAddition':
          address.houseNumberAddition = value;
          break;

        case 'iban':
          iban = value;
          break;

        case 'phonePrimary':
          contact.phonePrimary = value;
          break;

        case 'postalCode':
          address.postalCode = value;
          break;

        case 'street':
          address.street = value;
          break;

        case 'studie':
          info.studie = value;
          break;

        case 'dubbellid':
          info.dubbellid = value;
          break;

        case 'addressVisible':
          address.visible = value;
          break;

        case 'emailVisible':
          contact.emailVisible = value;
          break;

        case 'phoneVisible':
          contact.phoneVisible = value;
          break;
        // Add other fields as needed.
      }
    });
  }
}
