import 'package:flutter/material.dart';

// Map announcement = {
//   // Mock announcement
//   "name": "RP3s tijdelijk uit de vaart",
//   "content":
//       "## De RP3s zijn tijdelijk uit de vaart \n\n Zegt het voort, het blijkt dat ergo's daadwerkelijk kunnen drijven, garandeer uzelf van een training en zet uit op een C2 - bij een vaarverbod kunt u alsnog trainen. \n\n Wegens het glijdende momentum van de RP3s zijn er ankers besteld voor de bankjes, zodra deze binnen zijn worden de RP3s weer ingezet.",
//   "timestamp": "2021-11-23 17:26:00",
//   "author": {"name": "J. Brummer", "role": "Empacher Commissie"}
// };

double titleFontSize = 28;
double contentFontSize = 22;
double paddingBody = 10;

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({
    Key? key,
    required this.announcement,
  }) : super(key: key);

  final Map announcement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mededeling'),
      ),
      body: Padding(
        // Add padding to whole body
        padding: EdgeInsets.all(paddingBody),
        child: ListView(
          children: <Widget>[
            Container(
              // Title Container
              height: 40,
              color: Colors.white,
              child: Center(
                child: Text(
                  announcement['name'] as String,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              // Author
              height: 40,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text((announcement["author"] as Map)["name"] as String),
                      Text((announcement["author"] as Map)["role"] as String),
                    ],
                  ),
                  Text(announcement['timestamp'] as String),
                ],
              ),
            ),
            Container(
              // Content
              color: Colors.white,
              child: Center(
                child: Text(announcement['content'] as String,
                    style: TextStyle(fontSize: contentFontSize)),
              ),
            ),
          ],
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
