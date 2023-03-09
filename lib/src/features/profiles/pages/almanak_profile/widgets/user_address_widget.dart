import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
import 'package:styled_widget/styled_widget.dart';

class UserAddressWidget extends StatelessWidget {
  const UserAddressWidget({
    Key? key,
    required this.address,
  }) : super(key: key);

  final Address address;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: // icon for address
          const [
        Icon(
          Icons.location_on_outlined,
          color: Colors.lightBlue,
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
      title: Text(
        "${address.street != null ? "${address.street} " : ""}${address.houseNumber != null ? "${address.houseNumber}" : ""}${address.houseNumberAddition != null ? "${address.houseNumberAddition}" : ""}",
      ),
      subtitle: Text(
        "${address.postalCode != null ? "${address.postalCode} " : ""}${address.city != null ? "${address.city}" : ""}",
      ),
    );
  }
}
