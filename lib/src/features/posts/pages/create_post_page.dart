import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';
import 'package:routemaster/routemaster.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  CreatePostPageState createState() {
    return CreatePostPageState();
  }
}

class CreatePostPageState extends State<CreatePostPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  String selectedTopic = '';
  String title = '';
  String content = '';

  static const int maxTitleLength = 40;

  QuerySnapshot? topicsSnapshot;
  @override
  Widget build(BuildContext context) {
    Routemaster navigator = Routemaster.of(context);
    CollectionReference postTopicsRef =
        FirebaseFirestore.instance.collection('postTopics');
    CollectionReference postsRef =
        FirebaseFirestore.instance.collection('posts');
    User user = FirebaseAuth.instance.currentUser!;
    var userName = GetIt.I.get<CurrentUser>().user!.fullContact.public;

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
            FutureBuilder(
              future: postTopicsRef.get(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> topicData,
              ) {
                if (!topicData.hasData) {
                  return const CircularProgressIndicator();
                }
                if (topicData.hasError) {
                  return Text(topicData.error.toString());
                } else {
                  return DropdownButtonFormField<String>(
                    items: topicData.data!.docs
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e.id,
                            child: Text(e.id),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => {selectedTopic = value!},
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Kies alsjeblieft een onderwerp.';
                      } else if (value.length > maxTitleLength) {
                        return 'Onderwerp mag niet langer zijn dan 40 karakters.';
                      } else {
                        return null;
                      }
                    }),
                  );
                }
              },
            ),
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
                    'authorName':
                        userName.first_name! + ' ' + userName.last_name!,
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
