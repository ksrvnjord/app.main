class AfschrijvingFilter {
  String label;
  String? description;
  String? icon;
  String type;

  AfschrijvingFilter({
    required this.label,
    this.description,
    this.icon,
    required this.type,
  });
}

Future<List<AfschrijvingFilter>?> afschrijvingFilters() async {
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
    ),
  ];
}
