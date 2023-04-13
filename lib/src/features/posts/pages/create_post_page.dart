import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_topics_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/selected_topic_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  CreatePostPageState createState() {
    return CreatePostPageState();
  }
}

class CreatePostPageState extends ConsumerState<CreatePostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String selectedTopic = ""; // default value
  String title = '';
  String content = '';

  static const int maxTitleLength = 40;

  bool postCreationInProgress = false;

  @override
  void initState() {
    super.initState();
    selectedTopic = ref.read(selectedTopicProvider); // read topic once on init
  }

  @override
  Widget build(BuildContext context) {
    const int maxTitleLength = 40;
    const int maxContentLength = 1726;
    const double submitButtonHPadding = 12;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              [
                DropdownButtonFormField<String>(
                  // no point in showing it for now if there's only one option
                  decoration: const InputDecoration(
                    hintText: 'Selecteer een categorie',
                    labelText: 'Categorie',
                  ),
                  items: ref
                      .watch(postTopicsProvider)
                      .map(
                        (topic) => DropdownMenuItem<String>(
                          value: topic,
                          child: Text(topic),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => selectedTopic = value ?? 'Wandelgangen',
                  onSaved: (newValue) =>
                      selectedTopic = newValue ?? 'Wandelgangen',
                  value: selectedTopic,
                  validator: (value) =>
                      value == null ? 'Kies alsjeblieft een onderwerp.' : null,
                ),
                TextFormField(
                  maxLength: maxTitleLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  // The validator receives the text that the user has entered.
                  decoration: const InputDecoration(
                    hintText: 'Coach gezocht voor morgen om 7:00',
                    labelText: 'Titel',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Je titel mist!' : null,
                  onSaved: (value) => title = value ?? '',
                ),
                TextFormField(
                  maxLines: null,
                  maxLength: maxContentLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: const InputDecoration(
                    hintText: "Om 7:00 's ochtends heb je toch niks te doen",
                    labelText: 'Inhoud',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) => value == null || value.isEmpty
                      ? 'Zonder inhoud kom je nergens.'
                      : null,
                  onSaved: (value) => content = value ?? '',
                ),
                ElevatedButton(
                  onPressed: postCreationInProgress ? null : () => submitForm(),
                  style: ElevatedButton.styleFrom(
                    // add rounding
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: <Widget>[
                    Icon(postCreationInProgress
                            ? LucideIcons.loader
                            : LucideIcons.send)
                        .padding(bottom: 1),
                    Text(
                      postCreationInProgress ? "Zwanen voeren..." : 'Verstuur',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ]
                      .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                      .padding(vertical: submitButtonHPadding),
                ),
              ].toColumn(
                // use column inside listview so we can specify separator
                crossAxisAlignment: CrossAxisAlignment.start,
                separator: const SizedBox(height: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    postCreationInProgress = true;

    await PostService.create(
      topic: selectedTopic,
      title: title,
      content: content,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Niewe post aangemaakt!')),
    );

    Routemaster.of(context).pop();
  }
}
