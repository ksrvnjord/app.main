import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';

part 'firestore_almanak_profile.g.dart';

@immutable
@JsonSerializable()
class FirestoreAlmanakProfile {
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
  final bool? isStaff;

  bool get isAppCo => ['21203', '18031', '18257', '20198', '22195']
      .contains(identifier); // Used for testing purposes and AppCo rights.
  bool get isBestuur =>
      bestuursFunctie != null; // Used to give bestuur more rights in-app.

  const FirestoreAlmanakProfile({
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
    this.isStaff,
  });

  factory FirestoreAlmanakProfile.fromHeimdall(
    Query$AlmanakProfile$user? user,
  ) {
    final publicContact = user?.fullContact.public;

    return FirestoreAlmanakProfile(
      firstName: publicContact?.first_name ?? "Onbekend",
      lastName: publicContact?.last_name ?? "Onbekend",
      identifier: user?.identifier ?? "",
      email: publicContact?.email,
      address: Address(
        street: publicContact?.street,
        houseNumber: publicContact?.housenumber,
        houseNumberAddition: publicContact?.housenumber_addition,
        postalCode: publicContact?.zipcode,
        city: publicContact?.city,
      ),
      phonePrimary: publicContact?.phone_primary,
    );
  }

  factory FirestoreAlmanakProfile.fromJson(Map<String, dynamic> json) =>
      _$FirestoreAlmanakProfileFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreAlmanakProfileToJson(this);

  FirestoreAlmanakProfile copyWith({
    String? firstName,
    String? lastName,
    String? identifier,
    String? ploeg,
    String? board,
    String? study,
    String? otherAssociation,
    String? bestuursFunctie,
    String? huis,
    bool? dubbellid,
    String? email,
    Address? address,
    String? phonePrimary,
    List<String>? substructures,
    List<String>? allergies,
    bool? canBookTrainingFarInAdvance,
    bool? isAdmin,
  }) {
    return FirestoreAlmanakProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      identifier: identifier ?? this.identifier,
      ploeg: ploeg ?? this.ploeg,
      board: board ?? this.board,
      study: study ?? this.study,
      otherAssociation: otherAssociation ?? this.otherAssociation,
      bestuursFunctie: bestuursFunctie ?? this.bestuursFunctie,
      huis: huis ?? this.huis,
      dubbellid: dubbellid ?? this.dubbellid,
      email: email ?? this.email,
      address: address ?? this.address,
      phonePrimary: phonePrimary ?? this.phonePrimary,
      substructures: substructures ?? this.substructures,
      allergies: allergies ?? this.allergies,
      canBookTrainingFarInAdvance:
          canBookTrainingFarInAdvance ?? this.canBookTrainingFarInAdvance,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

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

  FirestoreAlmanakProfile mergeWithHeimdallProfile(
    Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public u,
  ) {
    return copyWith(
      email: u.email,
      phonePrimary: u.phone_primary,
      address: Address(
        street: u.street,
        houseNumber: u.housenumber,
        houseNumberAddition: u.housenumber_addition,
        postalCode: u.zipcode,
        city: u.city,
      ),
    );
  }
}
