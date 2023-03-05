import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_list.dart';
import 'package:routemaster/routemaster.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.report),
            onPressed: () => navigator.push('all/damages'),
          ),
        ],
      ),
      body: const TrainingList(),
      floatingActionButton: FirebaseAuth.instance.currentUser !=
              null // only show button if user is logged in
          ? FloatingActionButton.extended(
              onPressed: () => navigator.push('all'),
              backgroundColor: Colors.lightBlue,
              icon: const Icon(Icons.add),
              label: const Text('Afschrijving toevoegen'),
            )
          : null,
    );
  }
}
