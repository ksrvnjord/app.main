import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class RoleDialog extends StatefulWidget {
  const RoleDialog({
    Key? key,
    required this.groupType,
  }) : super(key: key);

  final String groupType;

  @override
  State<RoleDialog> createState() => _RoleDialogState();
}

class _RoleDialogState extends State<RoleDialog> {
  String? dropdownValue;
  final customRoleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecteer een rol'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Selecteer een rol voor de gebruiker.',
          ),
          const SizedBox(height: 16),
          if (widget.groupType == 'commissie') ...[
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'Praeses', child: Text('Praeses')),
                DropdownMenuItem(value: 'Ab-actis', child: Text('Ab-actis')),
                DropdownMenuItem(value: null, child: Text('Geen')),
                DropdownMenuItem(value: 'Anders', child: Text('Anders')),
              ],
              onChanged: (value) => setState(() {
                dropdownValue = value;
              }),
              decoration: const InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(),
              ),
            ),
          ] else if (widget.groupType == 'competitieploeg' ||
              widget.groupType == 'wedstrijdploeg') ...[
            DropdownButtonFormField<String>(
              items: [
                for (String role in ["Roeier", "Coach", "Stuur", "Anders"])
                  DropdownMenuItem(value: role, child: Text(role)),
              ],
              onChanged: (value) => setState(() {
                dropdownValue = value;
              }),
              decoration: const InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(),
              ),
            ),
          ] else ...[
            ErrorCardWidget(
              errorMessage: 'Onbekend groepstype ${widget.groupType}',
            ),
          ],
          if (dropdownValue == 'Anders')
            TextField(
              controller: customRoleController,
              decoration: const InputDecoration(
                labelText: 'Andere Rol',
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuleren'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            dropdownValue == 'Anders'
                ? customRoleController.text
                : dropdownValue,
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }
}