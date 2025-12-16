import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/model/contactpersoon_info.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/contactpersoon_info_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class VCPPage extends ConsumerWidget {
  const VCPPage({
    super.key,
    required this.contactChoice,
  });

  final bool contactChoice;

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
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            content,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4.0,
          )
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, MeldpersooncontactInfo info) {
    final double dialogPadding = 4.0;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(info.name),
            ),
            if (info.contact != null) ...[

              // FIXME: String matching
              if (info.name == "Vertrouwenscontactpersonen") ...[
                IconButton(
                  icon: const Icon(Icons.email_outlined),
                  tooltip: "Email",
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) => Consumer(builder: (context, ref, _) {
                        final vertrouwensPersoonInfo =
                            ref.watch(vertrouwenscontactpersonenInfoProvider);
                        return AlertDialog.adaptive(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: dialogPadding / 2),
                          content: vertrouwensPersoonInfo.when(
                            data: (vcp) => DataTable(
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  "Vertrouwenscontactpersoon",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                  label: Text(
                                    "Email",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              rows: [
                                ...vcp.map(
                                  (vertrouwenscontactpersoon) => DataRow(
                                    cells: [
                                      DataCell(
                                          Text(vertrouwenscontactpersoon.name)),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(Icons.email_outlined),
                                          onPressed: () async => launchUrl(
                                            Uri.parse(
                                                'mailto:${vertrouwenscontactpersoon.email}'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            error: (error, stackTrace) => ErrorCardWidget(
                              errorMessage: error.toString(),
                              stackTrace: stackTrace,
                            ),
                            loading: () => LoadingWidget(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Ok"),
                            )
                          ],
                        );
                      }),
                    );
                  },
                ),
              ]
              else ...[
                IconButton(
                  icon: Icon(Icons.email_outlined),
                  onPressed: () =>
                    launchUrl(Uri.parse('mailto:${info.contact}')),
                ),
              ],
            ],
          ],
        ),
        children: [
          Column(
            children: [
              if (info.lidnummers != null)
                ...info.lidnummers!.map(
                  (contactLidnummer) => AlmanakUserTile(
                    firstName: "",
                    lastName: "",
                    lidnummer: contactLidnummer,
                  ),
                ),
              _buildInfo('Wie', info.wie),
              _buildInfo('Wanneer', info.wanneer),
              _buildInfo('Waarvoor', info.waarvoor),
              _buildInfo('Wat', info.wat),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactpersonenInfo =
        ref.watch(meldpersonencontactInfoProvider(contactChoice));
    const double wrapSpacing = 8.0;
    const double fontSize = 24.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Melding maken"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: wrapSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Er is iets gebeurd op Njord wat je niet fijn vindt, wat nu?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
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
          Padding(
            padding: const EdgeInsets.only(
                top: wrapSpacing * 2,
                bottom: wrapSpacing * 2,
                right: wrapSpacing),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (final contactOption in ["Intern", "Extern"])
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: wrapSpacing / 2),
                    child: ChoiceChip(
                      label: Text(contactOption),
                      onSelected: (selected) => context.goNamed(
                        "VCPContact",
                        queryParameters: {
                          'contactChoice':
                              contactOption == "Intern" ? 'true' : 'false'
                        },
                      ),
                      selected: contactChoice == (contactOption == "Intern"),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: contactpersonenInfo.when(
              data: (data) {
                if (contactChoice) {
                  final contactInfo = data as List<MeldpersooncontactInfo>;
                  return Column(
                    children: contactInfo
                        .map((info) => _buildTile(context, info))
                        .toList(),
                  );
                } else {
                  final grouped =
                      data as Map<String, List<MeldpersooncontactInfo>>;
                  return Column(
                    children: grouped.entries.map((entry) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.5),
                          ),
                        ),
                        child: ExpansionTile(
                            title: Text(entry.key),
                            children: entry.value
                                .map((info) => _buildTile(context, info))
                                .toList()),
                      );
                    }).toList(),
                  );
                }
              },
              error: (error, stackTrace) => ErrorCardWidget(
                errorMessage: error.toString(),
                stackTrace: stackTrace,
              ),
              loading: () => LoadingWidget(),
            ),
          )),
        ],
      ),
    );
  }
}
