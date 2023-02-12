import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
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
          ListTile(
            title: const Text('Mijn Njord-account'),
            // add a trailing icon that indicates that the item is clickable
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Routemaster.of(context).push('/settings');
            },
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
