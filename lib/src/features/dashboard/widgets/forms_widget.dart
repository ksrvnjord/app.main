import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsWidget extends ConsumerWidget {
  const FormsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return [
      [
        const Text(
          "Forms",
        )
            .fontSize(16)
            .fontWeight(FontWeight.w300)
            .textColor(Colors.blueGrey)
            .alignment(Alignment.center),
        GestureDetector(
          onTap: () => Routemaster.of(context).push('polls'),
          child: [
            const Text("Meer").textColor(Colors.blueGrey),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.blueGrey,
            ),
          ].toRow(
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ).alignment(Alignment.centerRight),
      ].toStack(),
      // TODO: show latest three forms
      ExpansionTile(
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.blueGrey, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        initiallyExpanded: true,
        title: const Text("Zin in de Varsity?"),
        subtitle: const Text("Sluit op 1 oktober 2021 om 23:59")
            .textColor(Colors.grey),
        children: [
          const Text("De varsity is de mooiste studentenroeiwedstrijd!")
              .textColor(Colors.blueGrey),
          RadioListTile(
            value: "Ja",
            title: const Text("Ja"),
            groupValue: null,
            onChanged: (_) => null,
          ),
          RadioListTile(
            value: "Natuurlijk",
            title: const Text("Natuurlijk"),
            groupValue: null,
            onChanged: (_) => null,
          )
        ],
      ),
    ].toColumn();
  }
}
