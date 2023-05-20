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
    return address.street != null &&
            address.street!
                .isNotEmpty // it makes no sense to show an address without a street
        ? ListTile(
            leading: const [
              Icon(
                Icons.location_on_outlined,
                size: 32,
                color: Colors.lightBlue,
              ),
            ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
            title: Text(
              "${address.street != null ? "${address.street} " : ""}${address.houseNumber != null ? "${address.houseNumber}" : ""}${address.houseNumberAddition != null ? "${address.houseNumberAddition}" : ""}",
            ),
            subtitle:
                // if postalcode and city are null, don't show anything
                address.postalCode != null &&
                        address.city != null &&
                        address.city!.isNotEmpty
                    ? Text(
                        "${address.postalCode != null ? "${address.postalCode} " : ""}${address.city != null ? "${address.city}" : ""}",
                      )
                    : null,
          )
        : const SizedBox.shrink();
  }
}
