import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/partners/partners_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

final selectedPartnerTypeProvider = StateProvider<String>((ref) => 'Vaste partners');

class PartnersPage extends ConsumerWidget {
  const PartnersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partnersVal = ref.watch(partnersProvider);
    final selectedPartnerType = ref.watch(selectedPartnerTypeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Kies een Partners & Sponsors type")),
      body: partnersVal.when(
        // ignore: avoid-long-functions
        data: (snapshot) {
          if (snapshot.docs.isEmpty) {
            return const Center(child: Text("No partners found"));
          }

          final docs = snapshot.docs;
          final partnerList = [for (final partners in docs) partners];

          return ListView(
            children: [Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [                      
                      for (final type in ['Vaste partners', 'Leedendeals'])
                        // for (final partner in docs)
                          ChoiceChip(label:Text(type),
                          onSelected: (selected) {if (!selected) return;
                          ref.read(selectedPartnerTypeProvider.notifier).state = type; context.goNamed(
                            'Partners',
                            queryParameters: {
                            'type': type,
                              },
                            );},
                            selected: type == selectedPartnerType, //partner.data().type,
                          ),],),
                    for (final partner in partnerList.where((p) => p.data().type == selectedPartnerType))
                      ListTile(
                            title: Text(partner.data().name ?? 'Onbekende partner'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.goNamed(
                              'Partner Details',
                              pathParameters: {"partnerId": partner.id},
                            ), shape: Border(bottom: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 0.2,
                            )),
                          ),]                
          );
        },
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () => const CircularProgressIndicator.adaptive().center(),
      ),
    );
  }
}
