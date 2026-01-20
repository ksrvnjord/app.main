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
    if (title == "Link") {
      return SizedBox(
        child: ElevatedButton(
          onPressed: () async => launchUrl(Uri.parse(content)),
          child: Text("Meer weten?"),
        ),
      );
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
    final List<String> hasContact = ["Vertrouwenscontactpersonen", "Bestuur"];
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
            if (info.email != null) ...[
              // FIXME: String matching
              if (hasContact.contains(info.name)) ...[
                IconButton(
                  icon: const Icon(Icons.email_outlined),
                  tooltip: "Email",
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) =>
                          Consumer(builder: (context, ref, _) {
                        final assetPath = info.name;
                        final contactPersoonInfo =
                            ref.watch(contactpersonenInfoProvider(assetPath));
                        return AlertDialog.adaptive(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: dialogPadding / 2),
                          content: contactPersoonInfo.when(
                            data: (cp) => DataTable(
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  "Contactpersoon",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                  label: Text(
                                    "Email",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              rows: [
                                ...cp.map(
                                  (contactpersoon) => DataRow(
                                    cells: [
                                      DataCell(Text(contactpersoon.name)),
                                      DataCell(
                                        IconButton(
                                          icon:
                                              const Icon(Icons.email_outlined),
                                          onPressed: () async => launchUrl(
                                            Uri.parse(
                                                'mailto:${contactpersoon.email}'),
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
              ] else ...[
                IconButton(
                  icon: Icon(Icons.email_outlined),
                  onPressed: () => launchUrl(Uri.parse('mailto:${info.email}')),
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
              _buildInfo('Wat', info.wat),
              _buildInfo('Link', info.link),
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
                  "Is er iets vervelends gebeurd op Njord, of zit je niet lekker in je vel? Hier kan je terecht!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Hier vind je de verschillende manieren om dit te bespreken of te melden. Njord biedt interne hulp en de externe hulp staat voor waar je buiten Njord terecht kan.",
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
                for (final contactOption in ["Interne hulp", "Externe hulp"])
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: wrapSpacing / 2),
                    child: ChoiceChip(
                      label: Text(contactOption),
                      onSelected: (selected) => context.goNamed(
                        "VCPContact",
                        queryParameters: {
                          'contactChoice':
                              contactOption == "Interne hulp" ? 'true' : 'false'
                        },
                      ),
                      selected: contactChoice == (contactOption == "Interne hulp"),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: wrapSpacing),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: wrapSpacing),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.3),
                      ),
                    ),
                    child: ExpansionTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text(
                        "Belangrijk",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      shape: const Border(),
                      dense: true,
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0),
                      childrenPadding: const EdgeInsets.all(8.0),
                      children: const [
                        Text(
                          "Je hoeft het niet perfect te doen! Alleen al luisteren en er zijn, maakt verschil.\n\n"
                          "Sta erbij stil wat de steunende rol met jou doet en hoe je hiermee omgaat. Zo kan het zijn dat je meevoelt met de ander waardoor je zelf ook negatieve gevoelens gaat ervaren, of dat je je overmatig verantwoordelijk gaat voelen voor het welzijn van de ander.\n\n"
                          "Het advies van We Zien Mekaar: let goed op jezelf, wees lief voor jezelf, en schakel hulp in als dat nodig is. Dat kan bij andere naasten/vrienden, of door een afspraak te maken bij de huisarts. Omdat jij die steunende en/of helpende rol niet in je eentje hoeft te dragen.",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                contactpersonenInfo.when(
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
                  loading: () => const LoadingWidget(),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
