import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/filters.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingFilters extends StatelessWidget {
  final List<String> filters;
  final void Function(String filter) toggleFilter;

  const TrainingFilters({
    Key? key,
    required this.filters,
    required this.toggleFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;

    return FutureWrapper(
        future: afschrijvingFilters(),
        success: (data) {
          if (data != null) {
            return ListView(
                children: data.map<Widget>((e) {
              bool selected = filters.contains(e.type);
              return ListTile(
                  tileColor: selected ? Colors.blue : Colors.white,
                  textColor: selected ? Colors.white : Colors.black,
                  iconColor: selected ? Colors.white : Colors.black,
                  leading: selected
                      ? const Icon(Icons.check_box_outlined)
                      : const Icon(Icons.check_box_outline_blank),
                  title: Text(e.description),
                  onTap: () => toggleFilter(e.type));
            }).toList());
          }
          return Container();
        });
  }
}
