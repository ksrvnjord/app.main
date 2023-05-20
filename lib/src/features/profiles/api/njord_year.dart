int getNjordYear() {
  const int startMonth = 9;
  final now = DateTime.now();

  return now.month >= startMonth // njord year starts in september
      ? now.year
      : now.year - 1;
}
