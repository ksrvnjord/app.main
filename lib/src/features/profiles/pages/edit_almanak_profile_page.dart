import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_upload_widget.dart';

final storage = FirebaseStorage.instance;

class EditAlmanakProfilePage extends StatefulWidget {
  const EditAlmanakProfilePage({Key? key}) : super(key: key);

  @override
  createState() => _EditAlmanakProfilePageState();
}

class _EditAlmanakProfilePageState extends State<EditAlmanakProfilePage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wijzig mijn almanak profiel'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: FutureBuilder(
            future: getMyProfilePicture(),
            builder: (context, snapshot) {
              Image initialImage;

              if (snapshot.hasError) {
                initialImage = Image.asset(Images.placeholderProfilePicture);

                return EditProfilePictureWidget(
                  initialImage: initialImage,
                );
              } else if (snapshot.hasData) {
                initialImage = Image.memory(snapshot.data as Uint8List);

                return EditProfilePictureWidget(
                  initialImage: initialImage,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
