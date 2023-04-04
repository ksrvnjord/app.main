import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  AddPostState createState() {
    return AddPostState();
  }
}

class AddPostState extends State<AddPost> {
  final GlobalKey<FormState> _key = GlobalKey();
  String selectedTopic = 'coaching';
  String title = '';
  String content = '';
  List topics = ['coaching', 'test'];

  QuerySnapshot? topicsSnapshot;
  @override
  Widget build(BuildContext context) {
    Routemaster navigator = Routemaster.of(context);
    CollectionReference postsRef =
        FirebaseFirestore.instance.collection('posts');
    User user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nieuw post'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            const Text(
              'Onderwerp',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButtonFormField<String>(
                items: topics
                    .map(
                      (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
                    )
                    .toList(),
                onChanged: (value) => {selectedTopic = value!},
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Kies alsjeblieft een onderwerp.';
                  } else {
                    return null;
                  }
                })),
            const Text(
              'Titel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty || value == '') {
                  return 'Vul alsjeblieft een berichttitel in.';
                }
                return null;
              },
              onChanged: (value) => title = value,
            ),
            const Text(
              'Inhoud',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty || value == '') {
                  return 'Vul alsjeblieft een berichtinhoud in.';
                }
                return null;
              },
              onChanged: (value) => content = value,
            ),
            ElevatedButton(
              onPressed: () {
                if (_key.currentState!.validate()) {
                  postsRef.add({
                    'authorId': user.uid,
                    'authorName': user.uid,
                    'content': content,
                    'createdTime': DateTime.now(),
                    'likes': [],
                    'title': title,
                    'topic': selectedTopic
                  });
                  navigator.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Niewe post aangemaakt!')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
