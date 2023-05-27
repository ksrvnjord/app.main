import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';

/// Page that shows a list of choices, and pushes a new page when a choice is chosen.
class ChoicePage extends StatelessWidget {
  const ChoicePage({
    Key? key,
    required this.title,
    required this.choices,
  }) : super(key: key);

  final String title;
  final List<String> choices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: choices
            .map(
              (choice) => Column(
                children: [
                  ListTile(
                    title: Text(choice),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: () => Routemaster.of(context).push(choice),
                  ),
                  const Divider(height: 0, thickness: 0.5),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
