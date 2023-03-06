int getNjordYear() {
  const int startMonth = 9;

  return DateTime.now().month >= startMonth // njord year starts in september
      ? DateTime.now().year
      : DateTime.now().year - 1;
}
