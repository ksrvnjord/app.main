import 'package:flutter/material.dart';

class Vaarverbod extends StatelessWidget {
  const Vaarverbod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vaarverbod'),
        ),
        body: Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('hallo'),
            )));
  }
}
