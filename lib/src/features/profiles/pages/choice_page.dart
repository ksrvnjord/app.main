import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

/// Page that shows a list of choices, and pushes a new page when a choice is chosen
class ChoicePage extends StatelessWidget {
  const ChoicePage({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: choices
            .map(
              (choice) => [
                ListTile(
                  title: Text(choice),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.lightBlue,
                  ),
                  onTap: () =>
                      Routemaster.of(context).push(pushRoute, queryParameters: {
                    queryParameterName: choice,
                  }),
                ),
                const Divider(
                  thickness: 1,
                  height: 1,
                ),
              ].toColumn(),
            )
            .toList(),
      ),
    );
  }
}
