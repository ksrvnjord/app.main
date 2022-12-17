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
  return [
    // TODO: Fetch all different reservationObject types from firestore dynamically?
    AfschrijvingFilter(
      description: 'Bak',
      label: 'bak',
      icon: '',
      type: 'Bak',
    ),
    AfschrijvingFilter(
      description: 'C1x',
      label: 'c1x',
      icon: '',
      type: 'C1x',
    ),
    AfschrijvingFilter(
      description: 'C2x',
      label: 'c1x',
      icon: '',
      type: 'C2x',
    ),
    AfschrijvingFilter(
      description: 'C2+',
      label: 'c2+',
      icon: '',
      type: 'C2+',
    ),
    AfschrijvingFilter(
      description: 'C2x+',
      label: 'C2x+',
      icon: '',
      type: 'C2x+',
    ),
    AfschrijvingFilter(
      description: 'C4+',
      label: 'C4+',
      icon: '',
      type: 'C4+',
    ),
    AfschrijvingFilter(
      description: 'Ruimtes',
      label: 'ruimtes',
      icon: '',
      type: 'Ruimtes',
    )
  ];
}
