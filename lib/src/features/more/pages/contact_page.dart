import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/more/data/bestuur.dart';
import 'package:ksrvnjord_main_app/src/features/more/data/commissies.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _appCommissieMail = Uri.parse('mailto:app@njord.nl');

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  final double padding = 16;
  final double fontSizeSingleText = 16;
  final double horizontalPadding = 8;

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
          title: const Text("Bestuur"),
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
                    DataCell(Text(entry.value)),
                  ]),
                ),
              ],
            ),
          ],
        ),
        const Divider(),
        ExpansionTile(title: const Text("Commissies"), children: [
          // create a DataTable, with two columns: function and email
          DataTable(
            columns: const [
              DataColumn(label: Text("Commissie")),
              DataColumn(label: Text("Email")),
            ],
            rows: [
              ...commissieEmailMap.entries.map(
                (entry) => DataRow(cells: [
                  DataCell(Text(entry.key)),
                  DataCell(Text(entry.value)),
                ]),
              ),
            ],
          ),
        ]),
        const Divider(),
        // Add instagram icon linking to our insta
        const InstagramRowWidget(
          url: "https://www.instagram.com/ksrvnjord/",
          handle: "@ksrvnjord",
        ).padding(all: padding),
        const InstagramRowWidget(
          url: "https://www.instagram.com/ksrvnjord_intern/",
          handle: "@ksrvnjord_intern",
        ).padding(all: padding),
        const Divider(),
        Row(children: [
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
        ]).padding(all: padding),
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
      const Icon(FontAwesomeIcons.instagram, color: Colors.lightBlue),
      InkWell(
        onTap: () => launchUrl(
          Uri.parse(url),
        ),
        child: Text(
          handle,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.lightBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ).padding(horizontal: horizontalPadding),
    ]);
  }
}
