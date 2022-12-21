import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/filters.dart';

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
    return FutureWrapper(
        future: afschrijvingFilters(),
        success: (data) {
          if (data != null) {
            return ListView(
                shrinkWrap: true,
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
          } else {
            return const ErrorCardWidget(
                errorMessage:
                    'Er is iets misgegaan met het ophalen van de filters');
          }
        });
  }
}
