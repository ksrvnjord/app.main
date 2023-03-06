import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/mutations/edit_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/mutations/delete_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/get_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_form_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class _DamagesEditPage extends StatelessWidget {
  final double borderRadius = 12;
  final double padding = 16;
  final String id;
  final String reservationObjectId;

  const _DamagesEditPage({
    Key? key,
    required this.id,
    required this.reservationObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final damage = context.watch<DamageForm>();
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
          damage.complete
              ? IconButton(
                  onPressed: () =>
                      editDamage(id, reservationObjectId, damage).then(
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
        damage.type != null
            ? DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: damage.type,
                items: [
                  DropdownMenuItem(
                    value: damage.type,
                    child: Text(damage.type ?? ''),
                  ),
                ],
                onChanged: null,
              )
            : Container(),
        damage.type != null
            ? DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: damage.name,
                items: [
                  DropdownMenuItem(
                    value: damage.name,
                    child: Text(damage.name ?? ''),
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

class DamagesEditPage extends StatelessWidget {
  final String id;
  final String reservationObjectId;

  const DamagesEditPage({
    Key? key,
    required this.id,
    required this.reservationObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: getDamage(
        reservationObjectId,
        id,
      ),
      success: (data) => data.exists
          ? ChangeNotifierProvider(
              create: (_) => DamageForm(
                type: data.data()!.type,
                name: data.data()!.name,
                description: data.data()!.description,
                critical: data.data()!.critical,
              ),
              child: _DamagesEditPage(
                id: id,
                reservationObjectId: reservationObjectId,
              ),
            )
          : Container(),
    );
  }
}
