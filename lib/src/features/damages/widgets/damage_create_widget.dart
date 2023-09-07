import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/object_by_type_and_name.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_form_widget.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_select_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/providers/progress_notifier.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageCreateWidget extends ConsumerStatefulWidget {
  const DamageCreateWidget({
    Key? key,
  }) : super(key: key);

  @override
  createState() => _DamageCreateWidgetState();
}

class _DamageCreateWidgetState extends ConsumerState<DamageCreateWidget> {
  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(damageFormProvider);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);

    final formSendInProgress = ref.watch(progressProvider);
    const double padding = 16;

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
        onPressed: formSendInProgress
            ? null
            : () => formData.complete
                ? createNewDamage(context, formData, messenger, navigator)
                : messenger.showSnackBar(SnackBar(
                    content: Text(
                      'Nog niet alle velden zijn ingevuld',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                  )),
        icon: const Icon(Icons.send),
        label: formSendInProgress
            ? const Text("Verzenden...")
            : const Text('Schade melden'),
      ),
    );
  }

  Future<void> createNewDamage(
    BuildContext context,
    DamageForm formData,
    ScaffoldMessengerState messenger,
    Routemaster navigator,
  ) async {
    ref.read(progressProvider.notifier).inProgress();
    try {
      await Damage.create(formData);
      // ignore: avoid-ignoring-return-values
      messenger.showSnackBar(const SnackBar(
        content: Text('Schademelding aangemaakt'),
      ));
      ref.read(progressProvider.notifier).done();
      // ignore: avoid-ignoring-return-values
      navigator.pop();
    } catch (err) {
      // ignore: avoid-ignoring-return-values
      messenger.showSnackBar(SnackBar(
        content: const Text(
          'Schademelding kon niet aangemaakt worden',
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ));
    }
  }
}
