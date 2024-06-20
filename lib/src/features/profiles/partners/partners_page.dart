import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        // ignore: avoid-long-functions
        data: (snapshot) {
          if (snapshot.docs.isEmpty) {
            return const Center(child: Text("No partners found"));
          }

          final docs = snapshot.docs;
          final shuffled = docs..shuffle();
          // Divide the docs over two lists.
          final firstHalf = shuffled.sublist(0, shuffled.length ~/ 2);
          final secondHalf = shuffled.sublist(shuffled.length ~/ 2);

          const dividerDim = 2.0;

          return ListView(
            // Own implementation of staggered grid view, not very efficient.
            children: [
              IntrinsicHeight(
                // Needed to layout the vertical divider.
                child: [
                  for (final half in [firstHalf, secondHalf])
                    [
                      for (final partner in half)
                        InkWell(
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Image.network(
                              partner.data().logoUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          onTap: () => context.goNamed(
                            "Partner Details",
                            pathParameters: {"partnerId": partner.id},
                          ),
                        ),
                    ]
                        .toList()
                        .toColumn(
                          separator: Divider(
                            height: dividerDim,
                            // ignore: no-equal-arguments
                            thickness: dividerDim,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        )
                        .expanded(),
                ].toRow(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  separator: VerticalDivider(
                    width: dividerDim,
                    // ignore: no-equal-arguments
                    thickness: dividerDim,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
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
