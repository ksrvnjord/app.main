import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:provider/provider.dart';

class ShowTrainingPage extends StatelessWidget {
  const ShowTrainingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainingen'),
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: Container(),
    );
  }
}
