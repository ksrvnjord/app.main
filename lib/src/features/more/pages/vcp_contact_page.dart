import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/model/contactpersoon_info.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/contactpersoon_info_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class VCPPage extends ConsumerWidget {
  const VCPPage({super.key});

  Widget _buildInfo(String title, String? content) {
    if (content == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            content,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 4.0,
          )
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, MeldpersooncontactInfo info) {
    return ExpansionTile(
      title: Row(
        children: [
          Expanded(
            child: Text(info.name),
          ),
        if (info.email != null && info.email!.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.email_outlined),
            tooltip: "Email",
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (context) => Consumer(
                  builder: (context, ref, _) {
                    final vertrouwensPersoonInfo = ref.watch(vertrouwenscontactpersonenInfoProvider);
                    return AlertDialog(
                      content: vertrouwensPersoonInfo.when(
                        data: (vcp) => Column(
                          children: [
                            Text("Email")
                          ],
                        ),
                        error: (error, stackTrace) => ErrorCardWidget(
                          errorMessage: error.toString(),
                          stackTrace: stackTrace,
                        ),
                        loading: () =>
                          LoadingWidget(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(), 
                          child: const Text("Ok"),
                        )
                      ],
                    );
                  }
                ),
              );
              //launchUrl(Uri.parse('mailto:${info.email}'));
            },
          )
        ],
      ),
      children: [
        Column(
          children: [
            if (info.lidnummer != null) ...[
              AlmanakUserTile(
                firstName: "",
                lastName: "",
                lidnummer: info.lidnummer!,
              ),
            ],
            _buildInfo('Wie', info.wie),
            _buildInfo('Wanneer', info.wanneer),
            _buildInfo('Waarvoor', info.waarvoor),
            _buildInfo('Wat', info.wat),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactpersonenInfo = ref.watch(meldpersonencontactInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Melding maken"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Er is iets gebeurd op Njord wat je niet fijn vindt, wat nu?",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Hieronder vind je de verschillende manieren om dit te bespreken of te melden, van laagdrempelig tot formele meldingen.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          contactpersonenInfo.when(
            data: (contactInfo) =>
              Column(
                children: contactInfo.map((info) => _buildTile(context, info)).toList(),
              ),
            error: (error, stackTrace) => ErrorCardWidget(
              errorMessage: error.toString(),
              stackTrace: stackTrace,
            ),
            loading: () =>
              LoadingWidget(),
            ),
        ],
      ),
    );
  }
}
