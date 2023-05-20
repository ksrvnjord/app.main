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

    return Form(
      key: _formKey,
      child: [
        TextFormField(
            decoration: const InputDecoration(
                hintText: 'Commenteer op deze post...',
                hintStyle: TextStyle(color: Colors.black26),
                contentPadding: EdgeInsets.all(8.0),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none),
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: null,
            maxLength: inputMaxLength,
            onSaved: (newValue) => _commentContent = newValue ?? '',
            validator: (value) => value == null || value.isEmpty
                ? 'Je hebt niks ingevoerd'
                : null).expanded(),
        InkWell(
            child: const Icon(Icons.send, color: Colors.lightBlue)
                .padding(all: sendIconPadding),
            onTap: submitForm), // expand in the cross axis
      ].toRow().backgroundColor(Colors.white),
    );
  }

  void submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save(); // save the form

    Comment.createComment(content: _commentContent, postId: widget.postDocId);

    _formKey.currentState!.reset(); // reset the form
  }
}
