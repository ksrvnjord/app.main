import 'package:flutter/material.dart';
import 'package:ksrv_njord_app/pages/announcement.dart';

var announcements = [
  {
    "name": "RP3s tijdelijk uit de vaart",
    "content":
        "Zegt het voort, het blijkt dat ergo's daadwerkelijk kunnen drijven, garandeer uzelf van een training en zet uit op een C2 - bij een vaarverbod kunt u alsnog trainen. \n\n Wegens het glijdende momentum van de RP3s zijn er ankers besteld voor de bankjes, zodra deze binnen zijn worden de RP3s weer ingezet.",
    "timestamp": "2021-11-23 17:26:00",
    "author": {"name": "J. Brummer", "role": "Empacher Commissie"}
  },
  {
    "name": "Sinterklaas op Njord",
    "content":
        "Zegt het voort, het blijkt dat Sinterklaas en Roetveegregenboogpiet langskomen op de KSRV. \n\n Zet je schoen komende week bij de haard voor mogelijk een verassing",
    "timestamp": "2021-29-11 17:26:00",
    "author": {"name": "S.P.S (Bas) Flipse", "role": "Bestuur"}
  },
];

double titleFontSize = 28;
double contentFontSize = 22;
double paddingBody = 10;

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mededelingen'),
      ),
      body: Padding(
        // Add padding to whole body
        padding: EdgeInsets.all(paddingBody),
        child: ListView.builder(
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(announcements[index]['name'] as String),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnnouncementPage(
                            announcement: announcements[index])),
                  );
                });
          },
        ),
      ),
    );
  }
}
