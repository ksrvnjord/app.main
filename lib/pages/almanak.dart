import 'package:flutter/material.dart';

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
                  delegate: CustomSearchDelegate(), // Separate class in this file for now.
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

// Probably move this widget to a separate file soon.
class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = ['Boone', // We want to get this info from the database.
                              'Kristie',
                              'Veefkind'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [ // Clear the search query
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); // To leave and close the search bar.
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}