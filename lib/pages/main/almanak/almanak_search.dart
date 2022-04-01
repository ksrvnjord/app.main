import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/almanak/almanak_list.dart';
import 'package:ksrvnjord_main_app/widgets/almanak/almanak_show_results.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';
import 'package:ksrvnjord_main_app/widgets/utilities/development_feature.dart';
import 'package:flutter/services.dart';

import 'almanak_profile.dart';

const String users = r'''
  query {
    users {
      data {
        id,
        email,
        username,
        contact {
          first_name,
          last_name
        }
      }
    }
  }
''';

class _LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: false,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
        body: const Loading());
  }
}

class AlmanakSearch extends StatefulWidget {
  AlmanakSearch({Key? key}) : super(key: key);

  @override
  _AlmanakSearchState createState() => _AlmanakSearchState();
}

class _AlmanakSearchState extends State<AlmanakSearch> {
  final StreamController<String> _searchController = StreamController<String>();
  TextEditingController currentSearch = TextEditingController();

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
        body: ShowResults(stream: _searchController.stream));
  }
}
