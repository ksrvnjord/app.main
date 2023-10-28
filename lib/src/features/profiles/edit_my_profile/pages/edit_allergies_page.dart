import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class EditAllergiesPage extends ConsumerWidget {
  const EditAllergiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserStream = ref.watch(currentFirestoreUserStreamProvider);

    return Scaffold(
      appBar: AppBar(
        // ignore: avoid-non-ascii-symbols
        title: const Text('Mijn allergiëen & dieetwensen'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
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
    QuerySnapshot<FirestoreAlmanakProfile> snapshot,
    BuildContext context,
  ) {
    final doc = snapshot.docs.first;
    final currentUser = doc.data();
    final myAllergies = currentUser.allergies;

    final List<String> allergies = [
      'Vegetarisch',
      'Gluten',
      'Lactose',
      'Noten',
      'Pinda\'s',
      'Schaaldieren',
      'Selderij',
      'Sesam',
      'Soja',
      'Sulfiet',
      'Vis',
      'Weekdieren',
    ]..sort();

    final String customAllergy = // Allergy that is not in the list.
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
        const Text('Andere allergieën & dieetwensen:')
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
    QueryDocumentSnapshot<FirestoreAlmanakProfile> doc,
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
    DocumentReference<FirestoreAlmanakProfile> ref,
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
