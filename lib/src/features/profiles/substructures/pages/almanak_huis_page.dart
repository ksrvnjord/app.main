import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/widgets/user_address_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/home_users.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/huis_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/leeden_list.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/substructure_description_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

import '../api/huis_info_provider.dart';
import '../widgets/almanak_substructure_cover_picture.dart';

class AlmanakHuisPage extends ConsumerWidget {
  const AlmanakHuisPage({
    super.key,
    required this.houseName,
  });

  final String houseName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final huisInfo = ref.watch(huisInfoProvider(houseName)); //
    const double pageHPadding = 12;
    const double descriptionHPadding = pageHPadding + 4;

    final users = ref.watch(homeUsers(houseName));

    return Scaffold(
      appBar: AppBar(
        title: Text(houseName),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          huisInfo.when(
            data: (huisInfo) {
              if (huisInfo.size == 0) {
                return const SizedBox.shrink();
              }

              final huis = huisInfo.docs.first.data();

              return [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: AlmanakSubstructureCoverPicture(
                    imageProvider: ref.watch(huisPictureProvider(
                      Tuple2<String, int>(
                        houseName,
                        getNjordYear(),
                      ),
                    )),
                  ),
                ).padding(horizontal: pageHPadding),
                SubstructureDescriptionWidget(
                  descriptionAsyncVal:
                      ref.watch(huisDescriptionProvider(houseName)),
                ).padding(all: descriptionHPadding),
                UserAddressWidget(
                  address: Address(
                    street: huis.streetName,
                    houseNumber: huis.houseNumber,
                  ),
                ),
                DataTextListTile(
                  name: "Aantal huisgenoten",
                  value:
                      "${huis.numberOfHousemates.toString()} (${huis.composition.value}, ${huis.allNjord ? "volledig Njord" : "Njord/Niet-Njord"})",
                ),
                DataTextListTile(
                  name: "Jaar van oprichting",
                  value: huis.yearOfFoundation.toString(),
                ),
              ].toColumn();
            },
            loading: () => const CircularProgressIndicator.adaptive().center(),
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
          ),
          users.when(
            data: (snapshot) =>
                LeedenList(name: houseName, almanakProfileSnapshot: snapshot),
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
