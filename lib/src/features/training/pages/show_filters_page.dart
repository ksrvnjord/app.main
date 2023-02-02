// create Stateful page that lists all available filters for a reservation

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowFiltersPage extends StatefulWidget {
  const ShowFiltersPage({Key? key}) : super(key: key);

  @override
  State<ShowFiltersPage> createState() => _ShowFiltersPage();
}

class _ShowFiltersPage extends State<ShowFiltersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kies filters'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: const [],
      ),
      floatingActionButton: FloatingActionButton(
        // to save the filters
        backgroundColor: Colors.lightBlue,
        onPressed: () => {},
        child: const Icon(Icons.check),
      ),
    );
  }
}
