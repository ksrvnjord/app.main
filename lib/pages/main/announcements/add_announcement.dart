import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class AddAnnouncementPage extends StatefulHookConsumerWidget {
  const AddAnnouncementPage({
    Key? key,
  }) : super(key: key);


  @override
  AddAnnouncementForm createState() => AddAnnouncementForm();
}

class AddAnnouncementForm extends ConsumerState<AddAnnouncementPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: 'AddAnnouncementForm');
  final _title = TextEditingController();
  final _value = TextEditingController();

  final EdgeInsets elemPadding = const EdgeInsets.fromLTRB(5, 10, 5, 10);

  String _preview = "";

  void showMarkDownPreview()
  {
    setState(() {
      _preview = _value.text;
    });
  }

  @override
  void initState() {
    super.initState();

    _value.addListener(showMarkDownPreview);
  }

  // @override
  // void dispose() {
  //   // Get rid of the resources we allocated
  //   _title.dispose();
  //   _value.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Nieuwe Aankondiging'),
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: elemPadding,
                  child: TextFormField(
                    controller: _title,
                    autocorrect: true,
                    decoration: const InputDecoration(
                      hintText: 'Aankondiging titel',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  padding: elemPadding,
                  child: MarkdownTextInput(
                    // We do not use the onChanged method (which is required),
                    // but the controller to listen for changes.
                    (String value) {},
                    '',
                    controller: _value,
                    label: 'Inhoud als Markdown',
                  ),
                ),
                Container(
                  padding: elemPadding,
                  alignment: Alignment.centerLeft,
                  child: const Text("Voorbeeld van de inhoud van de aankondiging:"),
                ),
                // TODO: make scrollable, now it just overflows if the content
                //       is large enough.
                Expanded(
                  child: Markdown(
                    data: _preview,
                    selectable: false,
                    shrinkWrap: true,  
                  )
                )
              ],
            ),
          ),
        )
    );
  }
}

