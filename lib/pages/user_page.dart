import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrv_njord_app/assets/images.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:ksrv_njord_app/widgets/app_icon_widget.dart';

double betweenFields = 20;
double marginContainer = 5;
double paddingBody = 15;

class MePage extends StatelessWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AppIconWidget(image: Images.appLogo),
        ),
        body: ListView(padding: EdgeInsets.all(paddingBody), children: <Widget>[
          SizedBox(height: 10),
          Center(
            child: profile_picture(),
          ),
          SizedBox(height: 20),
          display_static_information('Naam', 'Pim Veefkind'),
          display_static_information('Lidnummer', '18257'),
          display_static_information('Geboortedatum', '25-03-2000'),
          display_amendable_information('Telefoonnummer', '0629110215'),
          display_amendable_information(
              'E-mailadres', 'pim.veefkind@gmail.com'),
          display_amendable_information(
              'Adres', 'Schubertlaan 201, 2324CT Leiden'),
          display_static_information('Jaar van aankomst', '2018'),
          display_amendable_information('Ploeg', 'Clavis'),
          display_amendable_information('Studie', 'Natuurkunde'),
          display_amendable_information('IBAN', 'NL19 AWRD 8943 1193 10'),
          display_amendable_information('Dubbellid', 'Nee'),
          display_amendable_information('Aantal blikken', '0'),
          display_amendable_information('Aantal taarten', '0'),
        ]));
  }
}

class profile_picture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Expanded(
        child: FittedBox(
          fit: BoxFit.fill,
          child: const Icon(
            Icons.account_circle_rounded,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class display_amendable_information extends StatelessWidget {
  final String info_kind;
  final String user_info;

  display_amendable_information(this.info_kind, this.user_info);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                info_kind,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
              SizedBox(height: 3),
              Text(user_info),
            ],
          ),
        ),
        IconButton(
            iconSize: 20,
            icon: Icon(Icons.edit, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => change_information()));
            }),
      ]),
      const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    ]);
  }
}

class display_static_information extends StatelessWidget {
  final String info_kind;
  final String user_info;

  display_static_information(this.info_kind, this.user_info);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          info_kind,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
        SizedBox(height: 3),
        Text(user_info),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ],
    );
  }
}

class change_information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppIconWidget(image: Images.appLogo),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  header_change_information(),
                  const SizedBox(height: 40),
                  text_field_change_information(),
                  const SizedBox(height: 60),
                  buttons_change_information(),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
          const Spacer(),
          const Text(
              'Aanpassingen worden ook doorgevoerd in de algemene administratie. Hierom moet eerst toestemming worden gegeven voor een verandering. Het kan even duren voordat de verandering zichtbaar is.'),
        ],
      ),
    );
  }
}

class header_change_information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const Text('Aanpassen Gegeven',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    );
  }
}

class text_field_change_information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Nieuw gegeven',
        ),
      ),
    );
  }
}

class buttons_change_information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          color: Colors.red,
          child: TextButton(
            child: const Text('Annuleren',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Container(
          color: Colors.green,
          child: TextButton(
            child: const Text('Bevestigen',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
