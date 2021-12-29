import 'package:flutter/material.dart';
import 'package:ksrv_njord_app/widgets/general/searchbar.dart';

class AlmanakPage extends StatefulWidget {
  const AlmanakPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AlmanakPageState();
}

class _AlmanakPageState extends State<AlmanakPage> {

  List<String> voorbeeldNamen = ['Boone', // We want to get this info from the database.
    'Kristie',
    'Veefkind'];

  // Get info from database instead of example list.
  // Construct all names in the app automatically.

  @override
  Widget build(BuildContext context){
    return MaterialApp( // Or padding / Card
      title: "Almanak",
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
            Text('Almanak'),
            IconButton( // Put in the title for now, needs styling later.
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(voorbeeldNamen), // Give the possible search terms as parameter to the search bar function.
                );
              },
              icon: const Icon(Icons.search), // Use classic search icon.
            ),
            ],
          ),
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
        ),
          body: Column(
            children: [ // Make for loop.
              ListTile(
                title: Text(voorbeeldNamen[0]),
                onTap: () {print('This is Max Boone.');},
              ),
              ListTile(
                title: Text(voorbeeldNamen[1]),
                onTap: () {print('This is Kristie Wesdorp.');},
              ),
              ListTile(
                title: Text(voorbeeldNamen[2]),
                onTap: () {print('This is Pim Veefkind.');},
              ),
            ],)
      )
    );
  }
}