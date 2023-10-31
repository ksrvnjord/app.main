import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';

/// All the data we have on a user.
/// Sources: [FirestoreUser] and [DjangoUser].
@immutable
class User {
  final FirestoreUser? _firestore;
  final DjangoUser _django;

  // SHARED FIELDS.
  get firstName => _firestore?.firstName ?? _django.firstName;
  get lastName => _firestore?.lastName ?? _django.lastName;
  get email => _firestore?.email ?? _django.email;
  get phonePrimary => _firestore?.phonePrimary ?? _django.phonePrimary;

  // FIRESTORE SPECIFIC FIELDS.
  get study => _firestore?.study;
  get bestuursFunctie => _firestore?.bestuursFunctie;
  get ploeg => _firestore?.ploeg;
  get board => _firestore?.board;
  get substructures => _firestore?.substructures;
  get allergies => _firestore?.allergies;
  get huis => _firestore?.huis;
  get dubbellid => _firestore?.dubbellid;
  get otherAssociation => _firestore?.otherAssociation;

  // DJANGO SPECIFIC FIELDS.
  get address => _firestore?.address;
  get isStaff => _django.isStaff;

  const User({FirestoreUser? firestore, required DjangoUser django})
      : _django = django,
        _firestore = firestore;
}
