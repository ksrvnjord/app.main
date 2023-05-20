import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_topics_provider.dart';
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

  bool postCreationInProgress = false;

  @override
  void initState() {
    super.initState();
    selectedTopic = ref.read(postTopicsProvider).elementAt(1);
  }

  @override
  Widget build(BuildContext context) {
    const int maxTitleLength = 40;
    const int maxContentLength = 1726;
    const double submitButtonHPadding = 12;

    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nieuwe post'),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.lightBlue,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.lightBlue,
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              [
                DropdownButtonFormField<String>(
                  items: ref
                      .watch(postTopicsProvider)
                      .map((topic) => DropdownMenuItem<String>(
                            value: topic,
                            child: Text(topic),
                          ))
                      .toList(),
                  value: selectedTopic,
                  onChanged: (value) => selectedTopic = value ?? 'Wandelgangen',
                  decoration: const InputDecoration(
                    labelText: 'Categorie',
                    hintText: 'Selecteer een categorie',
                  ),
                  onSaved: (newValue) =>
                      selectedTopic = newValue ?? 'Wandelgangen',
                  validator: (value) =>
                      value == null ? 'Kies alsjeblieft een onderwerp.' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Titel',
                    hintText: 'Coach gezocht voor morgen om 7:00',
                  ),
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLength: maxTitleLength,
                  onSaved: (value) => title = value ?? '',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Je titel mist!' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Inhoud',
                    hintText: "Om 7:00 's ochtends heb je toch niks te doen",
                  ),
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  maxLength: maxContentLength,
                  onSaved: (value) => content = value ?? '',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Zonder inhoud kom je nergens.'
                      : null,
                ),
                ElevatedButton(
                  onPressed: postCreationInProgress ? null : () => submitForm(),
                  style: ElevatedButton.styleFrom(
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
                      .toRow(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      )
                      .padding(vertical: submitButtonHPadding),
                ),
              ].toColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                separator: const SizedBox(height: 16),
              ),
            ],
          ),
        ),
      ),
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
    // ignore: avoid-ignoring-return-values
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Niewe post aangemaakt!')),
    );

    // ignore: avoid-ignoring-return-values
    Routemaster.of(context).pop();
  }
}
