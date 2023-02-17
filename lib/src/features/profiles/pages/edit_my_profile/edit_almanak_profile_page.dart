import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/widgets/edit_almanak_form.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/edit_profile_picture_widget.dart';
import 'package:routemaster/routemaster.dart';

final storage = FirebaseStorage.instance;

class EditAlmanakProfilePage extends StatefulWidget {
  const EditAlmanakProfilePage({Key? key}) : super(key: key);

  @override
  createState() => _EditAlmanakProfilePageState();
}

class _EditAlmanakProfilePageState extends State<EditAlmanakProfilePage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  void goToVisibilityPage(BuildContext context) {
    Routemaster.of(context).push('visibility');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wijzig mijn almanak profiel'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility_outlined),
            onPressed: () => goToVisibilityPage(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            Center(child: EditProfilePictureWidget()),
            EditAlmanakForm(),
          ],
        ),
      ),
    );
  }
}
