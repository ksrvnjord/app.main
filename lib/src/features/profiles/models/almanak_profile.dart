// TODO: maybe start looking a bit more into the json_serializable package
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';

class AlmanakProfile {
  // --- FIRESTORE FIELDS ---
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

  void mergeWithHeimdallProfile(
    Query$AlmanakProfile$user$fullContact$public u,
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
    );
  }

  // This method contains the fields that are sent to Firestore
  Map<String, dynamic> toJson() {
    return {
      'study': study,
      'board': board,
      'ploeg': ploeg,
      'dubbellid': dubbellid,
      'other_association': otherAssociation,
      'commissies': commissies,
      'huis': huis,
      'substructuren': substructuren,
    };
  }
}
