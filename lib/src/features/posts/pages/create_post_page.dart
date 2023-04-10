import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/topic.dart';
import 'package:routemaster/routemaster.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  CreatePostPageState createState() {
    return CreatePostPageState();
  }
}

class CreatePostPageState extends ConsumerState<CreatePostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Topic selectedTopic = Topic.wandelGangen; // default value
  String title = '';
  String content = '';

  static const int maxTitleLength = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nieuwe post'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            const Text(
              'Categorie',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButtonFormField<Topic>(
              items: [Topic.wandelGangen]
                  .map(
                    (topic) => DropdownMenuItem<Topic>(
                      value: topic,
                      child: Text(topic.name),
                    ),
                  )
                  .toList(),
              onChanged: null,
              value: selectedTopic,
              validator: (value) =>
                  value == null ? 'Kies alsjeblieft een onderwerp.' : null,
            ),
            const Text(
              'Titel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) => value == null || value.isEmpty
                  ? 'Vul alsjeblieft een berichttitel in.'
                  : null,
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
              validator: (value) => value == null || value.isEmpty
                  ? 'Vul alsjeblieft een berichtinhoud in.'
                  : null,
              onChanged: (value) => content = value,
            ),
            ElevatedButton(
              onPressed: submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    PostService.create(
      topic: selectedTopic,
      title: title,
      content: content,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Niewe post aangemaakt!')),
    );

    Routemaster.of(context).pop();
  }
}
