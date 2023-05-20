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
        automaticallyImplyLeading: true,
        title: const Text('Schademelding'),
        actions: [
          damageForm.complete
              ? IconButton(
                  onPressed: () =>
                      editDamage(id, reservationObjectId, damageForm).then(
                    (e) {
                      messenger.showSnackBar(SnackBar(
                        content: const Text('Schademelding aangemaakt'),
                        backgroundColor: Colors.green[900],
                      ));
                      navigator.pop();
                    },
                    onError: (e) {
                      messenger.showSnackBar(SnackBar(
                        content: const Text(
                          'Schademelding kon niet aangemaakt worden',
                        ),
                        backgroundColor: Colors.red[900],
                      ));
                    },
                  ),
                  icon: const Icon(Icons.save),
                )
              : IconButton(
                  onPressed: () => messenger.showSnackBar(SnackBar(
                    content: const Text('Nog niet alle velden zijn ingevuld'),
                    backgroundColor: Colors.red[900],
                  )),
                  icon: Icon(Icons.save, color: Colors.blue[900]),
                ),
          IconButton(
            onPressed: () => deleteDamage(id, reservationObjectId).then(
              (e) {
                messenger.showSnackBar(SnackBar(
                  content: const Text('Schademelding verwijderd'),
                  backgroundColor: Colors.green[900],
                ));
                navigator.pop();
              },
              onError: (e) {
                messenger.showSnackBar(SnackBar(
                  content: const Text(
                    'Schademelding kon niet verwijderd worden',
                  ),
                  backgroundColor: Colors.red[900],
                ));
              },
            ),
            icon: const Icon(Icons.delete),
          ),
        ],
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
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
    );
  }
}
