import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_filters.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:styled_widget/styled_widget.dart';

class AllTrainingPage extends StatefulWidget {
  const AllTrainingPage({Key? key}) : super(key: key);

  @override
  State<AllTrainingPage> createState() => _AllTrainingPage();
}

class _AllTrainingPage extends State<AllTrainingPage> {
  List<String> filters = [];
  void Function(void Function()) setModalState = (f0) => {};

  void toggleFilter(String filter) {
    if (filters.contains(filter)) {
      filters.remove(filter);
      setState(() {});
      setModalState(() {});
    } else {
      filters.add(filter);
      setState(() {});
      setModalState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Afschrijvingen'),
        // automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        StatefulBuilder(builder: (context, setModalState) {
                          this.setModalState = setModalState;
                          return TrainingFilters(
                            filters: filters,
                            toggleFilter: toggleFilter,
                          );
                        }));
              }),
        ],
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: <Widget>[].toRow(),
    );
  }
}
