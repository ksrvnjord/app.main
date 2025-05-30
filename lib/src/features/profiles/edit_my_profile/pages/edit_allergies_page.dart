// ignore_for_file: avoid-long-functions

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class EditAllergiesPage extends ConsumerWidget {
  const EditAllergiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserStream = ref.watch(currentFirestoreUserStreamProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        // ignore: avoid-non-ascii-symbols
        title: const Text('Mijn allergieën/aversies'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          Card(
            color: colorScheme.errorContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: const EdgeInsets.all(0.0),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(children: [
                Icon(Icons.warning_amber),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    "De KoCo kan niet garanderen dat er geen sporen van allergenen aanwezig zijn in het eten.",
                  ),
                ),
              ]),
            ),
          ).padding(all: 8.0),
          currentUserStream.when(
            data: (snapshot) => buildAllergiesForm(snapshot, context),
            error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        ],
      ),
    );
  }

  Widget buildAllergiesForm(
    QuerySnapshot<FirestoreUser> snapshot,
    BuildContext context,
  ) {
    final doc = snapshot.docs.first;
    final currentUser = doc.data();
    final myAllergies = currentUser.allergies;

    final List<String> allergies = [
      'Vlees',
      'Gluten',
      'Lactose',
      'Noten',
      'Pinda\'s',
      'Schaaldieren',
      'Selderij',
      'Sesam',
      'Soja',
      'Vis',
      'Weekdieren',
      'Koemelk',
      'Peulvruchten',
    ]..sort();

    final String customAllergy =
        // Allergy that is not in the list.
        myAllergies.firstWhere(
      (allergy) => !allergies.contains(allergy),
      orElse: () => '',
    );

    const double otherAllergiesFontSize = 20;
    const double otherAllergiesElementPadding = 8;

    return [
      for (final allergy in allergies)
        CheckboxListTile(
          value: myAllergies.contains(allergy),
          onChanged: (bool? value) => value == null
              ? null
              : updateAllergies(doc, value, allergy, context),
          title: Text(allergy),
        ),
      [
        // Add textfield for adding custom allergies.
        // ignore: avoid-non-ascii-symbols
        const Text('Andere allergieën/aversies:')
            .fontSize(otherAllergiesFontSize),
        TextField(
          controller: TextEditingController()..text = customAllergy,
          decoration: const InputDecoration(
            // ignore: avoid-non-ascii-symbols
            labelText: 'Allergieën',
            hintText: 'Cashewnoten, Tomaten, ...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (String newValue) => updateCustomAllergy(
            doc.reference,
            newValue,
            customAllergy,
            context,
          ),
        ),
      ]
          .toColumn(
            separator: const SizedBox(height: 8),
            crossAxisAlignment: CrossAxisAlignment.start,
          )
          .padding(all: otherAllergiesElementPadding),
    ].toColumn();
  }

  updateAllergies(
    QueryDocumentSnapshot<FirestoreUser> doc,
    bool value,
    String allergy,
    BuildContext context,
  ) {
    doc.reference.update({
      'allergies': value
          ? FieldValue.arrayUnion([allergy])
          : FieldValue.arrayRemove([allergy]),
    });
    // ignore: avoid-ignoring-return-values
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Je keuze is opgeslagen'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void updateCustomAllergy(
    DocumentReference<FirestoreUser> ref,
    String newValue,
    String oldValue,
    BuildContext context,
  ) {
    ref.update({
      'allergies': FieldValue.arrayRemove([oldValue]),
    });
    if (newValue.isNotEmpty) {
      // Only add if not empty.
      ref.update({
        'allergies': FieldValue.arrayUnion([newValue]),
      });
    }

    // ignore: avoid-ignoring-return-values
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Je keuze is opgeslagen'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
