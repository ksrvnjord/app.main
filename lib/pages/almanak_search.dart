import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlmanakSearch extends StatefulWidget {

  const AlmanakSearch({Key? key}) : super(key: key);

  @override
  _AlmanakSearchState createState() => _AlmanakSearchState();
}

class _AlmanakSearchState extends State<AlmanakSearch> {
  String currentSearch = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        title: Row(
          children: [
            TextField(
              autofocus: true,
              onChanged: (text) {
                setState(() {
                  currentSearch = text;
                  });
                },
              ),
            IconButton(
              onPressed: () {
                currentSearch = '';
              },
              icon: const Icon(Icons.clear),
              )],),
      ),
      body: Text(currentSearch),
  );
}
  @override
  List<Widget> clearSearch(BuildContext context) {
    return [

    ];
  }
}