class CommissieEntry {
  String name;
  int startYear;
  int? endYear;
  String? function;

  CommissieEntry({
    required this.name,
    required this.startYear,
    this.endYear,
    this.function,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startYear': startYear,
      'endYear': endYear,
      'function': function,
    };
  }

  factory CommissieEntry.fromJson(Map<String, dynamic> json) {
    return CommissieEntry(
      name: json['name'],
      startYear: json['startYear'],
      endYear: json['endYear'],
      function: json['function'],
    );
  }
}
