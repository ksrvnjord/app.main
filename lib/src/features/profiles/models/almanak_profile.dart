// TODO: maybe start looking a bit more into the json_serializable package
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';

import '../api/profile.graphql.dart';

class AlmanakProfile {
  // --- FIRESTORE FIELDS ---
  String? firstName;
  String? lastName;
  String lidnummer;
  String? study;
  String? board;
  String? ploeg;
  bool? dubbellid;
  String? otherAssociation;
  List<String>? commissies;
  String? huis;
  List<String>? substructuren;
  String? bestuursFunctie;

  // --- HEIMDALL FIELDS ---
  String? email;
  Address? address;
  String? phonePrimary;
  String? city;
  String? zipCode;
  String? street;
  String? houseNumber;
  String? houseNumberAddition;

  AlmanakProfile({
    required this.lidnummer,
    this.firstName,
    this.lastName,
    this.study,
    this.board,
    this.ploeg,
    this.dubbellid,
    this.otherAssociation,
    this.commissies,
    this.huis,
    this.address,
    this.email,
    this.phonePrimary,
    this.substructuren,
    this.bestuursFunctie,
  });

  // copyWith
  AlmanakProfile copyWith({
    String? firstName,
    String? lastName,
    String? lidnummer,
    String? study,
    String? board,
    String? ploeg,
    bool? dubbellid,
    String? otherAssociation,
    List<String>? commissies,
    String? huis,
    Address? address,
    String? email,
    String? phonePrimary,
    List<String>? substructuren,
    String? bestuursFunctie,
  }) {
    return AlmanakProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      lidnummer: lidnummer ?? this.lidnummer,
      study: study ?? this.study,
      board: board ?? this.board,
      ploeg: ploeg ?? this.ploeg,
      dubbellid: dubbellid ?? this.dubbellid,
      otherAssociation: otherAssociation ?? this.otherAssociation,
      commissies: commissies ?? this.commissies,
      huis: huis ?? this.huis,
      address: address ?? this.address,
      email: email ?? this.email,
      phonePrimary: phonePrimary ?? this.phonePrimary,
      substructuren: substructuren ?? this.substructuren,
      bestuursFunctie: bestuursFunctie ?? this.bestuursFunctie,
    );
  }

  void mergeWithHeimdallProfile(
    Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public u,
  ) {
    email = u.email;
    phonePrimary = u.phone_primary;
    address = Address(
      city: u.city,
      postalCode: u.zipcode,
      street: u.street,
      houseNumber: u.housenumber,
      houseNumberAddition: u.housenumber_addition,
    );
  }

  // Add a factory constructor that takes a Map<String, dynamic> and returns an AlmanakProfile
  factory AlmanakProfile.fromJson(Map<String, dynamic> json) {
    return AlmanakProfile(
      lidnummer: json['identifier'] as String,
      study: json['study'] as String?,
      board: json['board'] as String?,
      ploeg: json['ploeg'] as String?,
      dubbellid: json['dubbellid'] as bool?,
      otherAssociation: json['other_association'] as String?,
      commissies: json.containsKey('commissies')
          ? List<String>.from(json['commissies'])
          : null,
      huis: json['huis'] as String?,
      substructuren: json.containsKey('substructuren')
          ? List<String>.from(json['substructuren'])
          : null,
      bestuursFunctie: json['bestuurs_functie'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }

  factory AlmanakProfile.fromHeimdall(Query$AlmanakProfile$user user) {
    Query$AlmanakProfile$user$fullContact$public publicContact =
        user.fullContact.public;

    return AlmanakProfile(
      lidnummer: user.identifier,
      firstName: publicContact.first_name,
      lastName: publicContact.last_name,
      email: publicContact.email,
      phonePrimary: publicContact.phone_primary,
      address: Address(
        street: publicContact.street,
        houseNumber: publicContact.housenumber,
        houseNumberAddition: publicContact.housenumber_addition,
        postalCode: publicContact.zipcode,
        city: publicContact.city,
      ),
    );
  }

  factory AlmanakProfile.fromHeimdallByIdentifier(
    Query$AlmanakProfileByIdentifier$userByIdentifier user,
  ) {
    Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public
        publicContact = user.fullContact.public;

    return AlmanakProfile(
      lidnummer: user.identifier,
      firstName: publicContact.first_name,
      lastName: publicContact.last_name,
      email: publicContact.email,
      phonePrimary: publicContact.phone_primary,
      address: Address(
        street: publicContact.street,
        houseNumber: publicContact.housenumber,
        houseNumberAddition: publicContact.housenumber_addition,
        postalCode: publicContact.zipcode,
        city: publicContact.city,
      ),
    );
  }

  // This method contains the fields that are sent to Firestore
  Map<String, dynamic> toJson() {
    return {
      if (study != null) 'study': study,
      if (board != null) 'board': board,
      if (ploeg != null) 'ploeg': ploeg,
      if (dubbellid != null) 'dubbellid': dubbellid,
      if (otherAssociation != null) 'other_association': otherAssociation,
      if (commissies != null) 'commissies': commissies,
      if (huis != null) 'huis': huis,
      if (substructuren != null) 'substructuren': substructuren,
    };
  }
}
