import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class PlanTrainingPage extends StatelessWidget {
  const PlanTrainingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nieuwe Afschrijving'),
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: <Widget>[
        TextFormField(
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Afschrijven',
            border: OutlineInputBorder(),
          ),
          initialValue: 'Zephyr',
        ).padding(all: 15),
        TextFormField(
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Dag',
            border: OutlineInputBorder(),
          ),
          initialValue: '2022-09-28',
        ).padding(all: 15),
        Text('Time Slider...'),
        Text('Menu om mensen uit te nodigen...'),
      ].toColumn(),
    );
  }
}
