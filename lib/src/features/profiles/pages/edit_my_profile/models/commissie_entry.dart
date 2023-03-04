class CommissieEntry {
  String name;
  String firstName;
  String lastName;
  String lidnummer;
  int startYear;
  int? endYear;
  String? function;

  CommissieEntry({
    required this.name,
    required this.startYear,
    required this.firstName,
    required this.lastName,
    required this.lidnummer,
    this.endYear,
    this.function,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startYear': startYear,
      'endYear': endYear,
      'function': function,
      'first_name': firstName,
      'last_name': lastName,
      'lidnummer': lidnummer,
    };
  }

  factory CommissieEntry.fromJson(Map<String, dynamic> json) {
    return CommissieEntry(
      name: json['name'],
      startYear: json['startYear'],
      endYear: json['endYear'],
      function: json['function'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      lidnummer: json['lidnummer'],
    );
  }
}
