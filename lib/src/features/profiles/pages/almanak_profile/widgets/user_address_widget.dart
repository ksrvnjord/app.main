import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';

class UserAddressWidget extends StatelessWidget {
  const UserAddressWidget({
    Key? key,
    required this.address,
  }) : super(key: key);

  final Address address;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (address.street != null && address.street!.isNotEmpty)
          DataTextListTile(
            name: "Adres",
            value: // Showing house number(addition) only makes sense if street is not empty
                """${address.street!} ${address.houseNumber != null && address.houseNumber!.isNotEmpty ? address.houseNumber! : ""} ${address.houseNumberAddition != null && address.houseNumberAddition!.isNotEmpty ? address.houseNumberAddition! : ""}""",
          ),
        if (address.postalCode != null && address.postalCode!.isNotEmpty)
          DataTextListTile(name: "Postcode", value: address.postalCode!),
        if (address.city != null && address.city!.isNotEmpty)
          DataTextListTile(name: "Stad", value: address.city!),
      ],
    );
  }
}
