import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/group_django_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';

/// All the data we have on a user.
/// Sources: [FirestoreUser] and [DjangoUser].
@immutable
class User {
  final FirestoreUser? _firestore;
  final DjangoUser _django;

  // SHARED FIELDS.
  String get firstName => _firestore?.firstName ?? _django.firstName;
  String get lastName => _firestore?.lastName ?? _django.lastName;
  String get email => _firestore?.email ?? _django.email;
  String? get phonePrimary => _firestore?.phonePrimary ?? _django.phonePrimary;
  int get identifier =>
      int.parse(_firestore?.identifier ?? _django.identifier.toString());

  // FIRESTORE SPECIFIC FIELDS.
  String? get study => _firestore?.study;
  String? get bestuursFunctie => _firestore?.bestuursFunctie;
  String? get board => _firestore?.board;
  List<String>? get substructures => _firestore?.substructures;
  List<String> get allergies => _firestore?.allergies ?? [];
  String? get huis => _firestore?.huis;
  bool? get dubbellid => _firestore?.dubbellid;
  String? get otherAssociation => _firestore?.otherAssociation;

  // DJANGO SPECIFIC FIELDS.
  Address? get address => _firestore?.address;
  bool get isAdmin => _firestore?.isAdmin ?? _django.isStaff;
  List<GroupDjangoEntry> get groups => _django.groups;

  // INFERRED FIELDS.
  String get fullName => '$firstName $lastName';
  // ignore: sort_constructors_first
  const User({FirestoreUser? firestore, required DjangoUser django})
      : _django = django,
        _firestore = firestore;
}
