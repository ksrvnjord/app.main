// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_almanak_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirestoreAlmanakProfile _$FirestoreAlmanakProfileFromJson(
        Map<String, dynamic> json) =>
    FirestoreAlmanakProfile(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      identifier: json['identifier'] as String,
      ploeg: json['ploeg'] as String?,
      board: json['board'] as String?,
      study: json['study'] as String?,
      otherAssociation: json['other_association'] as String?,
      bestuursFunctie: json['bestuurs_functie'] as String?,
      huis: json['huis'] as String?,
      dubbellid: json['dubbellid'] as bool?,
      email: json['email'] as String?,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      phonePrimary: json['phonePrimary'] as String?,
      substructures: (json['substructures'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      canBookTrainingFarInAdvance: json['canBookTrainingFarInAdvance'] as bool?,
      isAdmin: json['isAdmin'] as bool?,
      isStaff: json['isStaff'] as bool?,
    );

Map<String, dynamic> _$FirestoreAlmanakProfileToJson(
        FirestoreAlmanakProfile instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'identifier': instance.identifier,
      'ploeg': instance.ploeg,
      'board': instance.board,
      'study': instance.study,
      'other_association': instance.otherAssociation,
      'bestuurs_functie': instance.bestuursFunctie,
      'huis': instance.huis,
      'dubbellid': instance.dubbellid,
      'substructures': instance.substructures,
      'allergies': instance.allergies,
      'email': instance.email,
      'address': instance.address,
      'phonePrimary': instance.phonePrimary,
      'canBookTrainingFarInAdvance': instance.canBookTrainingFarInAdvance,
      'isAdmin': instance.isAdmin,
      'isStaff': instance.isStaff,
    };
