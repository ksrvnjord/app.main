import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/mutations/new_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/object_by_type_and_name.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_form_widget.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_select_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageCreateWidget extends ConsumerWidget {
  final double padding = 16;

  const DamageCreateWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(damageFormProvider);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Schade melden'),
        actions: [
          formData.complete
              ? IconButton(
                  onPressed: () =>
                      createNewDamage(formData, messenger, navigator),
                  icon: const Icon(Icons.send),
                )
              : IconButton(
                  onPressed: () => messenger.showSnackBar(SnackBar(
                    content: const Text('Nog niet alle velden zijn ingevuld'),
                    backgroundColor: Colors.red[900],
                  )),
                  icon: Icon(Icons.send, color: Colors.blue[900]),
                ),
        ],
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
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

  Future<void> createNewDamage(
    DamageForm formData,
    ScaffoldMessengerState messenger,
    Routemaster navigator,
  ) async {
    try {
      await newDamage(formData);
      // ignore: avoid-ignoring-return-values
      messenger.showSnackBar(SnackBar(
        content: const Text('Schademelding aangemaakt'),
        backgroundColor: Colors.green[900],
      ));
    } catch (err) {
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
