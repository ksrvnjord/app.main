import 'package:flutter/material.dart';

class CoachOrCoxSingleQuestion extends StatelessWidget {
  const CoachOrCoxSingleQuestion({
    super.key,
    required this.value,
    required this.onChanged,
    required this.role,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ik wil zichtbaar zijn als $role in de app.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
