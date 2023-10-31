import 'package:flutter/material.dart';

class RoleDialog extends StatefulWidget {
  const RoleDialog({Key? key}) : super(key: key);

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
