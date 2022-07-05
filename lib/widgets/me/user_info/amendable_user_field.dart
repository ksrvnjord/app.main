import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ksrvnjord_main_app/widgets/me/verification_dialog.dart';

class AmendableUserField extends StatefulWidget {
  AmendableUserField(this.label, this.value, this.fieldWidth, this.callBack,
      {Key? key})
      : super(key: key);

  final Map<String, dynamic> label;
  final Map<String, dynamic> value;
  final double fieldWidth;
  final Function callBack;

  @override
  _AmendableUserFieldState createState() => _AmendableUserFieldState();
}

class _AmendableUserFieldState extends State<AmendableUserField> {
  Map initialText(private, update, change) {
    var field = {
      'text': private ?? '-',
      'font': FontStyle.normal,
      'color': Colors.black
    };

    if (change != null && change != private && change != update) {
      field['text'] = change;
      field['color'] = Colors.blue;
      field['font'] = FontStyle.italic;
    } else if (update != null && update != private) {
      field['text'] = update;
      field['font'] = FontStyle.italic;
    }

    return field;
  }

  TextInputType decideKeyboard(label) {
    if (label == 'email') {
      return (TextInputType.emailAddress);
    } else if (label == 'housenumber') {
      return (TextInputType.number);
    } else {
      return (TextInputType.text);
    }
  }

  TextEditingController textcontroller = TextEditingController();
  ScrollController scrollcontroller = ScrollController();
  bool enabled = false;

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    String initialValue = initialText(widget.value['private'],
        widget.value['update'], widget.value['change'])['text'];
    textcontroller.text = initialValue;
    textcontroller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: initialValue.length,
    );
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return //Column(children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label['display'] ?? '-',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
              const SizedBox(height: 3),
              SizedBox(
                  width: widget.fieldWidth - 20,
                  height: 15,
                  child: CupertinoTextField(
                    enabled: enabled,
                    focusNode: focusNode,
                    padding: const EdgeInsets.all(0),
                    keyboardType: decideKeyboard(widget.label['backend']),
                    scrollController: scrollcontroller,
                    decoration: const BoxDecoration(border: null),
                    style: TextStyle(
                        color: initialText(
                            widget.value['private'],
                            widget.value['update'],
                            widget.value['change'])['color'],
                        fontSize: 13,
                        fontStyle: initialText(
                            widget.value['private'],
                            widget.value['update'],
                            widget.value['change'])['font']),
                    controller: textcontroller,
                    onSubmitted: (value) {
                      enabled = false;
                      textcontroller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: textcontroller.text.length,
                      );
                      widget.callBack(
                          widget.label['backend'], textcontroller.text);
                    },
                  )),
            ],
          ),
          //const Spacer(),
          IconButton(
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(),
              iconSize: 20,
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                Timer(const Duration(milliseconds: 50), () {
                  focusNode.requestFocus();
                });
                setState(() {
                  enabled = true;
                });
              }),
        ]);
  }
}
