import 'package:flutter/material.dart';

var voorbeeldNamen = ['Boone', // We want to get this info from the database.
                      'Kristie',
  'Veefkind'];

class AlmanakPage extends StatelessWidget { // What kind of widget should this be?
  const AlmanakPage({Key? key}) : super(key: key); // Is this something we need for navigation?

  // We want a page
  // Appbar like the  main  one,  stating that we are in the almanak
    // Text widget 'almanak'
  //    On it should be a search bar
  //    And a list of the users. In the form of a button? onPressed for more info.

  @override // Decorator: to make the code clearer / cleaner. We override the build method
  Widget build(BuildContext context){
    return MaterialApp( // Or padding / Card
      title: "Almanak",
      home: Scaffold(
        appBar: AppBar(
          title: Text('Almanak'),
        ),
          body: Column(
            children: [
              Text(voorbeeldNamen[0]), // Hiervan een for loop maken? Handiger opschrijven.
              Text(voorbeeldNamen[1]),
              Text(voorbeeldNamen[2]),

            ],)
      )
    );
  }
}
