import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

class AfschrijvingFilter {
  String label;
  String description;
  String icon;

  AfschrijvingFilter(
      {required this.label, required this.description, required this.icon});
}

Future<List<AfschrijvingFilter>?> afschrijvingFilters(
    GraphQLClient client) async {
  return [
    AfschrijvingFilter(description: '1 - Skiffs', label: 'skiffs', icon: ''),
    AfschrijvingFilter(description: '2 - Tweeën', label: 'tweeen', icon: ''),
    AfschrijvingFilter(description: '4 - Vieren', label: 'vieren', icon: ''),
    AfschrijvingFilter(description: '8 - Achten', label: 'achten', icon: ''),
    AfschrijvingFilter(description: 'Bakken', label: 'bakken', icon: ''),
    AfschrijvingFilter(
        description: 'Landtraining', label: 'landtraining', icon: ''),
    AfschrijvingFilter(
        description: 'Riemensets', label: 'riemensets', icon: ''),
    AfschrijvingFilter(description: 'Ruimtes', label: 'ruimtes', icon: ''),
    AfschrijvingFilter(
        description: 'Wedstrijdvloot', label: 'wedstrijdvloot', icon: ''),
  ];
}
