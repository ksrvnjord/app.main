import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';

class SelectPloegTypePage extends StatelessWidget {
  const SelectPloegTypePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<String> ploegTypes = ["Wedstrijd", "Competitie"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecteer ploeg type'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: ploegTypes
            .map(
              (type) => ListTile(
                title: Text(type),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Routemaster.of(context).push(
                  type, // push to 'Wedstrijd' or 'Competitie'
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
