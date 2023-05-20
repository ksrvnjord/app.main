import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/bestuur.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/commissies.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  final double padding = 16;
  final double fontSizeSingleText = 16;
  final double horizontalPadding = 8;
  final double emailIconPadding = 8;
  final double widgetPadding = 8;
  final double cardElevation = 2;
  final double cardRadius = 16;

  final double expansionTileFontSize = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView(children: [
        // TODO: add linkje naar interne Njord Insta
        ExpansionTile(
          title: const Text("Bestuur")
              .fontSize(expansionTileFontSize)
              .fontWeight(FontWeight.w500),
          // ignore: sort_child_properties_last
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text("Functie")),
                DataColumn(label: Text("Email")),
              ],
              rows: [
                ...bestuurEmailMap.entries.map((entry) => DataRow(cells: [
                      DataCell(Text(entry.key)),
                      DataCell(InkWell(
                        child: const FaIcon(
                          FontAwesomeIcons.envelope,
                          color: Colors.blue,
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
          title: const Text("Commissies")
              .fontSize(expansionTileFontSize)
              .fontWeight(FontWeight.w500),
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text("Commissie")),
                DataColumn(label: Text("Email")),
              ],
              rows: [
                ...commissieEmailMap.entries.map(
                  (entry) => DataRow(cells: [
                    DataCell(Text(entry.key)),
                    DataCell(
                      // create a link to the email
                      InkWell(
                        child: const FaIcon(
                          FontAwesomeIcons.envelope,
                          color: Colors.blue,
                        ).padding(all: emailIconPadding),
                        onTap: () =>
                            launchUrl(Uri.parse('mailto:${entry.value}')),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
        [
          const Text("Volg je ons al op Instagram?")
              .fontSize(fontSizeSingleText)
              .fontWeight(FontWeight.bold)
              .textColor(Colors.white)
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
          ].toRow(),
        ]
            .toColumn()
            .card(
              color: Colors.lightBlue,
              elevation: cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius),
              ),
            )
            .padding(all: widgetPadding),
        [
          const Text("Vragen over de app?").fontSize(fontSizeSingleText),
          InkWell(
            child: const Text(
              "app@njord.nl",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
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

class InstagramRowWidget extends StatelessWidget {
  const InstagramRowWidget({
    super.key,
    required this.url,
    required this.handle,
  });
  final String url; // the url of the instagram account
  final String handle; // the handle of the instagram account @...

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 8;

    return Row(children: [
      const Icon(FontAwesomeIcons.instagram, color: Colors.white),
      InkWell(
        child: Text(
          handle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => launchUrl(Uri.parse(url)),
      ).padding(left: horizontalPadding),
    ]);
  }
}
