// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';

part 'firestore_user.g.dart';

/// Model representing user data from ONLY Firestore.
@immutable
@JsonSerializable()
class FirestoreUser {
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;

  final String identifier;
  final String? ploeg;
  final String? board;
  final String? study;

  @JsonKey(name: 'other_association')
  final String? otherAssociation;

  @JsonKey(name: 'bestuurs_functie')
  final String? bestuursFunctie;
  final String? huis;
  final bool? dubbellid;
  final List<String>? substructures;

  final List<String> allergies;
  final String? email;
  final Address? address;
  final String? phonePrimary;
  final bool?
      canBookTrainingFarInAdvance; // Used for letting certain users book reservations further in advance.
  final bool? isAdmin; // Used for admin capabilties in-app.

  final bool isRegisteredCoach;
  final bool isRegisteredCox;
  final List<String> coachPreferences;
  final List<String> coxPreferences;
  final List<String> permissions;

  bool get isAppCo => [
        '21203',
        '18031',
        '18257',
        '20198',
        '22195',
        '23292',
        '23207',
        '23226',
      ].contains(identifier); // Used for testing purposes and AppCo rights.
  bool get isBestuur =>
      bestuursFunctie != null; // Used to give bestuur more rights in-app.

  const FirestoreUser({
    required this.firstName,
    required this.lastName,
    required this.identifier,
    this.ploeg,
    this.board,
    this.study,
    this.otherAssociation,
    this.bestuursFunctie,
    this.huis,
    this.dubbellid,
    this.email,
    this.address,
    this.phonePrimary,
    this.substructures,
    this.allergies = const <String>[],
    this.canBookTrainingFarInAdvance,
    this.isAdmin,
    this.isRegisteredCoach = false,
    this.isRegisteredCox = false,
    this.coachPreferences = const <String>[],
    this.coxPreferences = const <String>[],
    this.permissions = const <String>[],
  });

  factory FirestoreUser.fromJson(Map<String, dynamic> json) =>
      _$FirestoreUserFromJson(json);

  // ToJson.
  Map<String, dynamic> toFirestore() {
    return {
      'ploeg': ploeg,
      'board': board,
      'study': study,
      'other_association': otherAssociation,
      'huis': huis,
      'dubbellid': dubbellid,
      'substructures': substructures,
      'allergies': allergies,
    };
  }
}
