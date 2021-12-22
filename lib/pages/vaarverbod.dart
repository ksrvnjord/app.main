import 'package:flutter/material.dart';

const Map info_vaarverbod = {"status": true, "message": "Het is veel te koud."};

class Vaarverbod extends StatelessWidget {
  const Vaarverbod({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vaarverbod'),
        ),
        body: Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Vaarverbod_full()));
              },
              child: info_vaarverbod['status']
                  ? Text('vaarverbod')
                  : Text('geen vaarverbod'),
            )));
  }
}

class Vaarverbod_full extends StatelessWidget {
  const Vaarverbod_full({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaarverbod'),
      ),
      body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            info_vaarverbod['status']
                ? const Text('Er is een vaarverbod',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.red))
                : const Text('Er is geen vaarverbod',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.green)),
            const SizedBox(height: 40),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  const TextSpan(
                      text: 'Reden: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  TextSpan(
                      text: info_vaarverbod['message'],
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
            )
          ])),
    );
  }
}
