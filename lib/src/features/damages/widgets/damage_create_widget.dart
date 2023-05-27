import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
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
        title: const Text('Schade melden'),
      ),
      body: <Widget>[
        const DamageSelectWidget(),
        FutureWrapper(
          future: objectByTypeAndName(
            formData.type ?? "",
            formData.name ?? "",
          ),
          success: (data) =>
              data.isNotEmpty ? const DamageFormWidget() : Container(),
        ),
      ]
          .toWrap(runSpacing: padding)
          .scrollable(scrollDirection: Axis.vertical)
          .padding(all: padding),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => formData.complete
            ? createNewDamage(context, formData, messenger, navigator)
            : messenger.showSnackBar(SnackBar(
                content: Text(
                  'Nog niet alle velden zijn ingevuld',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              )),
        icon: const Icon(Icons.send),
        label: const Text('Schade melden'),
      ),
    );
  }

  Future<void> createNewDamage(
    BuildContext context,
    DamageForm formData,
    ScaffoldMessengerState messenger,
    Routemaster navigator,
  ) async {
    try {
      await Damage.create(formData);
      // ignore: avoid-ignoring-return-values
      messenger.showSnackBar(const SnackBar(
        content: Text('Schademelding aangemaakt'),
      ));
    } catch (err) {
      // ignore: avoid-ignoring-return-values
      messenger.showSnackBar(SnackBar(
        content: const Text(
          'Schademelding kon niet aangemaakt worden',
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ));
    }

    // ignore: avoid-ignoring-return-values
    navigator.pop();
  }
}
