// ignore: prefer-static-class
int getNjordYear() {
  /// The Njord year is the year of starting academic month.
  /// So year 2024-2025 -> 2024
  const int startMonth = 9;
  final now = DateTime.now();

  return now.month >= startMonth // Njord year starts in september.
      ? now.year
      : now.year - 1;
}
