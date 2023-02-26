import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class EditCommissiesPage extends StatefulWidget {
  const EditCommissiesPage({Key? key}) : super(key: key);

  @override
  EditCommissiesPageState createState() => EditCommissiesPageState();
}

class EditCommissiesPageState extends State<EditCommissiesPage> {
  static const double fieldPadding = 8;
  static const double titleFontSize = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Commissies'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: <Widget>[
          const Text('Mijn Commissies')
              .textColor(Colors.blueGrey)
              .fontSize(titleFontSize)
              .padding(all: fieldPadding),
          // TODO: ophalen van commissies subcollection in firestore
          ListTile(
            leading: [Text("2022-2023")]
                .toColumn(mainAxisAlignment: MainAxisAlignment.center),
            title: Text('App Commissie'),
            subtitle: Text("Ab-actis"),
            trailing: Icon(Icons.delete),
          ),
          // another list tile with the same structure
          ListTile(
            leading: [Text("2022-2023")]
                .toColumn(mainAxisAlignment: MainAxisAlignment.center),
            title: Text('App Commissie'),
            subtitle: Text("Ab-actis"),
            trailing: Icon(Icons.delete),
          ),
          ListTile(
            leading: [Text("2022-2023")]
                .toColumn(mainAxisAlignment: MainAxisAlignment.center),
            title: Text('App Commissie'),
            trailing: Icon(Icons.delete),
          ),
        ],
      ),
      floatingActionButton: // button with a plus icon and the text "Commissie"
          FloatingActionButton.extended(
        onPressed: () => Routemaster.of(context).push('select'),
        label: const Text('Voeg commissie toe'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
