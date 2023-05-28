import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';
import 'package:styled_widget/styled_widget.dart';

class CreateCommentWidget extends StatefulWidget {
  const CreateCommentWidget({
    Key? key,
    required this.postDocId,
  }) : super(key: key);

  final String postDocId;

  @override
  CreateCommentWidgetState createState() => CreateCommentWidgetState();
}

class CreateCommentWidgetState extends State<CreateCommentWidget> {
  static const double sendIconPadding = 8;

  final _formKey = GlobalKey<FormState>();

  String _commentContent = '';

  @override
  Widget build(BuildContext context) {
    const inputMaxLength = 1726;

    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Schrijf een reactie...',
            contentPadding: const EdgeInsets.all(8.0),
            filled: true,
            fillColor: colorScheme.surfaceVariant,
            border: InputBorder.none,
          ),
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          maxLines: null,
          maxLength: inputMaxLength,
          onSaved: (newValue) => _commentContent = newValue ?? '',
          validator: (value) =>
              value == null || value.isEmpty ? 'Je hebt niks ingevoerd' : null,
        ).expanded(),
        InkWell(
          // ignore: sort_child_properties_last
          child: const Icon(Icons.send).padding(all: sendIconPadding),
          onTap: submitForm,
        ), // Expand in the cross axis.
      ].toRow().backgroundColor(colorScheme.surfaceVariant),
    );
  }

  void submitForm() async {
    final formState = _formKey.currentState;
    if (formState != null && !formState.validate()) {
      return;
    }
    formState?.save(); // Save the form.

    // ignore: avoid-ignoring-return-values
    await Comment.createComment(
      content: _commentContent,
      postId: widget.postDocId,
    );

    formState?.reset(); // Reset the form.
  }
}
