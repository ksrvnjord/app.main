import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';

final ploegYearProvider = StateProvider<int>((ref) => getNjordYear());
