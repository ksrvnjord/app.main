abstract class GroupEntry {
  final int year;
  final String name;
  final String firstName;
  final String lastName;
  final String identifier; // lidnummer

  GroupEntry({
    required this.year,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.identifier,
  });
}
