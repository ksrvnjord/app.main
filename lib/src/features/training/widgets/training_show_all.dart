import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/slots.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_day_left_view.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_day_list.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingShowAll extends StatefulWidget {
  final DateTime date;
  final List<String> filters;

  const TrainingShowAll({
    Key? key,
    required this.date,
    required this.filters,
  }) : super(key: key);

  @override
  createState() => _TrainingShowAll();
}

class _TrainingShowAll extends State<TrainingShowAll> {
  late final ScrollController boatsController;
  late final ScrollController timesController;

  @override
  void initState() {
    boatsController = ScrollController();
    timesController = ScrollController();

    boatsController.addListener(() {
      if (boatsController.offset != timesController.offset) {
        timesController.jumpTo(boatsController.offset);
      }
    });

    timesController.addListener(() {
      if (timesController.offset != boatsController.offset) {
        boatsController.jumpTo(timesController.offset);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GraphQLClient client = Provider.of<GraphQLModel>(context).client;

    return FutureWrapper(
        future: reservedSlots(widget.filters, client),
        success: (data) {
          if (data != null) {
            if (data.isEmpty) {
              return <Widget>[
                const Icon(Icons.waves, color: Colors.blueGrey).padding(all: 8),
                const Text('Geen materiaal gevonden, breid filter uit',
                    style: TextStyle(color: Colors.blueGrey))
              ].toColumn(mainAxisAlignment: MainAxisAlignment.center);
            }

            return Stack(children: [
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: boatsController,
                      child: StickyHeader(
                              header: [
                                data
                                    .map<Widget>((e) {
                                      return Container(
                                          color: Colors.grey[50],
                                          width: 96,
                                          height: 64,
                                          child: Text(e.name).center());
                                    })
                                    .toList()
                                    .toRow()
                              ].toRow(),
                              content: data
                                  .map<Widget>((e) {
                                    return TrainingDayList(
                                        date: widget.date, boat: e);
                                  })
                                  .toList()
                                  .toRow())
                          .padding(left: 64))),
              SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: timesController,
                  child: Container(
                      color: Colors.grey[50],
                      child: TrainingDayLeftView().padding(top: 64))),
              Container(
                color: Colors.grey[50],
                width: 64,
                height: 64,
              )
            ]);
          }
        });
  }
}
