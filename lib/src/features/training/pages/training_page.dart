import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_home_nav.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_list.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Routemaster navigator = Routemaster.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Afschrijvingen'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: <Widget>[
        const TrainingList().expanded(),
        // const TrainingHomeNav(),
      ].toColumn(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigator.push('all'),
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
