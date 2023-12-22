import 'package:flutter/material.dart';

class EditCharityTextField extends StatefulWidget {
  const EditCharityTextField({
    Key? key,
    required this.name,
    required this.initialValue,
    required this.controller,
  }) : super(key: key);

  final String name;
  final String initialValue;
  final TextEditingController controller;

  @override
  EditCharityTextFieldState createState() => EditCharityTextFieldState();
}

class EditCharityTextFieldState extends State<EditCharityTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.name,
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
