import 'package:flutter/material.dart';
import 'package:ksrv_njord_app/widgets/general/searchbar.dart';

class AlmanakPage extends StatefulWidget {
  const AlmanakPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AlmanakPageState();
}

class _AlmanakPageState extends State<AlmanakPage> {

  List<String> voorbeeldLeden = ['Boone', // Replace with info from the database.
    'Kristie',
    'Veefkind'];

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Almanak",
      home: Builder( // Wrap in a builder widget to get the right context for showSearch.
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text('Almanak'),
                IconButton( // Put in the title for now, needs styling later.
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(voorbeeldLeden), // Give the possible search terms as parameter to the search bar function.
                    );
                  },
                  icon: const Icon(Icons.search), // Use classic search icon.
                ),
              ],
            ),
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
          ),
          body: ListView.builder(
            itemCount: voorbeeldLeden.length,
            itemBuilder: (context, index) {
              final lid = voorbeeldLeden[index];
              return ListTile(
                title: Text(lid),
                onTap: () {print(lid);}, // Replace with more info about the lid.
              );
              },
          ),
        )
      )
    );
  }
}