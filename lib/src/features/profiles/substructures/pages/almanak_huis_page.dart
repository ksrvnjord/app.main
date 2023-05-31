import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/widgets/user_address_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/home_users.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/leeden_list.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/substructure_description_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

import '../api/huis_info_provider.dart';

class AlmanakHuisPage extends ConsumerWidget {
  const AlmanakHuisPage({
    Key? key,
    required this.houseName,
  }) : super(key: key);

  final String houseName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final huisInfo = ref.watch(huisInfoProvider(houseName)); //
    const double pageHPadding = 12;

    final users = ref.watch(homeUsers(houseName));

    return Scaffold(
      appBar: AppBar(
        title: Text(houseName),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          huisInfo.when(
            data: (huisInfo) => [
              // TODO: insert image
              UserAddressWidget(
                address: Address(
                  street: huisInfo.streetName,
                  houseNumber: huisInfo.houseNumber,
                ),
              ),
              SubstructureDescriptionWidget(
                // TODO: maybe add a header to this widget
                descriptionAsyncVal:
                    ref.watch(huisDescriptionProvider(houseName)),
              ).padding(horizontal: pageHPadding),
              DataTextListTile(
                name: "Aantal huisgenoten",
                value:
                    "${huisInfo.numberOfHousemates.toString()} (${huisInfo.composition.value})",
              ),
              DataTextListTile(
                name: "Iedereen is (oud) lid van Njord",
                value: huisInfo.allNjord ? "Ja" : "Nee",
              ),
              DataTextListTile(
                name: "Jaar van oprichting",
                value: huisInfo.yearOfFoundation.toString(),
              ),
            ].toColumn(),
            loading: () => const CircularProgressIndicator().center(),
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
          ),
          users.when(
            data: (snapshot) =>
                LeedenList(name: houseName, almanakProfileSnapshot: snapshot),
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
