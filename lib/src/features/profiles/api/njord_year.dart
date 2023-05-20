// ignore: prefer-static-class
int getNjordYear() {
  const int startMonth = 9;
  final now = DateTime.now();

  return now.month >= startMonth // Njord year starts in september.
      ? now.year
      : now.year - 1;
}
