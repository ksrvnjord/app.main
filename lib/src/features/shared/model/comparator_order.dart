/// Comparator helper class to define the order of the comparator during sorting.
/// A comparator returns:
///  - negative integer, when the first argument is less than the second
/// - zero, when the first argument is equal to the second
/// - positive integer, when the first argument is greater than the second
class ComparatorOrder {
  static const int preserve = 0;
  static const int aFirst = -1;
  static const int bFirst = 1;
}
