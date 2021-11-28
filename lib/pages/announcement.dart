import 'package:flutter/material.dart';

var announcement = { // Mock announcement
  "name": "RP3s tijdelijk uit de vaart",
  "content":
      "## De RP3s zijn tijdelijk uit de vaart \n\n Zegt het voort, het blijkt dat ergo's daadwerkelijk kunnen drijven, garandeer uzelf van een training en zet uit op een C2 - bij een vaarverbod kunt u alsnog trainen. \n\n Wegens het glijdende momentum van de RP3s zijn er ankers besteld voor de bankjes, zodra deze binnen zijn worden de RP3s weer ingezet.",
  "timestamp": "2021-11-23 17:26:00",
  "author": {"name": "J. Brummer", "role": "Empacher Commissie"}
};

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mededeling'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.white,
            child: Center(child: Text(announcement['name'] as String)),
          ),
          Container(
            color: Colors.white,
            child: Center(child: Text(announcement['content'] as String)),
          ),
        ],
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
