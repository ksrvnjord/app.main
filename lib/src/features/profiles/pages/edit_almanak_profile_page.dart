import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    final Reference userRef = storage.ref().child(userId);
    final Reference profilePictureRef = userRef.child('profile_picture.png');
    
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
          child: ImagePickerWidget(
            diameter: 240,
            initialImage: const AssetImage(Images.placeholderProfilePicture),
            shape:
                ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
            isEditable: true,
            onChange: (File file) async {
              try {
                await profilePictureRef.putFile(file);
                Fluttertoast.showToast(
                    msg: "Your profile picture was updated successfully");
              } on FirebaseException catch (e) {
                Fluttertoast.showToast(
                    msg: "Error updating your profile picture");
                log(e.toString());
              }
            },
          ),
        ),
      ),
    );
  }
}
