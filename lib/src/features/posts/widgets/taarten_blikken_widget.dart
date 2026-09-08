import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaartenBlikkenWidget extends StatelessWidget {
  const TaartenBlikkenWidget({
    super.key,
    this.documentPath = 'wins/wincounter',
    this.blikkenField = 'blikken',
    this.taartenField = 'taarten',
  });

  final String documentPath;
  final String blikkenField;
  final String taartenField;

  int _readCount(Map<String, dynamic>? data, String fieldName) {
    final value = data?[fieldName];
    if (value is num) {
      return value.toInt();
    }

    return 0;
  }

  Widget _buildCounter(
    BuildContext context, {
    required IconData icon,
    required int count,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            count.toString(),
            style: textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.doc(documentPath).snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final blikkenCount = _readCount(data, blikkenField);
        final taartenCount = _readCount(data, taartenField);

        return Card(
          color: colorScheme.secondaryContainer,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildCounter(
                  context,
                  icon: Icons.military_tech,
                  count: blikkenCount,
                  label: 'Blikkencounter $blikkenCount',
                ),
                const Spacer(),
                _buildCounter(
                  context,
                  icon: Icons.cake,
                  count: taartenCount,
                  label: 'Taartencounter $taartenCount',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
