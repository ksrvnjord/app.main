import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/almanak/almanak_show_full.dart';
import 'package:ksrvnjord_main_app/widgets/utilities/development_feature.dart';
import 'almanak_search.dart';

class AlmanakPage extends StatelessWidget {
  const AlmanakPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Almanak'),
        automaticallyImplyLeading: false,
        actions: [
          DevelopmentFeature(
              child: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AlmanakSearch()));
            },
            icon: const Icon(Icons.search),
          ))
        ],
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
      ),
      body: ShowFullAlmanak(),
    );
  }
}
