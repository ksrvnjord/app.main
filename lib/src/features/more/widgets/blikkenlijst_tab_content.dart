import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/blikkenlijst_controller.dart';

class BlikkenLijstTabContent extends ConsumerWidget {
  const BlikkenLijstTabContent({
    super.key,
    required this.state,
    required this.type,
  });

  final AsyncValue<List<QueryDocumentSnapshot<Object?>>> state;
  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const defaultColumnSpacing = 10.0;
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // ignore: avoid-async-call-in-sync-function
        ref.watch(blikkenLijstProvider.notifier).fetchMoreBlikkenLijst(type);
      }
    });

    return state.when(
      data: (docs) {
        return docs.isEmpty
            ? const Center(child: Text('Niemand gevonden'))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Naam')),
                      DataColumn(label: Text('Blikken')),
                      DataColumn(label: Text('Premies')),
                      DataColumn(label: Text('Periode')),
                    ],
                    columnSpacing: defaultColumnSpacing,
                    rows: List<DataRow>.generate(
                      docs.length,
                      (index) => DataRow(cells: [
                        DataCell(
                            Text(docs.elementAtOrNull(index)?['name'] ?? '')),
                        DataCell(
                            Text('${docs.elementAtOrNull(index)?['blikken']}')),
                        DataCell(
                            Text('${docs.elementAtOrNull(index)?['premies']}')),
                        DataCell(Text(docs.elementAtOrNull(index)?['period'])),
                      ]),
                    ),
                  ),
                ),
              );
      },
      error: (error, _) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
