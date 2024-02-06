import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_users.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/substructure_info_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/almanak_substructure_cover_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/leeden_list.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/substructure_description_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakSubstructuurPage extends ConsumerWidget {
  const AlmanakSubstructuurPage({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final substructureUsers = ref.watch(substructureUsersProvider(name));

    const double pageHPadding = 12;

    final descriptionAsyncVal = ref.watch(
      substructureDescriptionProvider(name),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: AlmanakSubstructureCoverPicture(
              imageProvider: ref.watch(substructurePictureProvider(name)),
            ),
          ).padding(horizontal: pageHPadding),
          SubstructureDescriptionWidget(
            descriptionAsyncVal: descriptionAsyncVal,
          ),
          const SizedBox(height: pageHPadding),
          substructureUsers.when(
            data: (snapshot) =>
                LeedenList(name: name, almanakProfileSnapshot: snapshot),
            loading: () => const CircularProgressIndicator.adaptive().center(),
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
          ),
        ],
      ),
    );
  }
}
