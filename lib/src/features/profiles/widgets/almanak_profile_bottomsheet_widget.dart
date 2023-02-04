import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakProfileBottomsheetWidget extends StatelessWidget {
  final String label;
  final String value;

  const AlmanakProfileBottomsheetWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return [
      Text(label, style: const TextStyle(color: Colors.blueGrey))
          .padding(vertical: 10, bottom: 0),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600))
          .padding(all: 10, bottom: 20),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        ),
        child: const ListTile(
          leading: Icon(Icons.copy),
          title: Text('Kopieer'),
        ),
        onPressed: () =>
            Clipboard.setData(ClipboardData(text: value)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tekst gekopieerd')),
          );
        }),
      ),
    ].toColumn(mainAxisSize: MainAxisSize.min);
  }
}
