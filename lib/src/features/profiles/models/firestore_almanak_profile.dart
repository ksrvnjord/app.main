import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';

class FirestoreAlmanakProfile {
  final String firstName;
  final String lastName;
  final String identifier;
  final String? ploeg;
  final String? board;
  final String? study;
  final String? otherAssociation;
  final String? bestuursFunctie;
  final String? huis;
  final bool? dubbellid;
  final List<String>? substructures;
  String? email;
  Address? address;
  String? phonePrimary;

  FirestoreAlmanakProfile({
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
  });

  // FromJson.
  factory FirestoreAlmanakProfile.fromFirestore(Map<String, dynamic> json) {
    return FirestoreAlmanakProfile(
      firstName: json['first_name'],
      lastName: json['last_name'],
      identifier: json['identifier'],
      ploeg: json['ploeg'],
      board: json['board'],
      study: json['study'],
      otherAssociation: json['other_association'],
      bestuursFunctie: json['bestuurs_functie'],
      huis: json['huis'],
      dubbellid: json['dubbellid'],
      substructures: json['substructures'] != null
          ? List<String>.from(json['substructures'])
          : null,
    );
  }

  factory FirestoreAlmanakProfile.fromHeimdall(Query$AlmanakProfile$user user) {
    Query$AlmanakProfile$user$fullContact$public publicContact =
        user.fullContact.public;

    return FirestoreAlmanakProfile(
      firstName: publicContact.first_name!,
      lastName: publicContact.last_name!,
      identifier: user.identifier,
      email: publicContact.email,
      address: Address(
        street: publicContact.street,
        houseNumber: publicContact.housenumber,
        houseNumberAddition: publicContact.housenumber_addition,
        postalCode: publicContact.zipcode,
        city: publicContact.city,
      ),
      phonePrimary: publicContact.phone_primary,
    );
  }

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
    };
  }

  void mergeWithHeimdallProfile(
    Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public u,
  ) {
    email = u.email;
    phonePrimary = u.phone_primary;
    address = Address(
      street: u.street,
      houseNumber: u.housenumber,
      houseNumberAddition: u.housenumber_addition,
      postalCode: u.zipcode,
      city: u.city,
    );
  }
}
