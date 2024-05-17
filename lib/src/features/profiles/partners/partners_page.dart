import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/partners/partners_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class PartnersPage extends ConsumerWidget {
  const PartnersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partnersVal = ref.watch(partnersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Partners & Sponsors")),
      body: partnersVal.when(
        data: (snapshot) {
          if (snapshot.docs.isEmpty) {
            return const Center(child: Text("No partners found"));
          }

          final docs = snapshot.docs;
          // Divide the docs over two lists.
          final firstHalf = docs.sublist(0, docs.length ~/ 2);
          final secondHalf = docs.sublist(docs.length ~/ 2);

          return ListView(
            children: [
              [
                for (final half in [firstHalf, secondHalf])
                  half
                      .map((doc) => doc.data())
                      .map((partner) => Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Image.network(
                              partner.logoUrl,
                              fit: BoxFit.cover,
                            ),
                          ))
                      .toList()
                      .toColumn(separator: const SizedBox(height: 2))
                      .expanded(),
              ].toRow(
                crossAxisAlignment: CrossAxisAlignment.start,
                separator: const SizedBox(width: 2),
              ),
            ],
          );
        },
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () => const CircularProgressIndicator.adaptive().center(),
      ),
    );
  }
}
