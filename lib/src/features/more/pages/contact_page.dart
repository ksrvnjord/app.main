import 'package:flutter/material.dart';
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
        // const ExpansionTile( // TODO: lijst maken van bestuur + commissies
        //   title: Text("Bestuur"),
        // ),
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
