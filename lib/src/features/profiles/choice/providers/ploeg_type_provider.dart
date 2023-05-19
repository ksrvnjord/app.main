import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';

final ploegTypeProvider =
    StateProvider<PloegType>((ref) => PloegType.values.first);
