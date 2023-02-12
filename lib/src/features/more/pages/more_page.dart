import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/more_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> optionMap = {
      "Mijn Njord-account": "/settings",
      "Agenda": "events",
      "Contact": "/contact",
      "Beleid van het bestuur": "beleid",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meer'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          ...optionMap.entries.map(
            // Make a list of options to display and navigate to
            // Each option is a tile with a divider below it
            (entry) => [
              MoreListTile(
                label: entry.key,
                routePath: entry.value,
              ),
              const Divider(),
            ].toColumn(),
          ),
          ListTile(
            title: const Text('Webshop'),
            trailing: // icon that shows external link
                const Icon(Icons.open_in_new, color: Colors.lightBlue),
            onTap: () =>
                launchUrl(Uri.parse("https://k-s-r-v-njord.myshopify.com/")),
          ),
          const Divider(),
          ListTile(
            title: const Text('Uitloggen').textColor(Colors.red),
            trailing: const Icon(Icons.logout, color: Colors.red),
            onTap: () {
              Provider.of<AuthModel>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
