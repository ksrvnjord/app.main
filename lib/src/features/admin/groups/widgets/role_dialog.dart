import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_type.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class RoleDialog extends StatefulWidget {
  const RoleDialog({
    Key? key,
    required this.groupType,
  }) : super(key: key);

  final GroupType groupType;

  @override
  State<RoleDialog> createState() => _RoleDialogState();
}

class _RoleDialogState extends State<RoleDialog> {
  String? dropdownValue;
  final customRoleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // This is the groupType that is passed to the dialog.
    return AlertDialog(
      title: const Text('Selecteer een rol'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Selecteer een rol voor de gebruiker.',
          ),
          const SizedBox(height: 16),
          if (widget.groupType == GroupType.commissie) ...[
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
          ] else if (widget.groupType == GroupType.competitieploeg ||
              widget.groupType == GroupType.wedstrijdsectie) ...[
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
          ] else if (widget.groupType == GroupType.bestuur) ...[
            DropdownButtonFormField<String>(
              items: [
                for (String role in [
                  "Praeses",
                  "Ab-actis en Commissaris voor Oud-Njord",
                  "Quaestor",
                  "Commissaris voor het Wedstrijdroeien",
                  "Commissaris van het Materieel",
                  "Commissaris van de Gebouwen",
                  "Commissaris van het Buffet",
                  "Commissaris voor het Competitie- en Fuifroeien",
                  "Commissaris voor Externe Betrekkingen",
                ])
                  DropdownMenuItem(
                    value: role,
                    child: Text(role, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (value) => setState(() {
                dropdownValue = value;
              }),
              isExpanded: true,
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
