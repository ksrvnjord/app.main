import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/commissie_info_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:routemaster/routemaster.dart';

class SelectCommissiePage extends ConsumerWidget {
  const SelectCommissiePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commissiesVal = ref.watch(commissieNamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecteer commissie'),
      ),
      body: commissiesVal.when(
        data: (commissies) => ListView(
          children: commissies
              .map(
                (commissie) => ListTile(
                  title: Text(commissie),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.goNamed(
                    'Fill Commissie Info',
                    queryParameters: {'commissie': commissie},
                  ),
                ),
              )
              .toList(),
        ),
        error: (err, stk) => ErrorCardWidget(
          errorMessage: err.toString(),
          stackTrace: stk,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
