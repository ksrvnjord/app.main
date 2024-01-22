import 'package:flutter/material.dart';

class ShowFormResultsInfoBox extends StatelessWidget {
  const ShowFormResultsInfoBox({
    Key? key,
    required this.field,
    required this.value,
  }) : super(key: key);

  final String field;
  final String value;

  @override
  Widget build(BuildContext context) {
    double edgeInsets = 8.0;
    double sizedBoxWidth = 8.0;

    return Padding(
      padding: EdgeInsets.all(edgeInsets),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                field,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: sizedBoxWidth),
              Text(value),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
