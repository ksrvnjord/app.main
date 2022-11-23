import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

class AfschrijvingFilter {
  String label;
  String description;
  String icon;
  DocumentReference document;

  AfschrijvingFilter(
      {required this.label,
      required this.description,
      required this.icon,
      required this.document});
}

Future<List<AfschrijvingFilter>?> afschrijvingFilters() async {
  CollectionReference reservationObjectTypesRef =
      FirebaseFirestore.instance.collection('reservationObjectTypes');
  return [ // TODO: Fetch all different reservationObject types from firestore dynamically?
    AfschrijvingFilter(
        description: '1 - Skiffs',
        label: 'skiffs',
        icon: '',
        document: reservationObjectTypesRef.doc('Skiffs')),
    AfschrijvingFilter(
        description: '2 - Tweeën',
        label: 'tweeen',
        icon: '',
        document: reservationObjectTypesRef.doc('Tweeen')),
    AfschrijvingFilter(
        description: '4 - Vieren',
        label: 'vieren',
        icon: '',
        document: reservationObjectTypesRef.doc('Vieren')),
    AfschrijvingFilter(
        description: '4 - C4+',
        label: 'C4+',
        icon: '',
        document: reservationObjectTypesRef.doc('C4+')),
    AfschrijvingFilter(
        description: '8 - Achten',
        label: 'achten',
        icon: '',
        document: reservationObjectTypesRef.doc('Achten')),
    AfschrijvingFilter(
        description: 'Bakken',
        label: 'bakken',
        icon: '',
        document: reservationObjectTypesRef.doc('Bakken')),
    AfschrijvingFilter(
        description: 'Krachthonk',
        label: 'landtraining',
        icon: '',
        document: reservationObjectTypesRef.doc('Krachthonk')),
    AfschrijvingFilter(
        description: 'Riemensets',
        label: 'riemensets',
        icon: '',
        document: reservationObjectTypesRef.doc('Riemensets')),
    AfschrijvingFilter(
        description: 'Ruimtes',
        label: 'ruimtes',
        icon: '',
        document: reservationObjectTypesRef.doc('Ruimtes')),
  ];
}
