import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/mutations/delete_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/mutations/edit_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_form_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageEditWidget extends ConsumerWidget {
  final double borderRadius = 12;
  final double padding = 16;
  final String id;
  final String reservationObjectId;

  const DamageEditWidget({
    Key? key,
    required this.id,
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
        automaticallyImplyLeading: true,
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
        actions: [
          damageForm.complete
              ? IconButton(
                  onPressed: () =>
                      editDamage(id, reservationObjectId, damageForm).then(
                    (e) {
                      messenger.showSnackBar(SnackBar(
                        backgroundColor: Colors.green[900],
                        content: const Text('Schademelding aangemaakt'),
                      ));
                      navigator.pop();
                    },
                    onError: (e) {
                      messenger.showSnackBar(SnackBar(
                        backgroundColor: Colors.red[900],
                        content: const Text(
                          'Schademelding kon niet aangemaakt worden',
                        ),
                      ));
                    },
                  ),
                  icon: const Icon(Icons.save),
                )
              : IconButton(
                  onPressed: () => messenger.showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red[900],
                      content: const Text('Nog niet alle velden zijn ingevuld'),
                    ),
                  ),
                  icon: Icon(Icons.save, color: Colors.blue[900]),
                ),
          IconButton(
            onPressed: () => deleteDamage(id, reservationObjectId).then(
              (e) {
                messenger.showSnackBar(SnackBar(
                  backgroundColor: Colors.green[900],
                  content: const Text('Schademelding verwijderd'),
                ));
                navigator.pop();
              },
              onError: (e) {
                messenger.showSnackBar(SnackBar(
                  backgroundColor: Colors.red[900],
                  content: const Text(
                    'Schademelding kon niet verwijderd worden',
                  ),
                ));
              },
            ),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: [
        damageForm.type != null
            ? DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: damageForm.type,
                items: [
                  DropdownMenuItem(
                    value: damageForm.type,
                    child: Text(damageForm.type ?? ''),
                  ),
                ],
                onChanged: null,
              )
            : Container(),
        damageForm.type != null
            ? DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: damageForm.name,
                items: [
                  DropdownMenuItem(
                    value: damageForm.name,
                    child: Text(damageForm.name ?? ''),
                  ),
                ],
                onChanged: null,
              )
            : Container(),
        const DamageFormWidget(),
      ]
          .toWrap(runSpacing: padding)
          .padding(all: padding)
          .scrollable(scrollDirection: Axis.vertical),
    );
  }
}
