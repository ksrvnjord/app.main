import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ksrvnjord_main_app/widgets/me/verification_dialog.dart';

class changeVisibilityField extends StatefulWidget {
  changeVisibilityField(this.label, this.visibility, this.callBack, {Key? key})
      : super(key: key);

  final Map<String, dynamic> label;
  bool? visibility;
  final Function callBack;

  @override
  _changeVisibilityFieldState createState() => _changeVisibilityFieldState();
}

class _changeVisibilityFieldState extends State<changeVisibilityField> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return (Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label['display'],
          style: const TextStyle(fontSize: 14),
        ),
        const Spacer(),
        AbsorbPointer(
            absorbing: !widget.label['is_amendable'],
            child: Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor:
                    widget.label['is_amendable'] ? Colors.blue : Colors.grey,
                side: BorderSide(
                  color:
                      widget.label['is_amendable'] ? Colors.blue : Colors.grey,
                ),
                value: widget.visibility,
                onChanged: (value) {
                  widget.callBack(widget.label['backend'], widget.visibility);
                  setState(() {
                    widget.visibility = value;
                  });
                }))
      ],
    ));
  }
}
