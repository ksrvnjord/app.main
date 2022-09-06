import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input({Key? key, this.label = 'Veld', this.controller})
      : super(key: key);
  final String label;
  final TextEditingController? controller;

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: false,
      autocorrect: false,
      enableSuggestions: false,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.label,
      ),
    );
  }
}
