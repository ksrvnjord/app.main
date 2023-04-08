import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const widgetPadding = 16.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final substructureUsers = ref.watch(substructureUsersProvider(name));

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: [
          AlmanakSubstructureCoverPicture(
            imageProvider: ref.watch(substructurePictureProvider(name)),
          ),
          SubstructureDescriptionWidget(
            descriptionAsyncVal: ref.watch(
              substructureDescriptionProvider(name),
            ),
          ),
          substructureUsers.when(
            data: (snapshot) =>
                LeedenList(name: name, almanakProfileSnapshot: snapshot),
            loading: () => const CircularProgressIndicator().center(),
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
          ),
        ],
      ),
    );
  }
}
