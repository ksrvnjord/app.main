import 'package:flutter/material.dart';

class CoachOrCoxMultiselect extends StatelessWidget {
  const CoachOrCoxMultiselect({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.enabled,
    this.userPermissions = const [],
  });

  final List<String> options;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  final bool enabled;
  final List<String> userPermissions;

  bool _isOptionAllowed(String option) {
    // Only apply special restriction for Cox options
    if (option == 'Gladde 4' &&
        !userPermissions.contains('Stuurpermissie (4)')) {
      return false;
    }
    if (option == '8' && !userPermissions.contains('Stuurpermissie (8)')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voorkeuren',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 8),
            ...options.map((option) {
              final isSelected = selected.contains(option);
              final isAllowed = _isOptionAllowed(option);
              final canSelect = enabled && isAllowed;

              Widget checkboxTile = CheckboxListTile(
                value: isSelected,
                title: Text(
                  option,
                  style: TextStyle(
                    color: canSelect ? null : Colors.grey[400],
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: VisualDensity.compact,
                onChanged: canSelect
                    ? (val) {
                        final newSelected = List<String>.from(selected);
                        if (val == true) {
                          newSelected.add(option);
                        } else {
                          newSelected.remove(option);
                        }
                        onChanged(newSelected);
                      }
                    : null,
              );

              if (!isAllowed) {
                // Wrap restricted options with a tooltip
                checkboxTile = Tooltip(
                  message: 'Haal eerst de bijbehorende stuurpermissie!',
                  child: AbsorbPointer(child: checkboxTile),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(left: 12),
                child: checkboxTile,
              );
            }),
          ],
        ),
      ),
    );
  }
}
