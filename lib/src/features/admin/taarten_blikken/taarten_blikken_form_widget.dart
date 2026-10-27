import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class TaartenBlikkenCounters extends StatelessWidget {
  const TaartenBlikkenCounters({super.key});

  static final _doc = FirebaseFirestore.instance.doc('wins/wincounter');

  Future<void> _change(BuildContext context, String field, int delta) async {
    try {
      // Enforce the creation of the doc
      await _doc.set(
        {field: FieldValue.increment(delta)},
        SetOptions(merge: true),
      );
    } catch (error) {
      debugPrint('Error updating $field: $error');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Er is een fout opgetreden bij het wijzigen van de teller.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _doc.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorCardWidget(errorMessage: snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final data = snapshot.data!.data();
        int count(String field) => (data?[field] as num?)?.toInt() ?? 0;

        Widget tile(String field, String label, IconData icon) => ListTile(
              leading: Icon(icon),
              title: Text(label),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: count(field) > 0
                        ? () => _change(context, field, -1)
                        : null,
                  ),
                  Text('${count(field)}',
                      style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _change(context, field, 1),
                  ),
                ],
              ),
            );

        return ListView(
          children: [
            tile('blikken', 'Blikken', Icons.military_tech),
            tile('taarten', 'Taarten', Icons.cake),
          ],
        );
      },
    );
  }
}
