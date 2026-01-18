import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/contactpersoon_info_provider.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/instagram_row_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/commissie_info_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/bestuur.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  final double padding = 16;
  final double horizontalPadding = 8;
  final double emailIconPadding = 8;
  final double widgetPadding = 8;
  final double cardElevation = 2;
  final double cardRadius = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final commissieInfoVal = ref.watch(commissiesInfoProvider);
    final vcpInfoVal =
        ref.watch(contactpersonenInfoProvider("Vertrouwenscontactpersonen"));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      body: ListView(children: [
        ExpansionTile(
          title: Text("Bestuur", style: textTheme.titleLarge),

          // ignore: sort_child_properties_last
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text("Functie")),
                DataColumn(label: Text("E-mail")),
              ],
              rows: [
                ...bestuurEmailMap.entries.map((entry) => DataRow(cells: [
                      DataCell(Text(entry.key)),
                      DataCell(InkWell(
                        child: const FaIcon(
                          FontAwesomeIcons.envelope,
                        ).padding(all: emailIconPadding),
                        onTap: () =>
                            launchUrl(Uri.parse('mailto:${entry.value}')),
                      )),
                    ])),
              ],
            ),
          ],
          initiallyExpanded: true,
        ),
        ExpansionTile(
          title: Text("Commissies", style: textTheme.titleLarge),
          children: [
            commissieInfoVal.when(
              data: (commissies) => DataTable(
                columns: const [
                  DataColumn(label: Text("Commissie")),
                  DataColumn(label: Text("E-mail")),
                ],
                rows: [
                  ...commissies.map(
                    (commissie) => DataRow(cells: [
                      DataCell(Text(commissie.name)),
                      DataCell(
                        InkWell(
                          child: const FaIcon(
                            FontAwesomeIcons.envelope,
                          ).padding(all: emailIconPadding),
                          onTap: () => launchUrl(
                            Uri.parse('mailto:${commissie.email}'),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              loading: () => DataTable(
                columns: const [
                  DataColumn(label: Text("Commissie")),
                  DataColumn(label: Text("E-mail")),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(CircularProgressIndicator.adaptive()),
                    DataCell(CircularProgressIndicator.adaptive()),
                  ]),
                ],
              ),
              error: (error, stackTrace) => ErrorCardWidget(
                errorMessage: error.toString(),
                stackTrace: stackTrace,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title:
              Text("Vertrouwenscontactpersonen", style: textTheme.titleLarge),
          children: [
            vcpInfoVal.when(
              data: (vertrouwenscontactpersonen) => DataTable(
                columns: const [
                  DataColumn(label: Text("Vertrouwenscontactpersoon")),
                  DataColumn(label: Text("E-mail")),
                ],
                rows: [
                  ...vertrouwenscontactpersonen.map(
                    (vertrouwenscontactpersoon) => DataRow(cells: [
                      DataCell(Text(vertrouwenscontactpersoon.name)),
                      DataCell(
                        InkWell(
                          child: const FaIcon(
                            FontAwesomeIcons.envelope,
                          ).padding(all: emailIconPadding),
                          onTap: () => launchUrl(
                            Uri.parse(
                                'mailto:${vertrouwenscontactpersoon.email}'),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              loading: () => DataTable(
                columns: const [
                  DataColumn(label: Text("Vertrouwenscontactpersoon")),
                  DataColumn(label: Text("E-mail")),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(CircularProgressIndicator.adaptive()),
                    DataCell(CircularProgressIndicator.adaptive()),
                  ]),
                ],
              ),
              error: (error, stackTrace) => ErrorCardWidget(
                errorMessage: error.toString(),
                stackTrace: stackTrace,
              ),
            ),
          ],
        ),
        [
          Text("Volg je ons al op Instagram?", style: textTheme.titleLarge)
              .padding(all: widgetPadding),
          [
            [
              const InstagramRowWidget(
                url: "https://www.instagram.com/ksrvnjord/",
                handle: "@ksrvnjord",
              ).padding(all: padding),
            ].toColumn(),
            [
              const InstagramRowWidget(
                url: "https://www.instagram.com/ksrvnjord_intern/",
                handle: "@ksrvnjord_intern",
              ).padding(all: padding),
            ].toColumn(),
          ].toRow(mainAxisAlignment: MainAxisAlignment.center),
        ]
            .toColumn()
            .card(
              elevation: cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius),
              ),
            )
            .padding(all: widgetPadding),
        [
          const Text("Vragen over de app?"),
          InkWell(
            child: const Text(
              "app@njord.nl",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => launchUrl(Uri.parse('mailto:app@njord.nl')),
          ).padding(horizontal: horizontalPadding),
        ].toRow().padding(vertical: widgetPadding, horizontal: padding),
      ]),
    );
  }
}
