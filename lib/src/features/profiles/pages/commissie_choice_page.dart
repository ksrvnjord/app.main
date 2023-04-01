import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/commissie_choice_list_tile.dart';
import 'package:styled_widget/styled_widget.dart';

/// Page that shows a list of choices, and pushes a new page when a choice is chosen
class CommissieChoicePage extends ConsumerWidget {
  const CommissieChoicePage({
    Key? key,
    required this.title,
    required this.choices,
    required this.pushRoute,
    required this.queryParameterName,
  }) : super(key: key);

  final String title;
  final List<String> choices;
  final String pushRoute;
  final String queryParameterName;

  static const cacheExtent = 800.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        addAutomaticKeepAlives: true,
        cacheExtent: cacheExtent,
        children: [
          ...choices.map(
            (choice) => <Widget>[
              CommissieChoiceListTile(
                commissie: choice,
                pushRoute: pushRoute,
                queryParameterName: queryParameterName,
              ),
              const Divider(
                thickness: 0.5,
                height: 0,
              ),
            ].toColumn(),
          ),
        ],
      ),
    );
  }
}
