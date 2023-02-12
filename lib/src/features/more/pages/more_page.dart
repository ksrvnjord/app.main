import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/more_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> optionMap = {
      "Mijn Njord-account": "/settings",
      "Agenda": "events",
      "Contact": "/contact",
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
            (entry) => MoreListTile(
              label: entry.key,
              routePath: entry.value,
            ),
          ),
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
