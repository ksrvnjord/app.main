import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer-static-class
final List<Tuple2<int, int>> yearsFrom1874 = List.generate(
  getNjordYear() - 1874 + 2,
  (index) => Tuple2<int, int>(
    // '2022-2023', '2021-2022', ...
    getNjordYear() + 1 - index,
    // Generate from next year to 1874.
    getNjordYear() + 1 - index + 1,
  ),
).toList();
