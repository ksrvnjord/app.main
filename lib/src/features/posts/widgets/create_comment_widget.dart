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
            contentPadding: EdgeInsets.all(8.0),
            hintText: 'Commenteer op deze post...',
            fillColor: Colors.white,
            filled: true,
            hintStyle: TextStyle(
              color: Colors.black26,
            ),
            border: InputBorder.none,
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Je hebt niks ingevoerd' : null,
          onSaved: (newValue) => _commentContent = newValue ?? '',
          maxLines: null,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          maxLength: inputMaxLength,
        ).expanded(),
        InkWell(
          onTap: submitForm,
          child: const Icon(
            Icons.send,
            color: Colors.lightBlue,
          ).padding(all: sendIconPadding),
        ), // expand in the cross axis
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
