import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';

class SelectCommissiePage extends StatelessWidget {
  const SelectCommissiePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecteer commissie'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: <Widget>[
          // TODO: use commissies from list
          ListTile(
            title: const Text('App Commissie'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () =>
                Routemaster.of(context).push('fill-info', queryParameters: {
              'commissie': 'App Commissie',
            }),
          ),
          const ListTile(
            title: Text('App Commissie'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            title: Text('App Commissie'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
