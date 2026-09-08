import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WincounterWidget extends StatelessWidget {
  const WincounterWidget({
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
    required String semanticsLabel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: semanticsLabel,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: colorScheme.primary,
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

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildCounter(
                context,
                icon: Icons.workspace_premium,
                count: blikkenCount,
                semanticsLabel: 'Blikkencounter $blikkenCount',
              ),
              const Spacer(),
              _buildCounter(
                context,
                icon: Icons.cake,
                count: taartenCount,
                semanticsLabel: 'Taartencounter $taartenCount',
              ),
            ],
          ),
        );
      },
    );
  }
}
