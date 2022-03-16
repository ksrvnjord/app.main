import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlmanakSearch extends StatefulWidget {

  const AlmanakSearch({Key? key}) : super(key: key);

  @override
  _AlmanakSearchState createState() => _AlmanakSearchState();
}

class _AlmanakSearchState extends State<AlmanakSearch> {
  String currentSearch = 'kristie';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: (text) {
            currentSearch = text;
          },
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Text(currentSearch),
  );
}
}