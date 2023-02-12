import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/more_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meer'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          const MoreListTile(
            label: "Mijn Njord-account",
            routePath: "/settings",
          ),
          const Divider(),
          const MoreListTile(label: "Contact", routePath: "/contact"),
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
