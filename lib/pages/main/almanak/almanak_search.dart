import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/almanak/almanak_show_search_results.dart';

class AlmanakSearch extends StatefulWidget {
  AlmanakSearch({Key? key}) : super(key: key);

  @override
  _AlmanakSearchState createState() => _AlmanakSearchState();
}

class _AlmanakSearchState extends State<AlmanakSearch> {
  final StreamController<String> _searchController = StreamController<String>();
  TextEditingController currentSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            title: Row(children: [
              SizedBox(
                  width: 180,
                  child: TextField(
                      autofocus: true,
                      controller: currentSearch,
                      onChanged: (text) {
                        _searchController.add(text);
                      })),
              const Spacer(),
              IconButton(
                onPressed: () {
                  currentSearch.clear();
                },
                icon: const Icon(Icons.clear),
              )
            ])),
        body: ShowSearchResultsAlmanak(stream: _searchController.stream));
  }
}
