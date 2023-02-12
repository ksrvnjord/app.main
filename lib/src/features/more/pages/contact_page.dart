import 'package:flutter/material.dart';
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
        ExpansionTile(
          initiallyExpanded: true,
          // TODO: lijst maken van bestuur + commissies
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
        ExpansionTile(title: const Text("Commissies"), children: [
          // create a DataTable, with two columns: function and email
          DataTable(
            columns: const [
              DataColumn(label: Text("Functie")),
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
        Row(children: [
          const Text("Vragen over de app?").fontSize(fontSizeSingleText),
          InkWell(
            onTap: () => _launchUrl,
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

  Future<void> _launchUrl() async {
    if (!await launchUrl(_appCommissieMail)) {
      throw Exception('Could not launch $_appCommissieMail');
    }
  }
}
