import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

class AfschrijvingFilter {
  String label;
  String description;
  String icon;
  String type;

  AfschrijvingFilter(
      {required this.label,
      required this.description,
      required this.icon,
      required this.type});
}

Future<List<AfschrijvingFilter>?> afschrijvingFilters() async {
  CollectionReference reservationObjectTypesRef =
      FirebaseFirestore.instance.collection('reservationObjectTypes');
  return [ // TODO: Fetch all different reservationObject types from firestore dynamically?
    AfschrijvingFilter(
        description: 'Ruimtes',
        label: 'ruimtes',
        icon: '',
        type: 'Ruimtes',
    )
  ];
}
