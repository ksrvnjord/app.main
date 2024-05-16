import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/get_blikkenlijst.dart';

class BlikkenLijstTabContent extends ConsumerWidget {
  final AsyncValue<List<QueryDocumentSnapshot<Object?>>> state;
  final String type;

  const BlikkenLijstTabContent(
      {super.key, required this.state, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        ref.watch(blikkenLijstProvider.notifier).fetchMoreBlikkenLijst(type);
      }
    });

    return state.when(
      data: (docs) {
        if (docs.isEmpty) {
          return const Center(child: Text('Niemand gevonden'));
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: scrollController,
              child: DataTable(
                columnSpacing: 10, // Adjust this value to your needs
                columns: const <DataColumn>[
                  DataColumn(label: Text('Naam')),
                  DataColumn(label: Text('Blikken')),
                  DataColumn(label: Text('Premies')),
                  DataColumn(label: Text('Periode')),
                ],
                rows: List<DataRow>.generate(
                  docs.length,
                  (index) => DataRow(
                    cells: <DataCell>[
                      DataCell(Text(docs[index]['name'])),
                      DataCell(Text('${docs[index]['blikken']}')),
                      DataCell(Text('${docs[index]['premies']}')),
                      DataCell(Text(docs[index]['period'])),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
