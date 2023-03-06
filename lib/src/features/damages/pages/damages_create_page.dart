import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/mutations/new_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/object_by_type_and_name.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_form_widget.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_select_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/queries/get_reservation_object.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:routemaster/routemaster.dart';

class _DamagesCreateForm extends StatelessWidget {
  final double padding = 16;

  const _DamagesCreateForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formData = context.watch<DamageForm>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schade melden'),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
        actions: [
          formData.complete
              ? IconButton(
                  onPressed: () => newDamage(formData).then(
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
                  icon: const Icon(Icons.send),
                )
              : IconButton(
                  onPressed: () => messenger.showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red[900],
                      content: const Text('Nog niet alle velden zijn ingevuld'),
                    ),
                  ),
                  icon: Icon(Icons.send, color: Colors.blue[900]),
                ),
        ],
      ),
      body: <Widget>[
        const DamageSelectWidget(),
        (formData.type != null && formData.name != null)
            ? FutureWrapper(
                future: objectByTypeAndName(
                  formData.type!,
                  formData.name!,
                ),
                success: (data) =>
                    data.isNotEmpty ? const DamageFormWidget() : Container(),
              )
            : const Text('Selecteer een object...'),
      ]
          .toWrap(runSpacing: padding)
          .scrollable(scrollDirection: Axis.vertical)
          .padding(all: padding),
    );
  }
}

class DamagesCreatePage extends StatelessWidget {
  final String? reservationObjectId;

  const DamagesCreatePage({
    Key? key,
    this.reservationObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (reservationObjectId == null) {
      return Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => DamageForm(),
          child: const _DamagesCreateForm(),
        ),
      );
    }

    return Scaffold(
      body: FutureWrapper(
        future: getReservationObject(reservationObjectId!),
        success: (data) => ChangeNotifierProvider(
          create: (_) => data.exists
              ? DamageForm(
                  type: data.data()!.type,
                  name: data.data()!.name,
                )
              : DamageForm(),
          child: const _DamagesCreateForm(),
        ),
      ),
    );
  }
}
