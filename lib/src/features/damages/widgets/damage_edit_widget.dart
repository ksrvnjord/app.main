import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_form_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageEditWidget extends ConsumerWidget {
  final double borderRadius = 12;
  final double padding = 16;
  final String damageDocumentId;
  final String reservationObjectId;

  const DamageEditWidget({
    Key? key,
    required this.damageDocumentId,
    required this.reservationObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final damageForm = ref.watch(damageFormProvider);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schademelding'),
        actions: [
          IconButton(
            onPressed: () => deleteDamageForm(messenger, navigator),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: [
        damageForm.type != null
            ? DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    value: damageForm.type,
                    child: Text(damageForm.type ?? ''),
                  ),
                ],
                value: damageForm.type,
                onChanged: null,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              )
            : Container(),
        damageForm.type != null
            ? DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    value: damageForm.name,
                    child: Text(damageForm.name ?? ''),
                  ),
                ],
                value: damageForm.name,
                onChanged: null,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              )
            : Container(),
        const DamageFormWidget(),
      ]
          .toWrap(runSpacing: padding)
          .padding(all: padding)
          .scrollable(scrollDirection: Axis.vertical),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => damageForm.complete
            ? editDamageForm(damageForm, messenger, navigator)
            : messenger.showSnackBar(SnackBar(
                content: const Text('Nog niet alle velden zijn ingevuld'),
                backgroundColor: Colors.red[900],
              )),
        icon: const Icon(Icons.save),
        label: const Text('Opslaan'),
      ),
    );
  }

  Future<void> deleteDamageForm(
    ScaffoldMessengerState messenger,
    Routemaster navigator,
  ) async {
    try {
      await Damage.deleteById(damageDocumentId, reservationObjectId);
      // ignore: avoid-ignoring-return-values
      messenger.showSnackBar(const SnackBar(
        content: Text('Schademelding verwijderd'),
      ));
      // ignore: avoid-ignoring-return-values
      navigator.pop();
    } catch (e) {
      // ignore: avoid-ignoring-return-values
      messenger.showSnackBar(const SnackBar(
        content: Text(
          'Schademelding kon niet verwijderd worden',
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> editDamageForm(
    DamageForm damageForm,
    ScaffoldMessengerState messenger,
    Routemaster navigator,
  ) async {
    try {
      await Damage.edit(
        damageDocumentId,
        reservationObjectId,
        damageForm,
      );
      // ignore: avoid-ignoring-return-values
      messenger.showSnackBar(SnackBar(
        content: const Text('Schademelding aangemaakt'),
        backgroundColor: Colors.green[900],
      ));
    } catch (e) {
      // ignore: avoid-ignoring-return-values
      messenger.showSnackBar(SnackBar(
        content: const Text(
          'Schademelding kon niet aangemaakt worden',
        ),
        backgroundColor: Colors.red[900],
      ));
    }

    // ignore: avoid-ignoring-return-values
    navigator.pop();
  }
}
