import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/group_django_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/contact.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/info.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/knrb.dart';

/// All the data we have on a user.
/// Sources: [FirestoreUser] and [DjangoUser].
@immutable
class User {
  const User({FirestoreUser? firestore, required DjangoUser django})
      : _django = django,
        _firestore = firestore;
  final FirestoreUser? _firestore;
  final DjangoUser _django;

  // SHARED FIELDS.
  String get firstName => _firestore?.firstName ?? _django.firstName;
  String get lastNameOnly => _firestore?.lastName ?? _django.lastName;
  String get email => _firestore?.email ?? _django.email;
  String? get phonePrimary =>
      _firestore?.phonePrimary ?? _django.contact.phonePrimary;
  int get identifier =>
      int.parse(_firestore?.identifier ?? _django.identifier.toString());

  // FIRESTORE SPECIFIC FIELDS.
  String? get board => _firestore?.board;
  List<String>? get substructures => _firestore?.substructures;
  List<String> get allergies => _firestore?.allergies ?? [];
  String? get huis => _firestore?.huis;
  bool? get dubbellid => _firestore?.dubbellid;
  String? get otherAssociation => _firestore?.otherAssociation;
  bool? get canBookTrainingFarInAdvance =>
      _firestore?.canBookTrainingFarInAdvance;

  // DJANGO SPECIFIC FIELDS.
  String get infix => _django.infix;
  bool get isAdmin => _django.isStaff;
  String get birthDate => _django.birthDate;
  bool get isBirthday => _django.isBirthday;
  String get initials => _django.initials;
  String get iban => _django.iban;

  Address get address => _django.address;
  Contact get contact => _django.contact;
  Info get info => _django.info;
  KNRB? get knrb => _django.knrb;

  List<GroupDjangoEntry> get groups => _django.groups;
  List<int> get groupIds =>
      _django.groups.map((entry) => entry.group.id!).toList();
  // TODO: fix below.
  //List<PermissionEntry> get permissions => _django.permissions;

  // Inferred fields.
  String get lastName => infix.isEmpty ? lastNameOnly : '$infix $lastNameOnly';
  String get fullName => '$firstName $lastName';
  String get identifierString => identifier.toString();
  String? get bestuursFunctie => getBestuursFunctie(
      groups,
      DateTime.now()
          .subtract(Duration(days: 243))
          .year); // 243 days = 8 months we work from september.

  bool get isAppCo =>
      ['21203', '18031', '18257', '20198', '22195', '23292', '23207'].contains(
          identifier.toString()); // Used for testing purposes and AppCo rights.
  bool get isBestuur =>
      bestuursFunctie != null; // Used to give bestuur more rights in-app.

  Map<String, String> get canCreateFormsFor => getCanMakeFormsFor(groups);

  bool get canCreateForms => django.isStaff || canCreateFormsFor.isNotEmpty;

  // EXPOSE DJANGO USER.
  // ignore: avoid-unnecessary-getter
  DjangoUser get django => _django;
}

String? getBestuursFunctie(List<GroupDjangoEntry> entries, int currentYear) {
  return entries
      .where((entry) =>
          entry.group.type == "Bestuur" && entry.group.year == currentYear)
      .map((entry) => entry.role)
      .firstWhere((role) => role != null, orElse: () => null);
}

Map<String, String> getCanMakeFormsFor(List<GroupDjangoEntry> entries) {
  final currentYear = DateTime.now().subtract(Duration(days: 243)).year;
  return entries
      .where((entry) =>
          entry.permissions.contains(
              'forms:*') && // TODO: needs to match on forms:* or forms:create
          (entry.group.year == currentYear ||
              entry.group.year == currentYear + 1))
      .fold({}, (acc, entry) {
    acc[entry.group.id!.toString()] = entry.group.name;
    return acc;
  });
}
