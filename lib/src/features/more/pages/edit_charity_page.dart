import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/lustrum_background_widget.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/edit_charity_text_field.dart';

class EditCharityPage extends StatelessWidget {
  const EditCharityPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const pageOffset = 0.0;

    Map<String, TextEditingController> controllers = {
      'current_amount': TextEditingController(),
      'goal': TextEditingController(),
      'price_per_person': TextEditingController(),
    };

    Future<void> saveValues() async {
      final currentTime = DateTime.now();

      int? pricePerPerson = int.tryParse(controllers['price_per_person']!.text);
      int? currentAmount = int.tryParse(controllers['current_amount']!.text);
      int? goal = int.tryParse(controllers['goal']!.text);

      if (pricePerPerson == null || currentAmount == null || goal == null) {
        // Show an error message to the user
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wijzigingen opgeslagen'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bedragen Aanpassen'),
      ),
      body: CustomPaint(
        painter: LustrumBackgroundWidget(
          screenSize: MediaQuery.of(context).size,
          pageOffset: pageOffset,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('charity')
                .doc('leontienhuis')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
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
                    onPressed: () => saveValues(),
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
