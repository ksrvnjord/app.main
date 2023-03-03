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
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
      ),
      body: ListView(children: [
        // TODO: add linkje naar interne Njord Insta
        ExpansionTile(
          initiallyExpanded: true,
          title: const Text("Bestuur")
              .fontSize(expansionTileFontSize)
              .fontWeight(FontWeight.w500),
          children: [
            // create a DataTable, with two columns: function and email
            DataTable(
              columns: const [
                DataColumn(label: Text("Functie")),
                DataColumn(label: Text("Email")),
              ],
              rows: [
                ...bestuurEmailMap.entries.map(
                  (entry) => DataRow(cells: [
                    DataCell(Text(entry.key)),
                    DataCell(
                      InkWell(
                        onTap: () => launchUrl(
                          Uri.parse('mailto:${entry.value}'),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.envelope,
                          color: Colors.blue,
                        ).padding(all: emailIconPadding),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ],
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
                        onTap: () => launchUrl(
                          Uri.parse('mailto:${entry.value}'),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.envelope,
                          color: Colors.blue,
                        ).padding(all: emailIconPadding),
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
            onTap: () => launchUrl(
              Uri.parse('mailto:app@njord.nl'),
            ),
            child: const Text(
              "app@njord.nl",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
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
        onTap: () => launchUrl(
          Uri.parse(url),
        ),
        child: Text(
          handle,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ).padding(left: horizontalPadding),
    ]);
  }
}
