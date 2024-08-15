import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/edit_charity_text_field.dart';

class EditCharityPage extends StatelessWidget {
  const EditCharityPage({super.key});

  Future<void> _saveValues(
    Map<String, TextEditingController> controllers,
    BuildContext context,
  ) async {
    final currentTime = DateTime.now();

    int? pricePerPerson = int.tryParse(controllers['price_per_person']!.text);
    int? currentAmount = int.tryParse(controllers['current_amount']!.text);
    int? goal = int.tryParse(controllers['goal']!.text);

    if (pricePerPerson == null || currentAmount == null || goal == null) {
      // Show an error message to the user.
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vul bij alle velden een geheel getal in!'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('charity')
          .doc('leontienhuis')
          .update({
        'price_per_person': pricePerPerson,
        'current_amount': currentAmount,
        'goal': goal,
        'last_edited': currentTime,
      });

      if (!context.mounted) return;
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wijzigingen opgeslagen'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    Map<String, TextEditingController> controllers = {
      'current_amount': TextEditingController(),
      'goal': TextEditingController(),
      'price_per_person': TextEditingController(),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Bedragen Aanpassen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('charity')
              .doc('leontienhuis')
              .get(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            }
      
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error ?? 'Unknown error'}');
            }
      
            Map<String, dynamic>? charityData =
                snapshot.data?.data() as Map<String, dynamic>?;
      
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EditCharityTextField(
                  name: 'Huidig bedrag',
                  initialValue:
                      charityData?['current_amount']?.toString() ?? '',
                  controller: controllers['current_amount']!,
                ),
                EditCharityTextField(
                  name: 'Doelbedrag',
                  initialValue: charityData?['goal']?.toString() ?? '',
                  controller: controllers['goal']!,
                ),
                EditCharityTextField(
                  name: 'Prijs per persoon',
                  initialValue:
                      charityData?['price_per_person']?.toString() ?? '',
                  controller: controllers['price_per_person']!,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  // ignore: prefer-extracting-callbacks
                  onPressed: () {
                    unawaited(_saveValues(controllers, ctx));
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
