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
      'user_first_name': firstName,
      'user_last_name': lastName,
      'user_identifier': lidnummer,
    };
  }

  factory CommissieEntry.fromJson(Map<String, dynamic> json) {
    return CommissieEntry(
      name: json['name'],
      startYear: json['startYear'],
      endYear: json['endYear'],
      function: json['function'],
      firstName: json['user_first_name'],
      lastName: json['user_last_name'],
      lidnummer: json['user_identifier'],
    );
  }
}
