import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

class RandomCommissieImage extends ConsumerWidget {
  const RandomCommissieImage({
    super.key,
    required this.year,
  });

  final String year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commissiePictureVal = ref.watch(
      randomCommissiePictureProvider(int.parse(year)),
    );

    return commissiePictureVal.when(
      data: (data) => Image(
        image: data,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        isAntiAlias: true,
      ),
      loading: () => Image.asset(
        'assets/images/commissies.jpeg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        isAntiAlias: true,
      ),
      error: (error, stack) => Image.asset(
        'assets/images/commissies.jpeg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        isAntiAlias: true,
      ),
    );
  }
}
