import 'package:flutter/material.dart';

class AlmanakPage extends StatefulWidget {
  const AlmanakPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AlmanakPageState();
}

class _AlmanakPageState extends State<AlmanakPage> {

  var voorbeeldNamen = ['Boone', // We want to get this info from the database.
    'Kristie',
    'Veefkind'];

  // Add search bar widget.
  // Get info from database instead of example list.
  // Construct all names in the app automatically.

  @override
  Widget build(BuildContext context){
    return MaterialApp( // Or padding / Card
      title: "Almanak",
      home: Scaffold(
        appBar: AppBar(
          title: Text('Almanak'),
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
        ),
          body: Column(
            children: [ // For loop maken voor ListTiles (of beter alternatief)
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
