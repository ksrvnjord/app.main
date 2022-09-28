import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/slots.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingShowAll extends StatelessWidget {
  final DateTime now;
  final List<String> filters;

  const TrainingShowAll({
    Key? key,
    required this.now,
    required this.filters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GraphQLClient client = Provider.of<GraphQLModel>(context).client;

    return FutureWrapper(
        future: reservedSlots(filters, client),
        success: (data) {
          if (data != null && data.isEmpty) {
            return <Widget>[
              const Icon(Icons.waves, color: Colors.blueGrey).padding(all: 8),
              const Text('Geen materiaal gevonden, breid filter uit',
                  style: TextStyle(color: Colors.blueGrey))
            ].toColumn(mainAxisAlignment: MainAxisAlignment.center);
          }

          return Text(data.toString());
        });
  }
}
