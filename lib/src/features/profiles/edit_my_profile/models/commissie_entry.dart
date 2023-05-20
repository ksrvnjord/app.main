import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/group_entry.dart';

class CommissieEntry extends GroupEntry {
  int startYear;
  int endYear;
  String? function;

  CommissieEntry({
    required this.startYear,
    required this.endYear,
    required firstName,
    required lastName,
    required identifier,
    required name,
    this.function,
  }) : super(
          year: startYear,
          name: name,
          firstName: firstName,
          lastName: lastName,
          identifier: identifier,
        );

  factory CommissieEntry.fromJson(Map<String, dynamic> json) {
    return CommissieEntry(
      startYear: json['startYear'],
      endYear: json['endYear'],
      firstName: json['user_first_name'],
      lastName: json['user_last_name'],
      identifier: json['user_identifier'],
      name: json['name'],
      function:
          json['function'] != null && (json['function'] as String).isNotEmpty
              ? json['function']
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startYear': startYear,
      'endYear': endYear,
      'function':
          function != null && (function as String).isNotEmpty ? function : null,
      'user_first_name': firstName,
      'user_last_name': lastName,
      'user_identifier': identifier,
    };
  }

  CommissieEntry copyWith({
    int? startYear,
    int? endYear,
    String? function,
    String? firstName,
    String? lastName,
    String? identifier,
    required String name,
  }) {
    return CommissieEntry(
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      identifier: identifier ?? this.identifier,
      name: name,
      function: function ?? this.function,
    );
  }
}
