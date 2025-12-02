import 'package:flutter/material.dart';

class CoachOrCoxSaveButton extends StatelessWidget {
  const CoachOrCoxSaveButton({
    super.key,
    required this.isSaving,
    required this.enabled,
    required this.onPressed,
  });

  final bool isSaving;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        icon: isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.save),
        label: Text(
          isSaving ? 'Opslaan...' : 'Opslaan',
          style: TextStyle(
            fontSize: 18,
            color: primaryColor, // text uses primary color
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: enabled ? primaryColor.withOpacity(0.1) : null,
          side:
              BorderSide(color: secondaryColor, width: 1), // secondary boundary
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isSaving || !enabled ? null : onPressed,
      ),
    );
  }
}
