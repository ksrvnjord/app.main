import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/commissies.dart';
import 'package:routemaster/routemaster.dart';

class SelectCommissiePage extends StatelessWidget {
  const SelectCommissiePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecteer commissie'),
      ),
      body: ListView(
        children: commissieEmailMap.keys
            .map(
              (commissie) => ListTile(
                title: Text(commissie),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Routemaster.of(context).push(
                  'fill-info',
                  queryParameters: {'commissie': commissie},
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
