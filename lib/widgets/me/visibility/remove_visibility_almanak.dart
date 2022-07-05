import 'package:flutter/material.dart';

// THIS WIDGET EVENTUALLY HAS TO QUERY THE DATABASE FOR ALL GROUPS!!!!!!!!!!!!

class RemoveVisibilityAlmanak extends StatefulWidget {
  RemoveVisibilityAlmanak(
    this.listed,
    this.callBack, {
    Key? key,
  }) : super(key: key);

  bool listed;
  final Function callBack;

  @override
  _RemoveVisibilityAlmanakState createState() =>
      _RemoveVisibilityAlmanakState();
}

class _RemoveVisibilityAlmanakState extends State<RemoveVisibilityAlmanak> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Ik wil helemaal niet zichtbaar zijn',
          style: TextStyle(fontSize: 16),
        ),
        const Spacer(),
        Switch(
            value: widget.listed,
            onChanged: (value) {
              widget.callBack(value);
              setState(() {
                widget.listed = value;
              });
            })
      ],
    );
  }
}
