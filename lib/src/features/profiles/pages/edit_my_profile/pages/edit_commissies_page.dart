import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/models/commissie_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/stream_wrapper.dart';
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
      body: ListView(children: [
        const Text('Mijn Commissies')
            .textColor(Colors.blueGrey)
            .fontSize(titleFontSize)
            .padding(all: fieldPadding),
        StreamWrapper(
          // use stream to show updates in real time
          stream: getMyCommissies<Stream<QuerySnapshot<CommissieEntry>>>(),
          success: (commissies) => buildCommissieList(commissies),
        ),
      ]),
      floatingActionButton: // button with a plus icon and the text "Commissie"
          FloatingActionButton.extended(
        onPressed: () => Routemaster.of(context).push('select'),
        label: const Text('Voeg commissie toe'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  Column buildCommissieList(QuerySnapshot<CommissieEntry> snapshot) {
    List<QueryDocumentSnapshot<CommissieEntry>> docs = snapshot.docs;
    docs.sort((a, b) => a.data().startYear.compareTo(b.data().startYear));

    return Column(
      children: docs.isNotEmpty
          ? docs
              .map((doc) => ListTile(
                    leading: [
                      Text(
                        "${doc.data().startYear}-${doc.data().endYear ?? "heden"}",
                      ),
                    ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                    title: Text(doc.data().name),
                    subtitle: doc.data().function != null
                        ? Text(doc.data().function!)
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => doc.reference.delete(),
                    ),
                  ))
              .toList()
          : [
              const Text('Geen commissies gevonden, voeg een commissie toe.')
                  .padding(all: fieldPadding),
            ],
    );
  }
}
