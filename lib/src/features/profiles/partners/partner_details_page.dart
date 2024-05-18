import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/partners/partner_provider.dart';
import 'package:styled_widget/styled_widget.dart';

class PartnerDetailsPage extends ConsumerWidget {
  const PartnerDetailsPage({super.key, required this.partnerId});

  final String partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncVal = ref.watch(partnerProvider(partnerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Sponsor / Partner')),
      body: asyncVal.when(
        data: (snapshot) {
          final partner = snapshot.data();

          final description = partner?.description;

          return partner == null
              ? const Center(child: Text('Geen partner/sponsor gevonden'))
              : ListView(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Image.network(
                          partner.logoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      partner.name,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    if (description != null) Text(description),
                  ],
                );
        },
        error: (err, stk) => Text(err.toString()),
        loading: () => const CircularProgressIndicator.adaptive().center(),
      ),
    );
  }
}
