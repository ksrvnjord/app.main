// TODO: maybe start looking a bit more into the json_serializable package
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';

class AlmanakProfile {
  // --- FIRESTORE FIELDS ---
  String? study;
  String? board;
  String? ploeg;
  bool? dubbellid;
  String? otherAssociation;
  List<String>? commissies;
  String? huis;

  // --- HEIMDALL FIELDS ---
  String? email;
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
    this.city,
    this.zipCode,
    this.street,
    this.houseNumber,
    this.houseNumberAddition,
    this.email,
    this.phonePrimary,
  });

  void mergeWithHeimdallProfile(
    Query$AlmanakProfile$user$fullContact$public heimdallProfile,
  ) {
    email = heimdallProfile.email;
    phonePrimary = heimdallProfile.phone_primary;
    city = heimdallProfile.city;
    zipCode = heimdallProfile.zipcode;
    street = heimdallProfile.street;
    houseNumber = heimdallProfile.housenumber;
    houseNumberAddition = heimdallProfile.housenumber_addition;
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
    );
  }

  // Add a toJson method that returns a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'study': study,
      'board': board,
      'ploeg': ploeg,
      'dubbellid': dubbellid,
      'other_association': otherAssociation,
      'commissies': commissies,
      'huis': huis,
    };
  }
}
