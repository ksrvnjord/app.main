import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/form_page.dart';

class DeclarationsPage extends StatelessWidget {
  const DeclarationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Declaraties'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nieuwe declaratie card
            Card(
              elevation: 0, // no shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: colorScheme.secondary, // outline color
                ),
              ),
              child: ListTile(
                title: const Text('Nieuwe declaratie'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const FormPage(formId: '953ZWfMA56RMLgkxV07D'),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32), // space between sections

            // Declaratiegeschiedenis section
            const Text(
              'Declaratiegeschiedenis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8), // small spacing before content

            // Placeholder content
            const Text('Hier komt later de lijst met eerdere declaraties.'),
          ],
        ),
      ),
    );
  }
}
