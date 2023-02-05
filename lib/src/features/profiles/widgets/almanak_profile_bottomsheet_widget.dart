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
    const double textPadding = 8;

    const double labelSize = 16;
    const double valueSize = 20;

    return [
      Text(
        label,
        style: const TextStyle(
          fontSize: labelSize,
          color: Colors.blueGrey,
        ),
      ).padding(all: textPadding, bottom: 0),
      Text(
        value,
        style: const TextStyle(
          fontSize: valueSize,
          fontWeight: FontWeight.w600,
        ),
      ).padding(all: textPadding, top: 0),
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
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Tekst gekopieerd'),
            ),
          );
        }),
      ),
    ].toColumn(mainAxisSize: MainAxisSize.min);
  }
}
