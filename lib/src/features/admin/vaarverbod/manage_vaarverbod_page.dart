import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/vaarverbod/vaarverbod_form_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/vaarverbod_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class ManageVaarverbodPage extends ConsumerWidget {
  const ManageVaarverbodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beheer Vaarverbod')),
      body: ref.watch(vaarverbodProvider).when(
            data: (data) => VaarverbodFormWidget(
              status: data.status,
              message: data.message,
            ),
            error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
            loading: () => const CircularProgressIndicator.adaptive().center(),
          ),
    );
  }
}
