import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ksrvnjord_main_app/widgets/me/verification_dialog.dart';

class AmendableUserField extends StatefulWidget {
  AmendableUserField(this.label, this.value, this.width, this.callBack,
      {Key? key})
      : super(key: key);

  final Map<String, dynamic> label;
  final Map<String, dynamic> value;
  final double width;
  final Function callBack;

  @override
  _AmendableUserFieldState createState() => _AmendableUserFieldState();
}

class _AmendableUserFieldState extends State<AmendableUserField> {
  Map initialText(private, update, change) {
    if (update == null) {
      return ({'text': '-', 'font': FontStyle.normal, 'color': Colors.black});
    } else if (update != change) {
      return ({'text': change, 'font': FontStyle.normal, 'color': Colors.blue});
    } else if (update == private) {
      return ({
        'text': update,
        'font': FontStyle.normal,
        'color': Colors.black
      });
    } else {
      return ({
        'text': update,
        'font': FontStyle.italic,
        'color': Colors.black
      });
    }
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
  bool enabled = false;

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    textcontroller.text = initialText(widget.value['private'],
        widget.value['update'], widget.value['change'])['text'];
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
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.label['display'] ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          const SizedBox(height: 3),
          SizedBox(
              height: 15,
              width: widget.width,
              child: TextField(
                enabled: enabled,
                focusNode: focusNode,
                keyboardType: decideKeyboard(widget.label['backend']),
                decoration: const InputDecoration(border: InputBorder.none),
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
                  widget.callBack(widget.label['backend'], textcontroller.text);
                },
              )),
        ],
      ),
      const Spacer(),
      IconButton(
          padding: const EdgeInsets.all(0),
          constraints: const BoxConstraints(),
          iconSize: 20,
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () {
            Timer(const Duration(milliseconds: 20), () {
              focusNode.requestFocus();
            });
            setState(() {
              enabled = true;
            });
          }),
    ]);
    //const Divider(
    //  color: Colors.grey,
    //  thickness: 1,
    //]);
  }
}
