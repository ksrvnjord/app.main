import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/get_blikkenlijst.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/blikkenlijst_item.dart';

class BlikkenLijstTabContent extends ConsumerWidget {
  final AsyncValue<List<QueryDocumentSnapshot<Object?>>> state;
  final String type;

  const BlikkenLijstTabContent(
      {super.key, required this.state, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return state.when(
      data: (docs) {
        if (docs.isEmpty) {
          return const Center(child: Text('Niemand gevonden'));
        } else {
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              if (index >= docs.length - (type == 'regulier' ? 1 : 15)) {
                ref
                    .watch(blikkenLijstProvider.notifier)
                    .fetchMoreBlikkenLijst(type);
              }
              return BlikkenLijstItem(document: docs[index]);
            },
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
