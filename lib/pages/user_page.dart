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
          Information_field('Naam', 'Pim Veefkind'),
          Information_field('Lidnummer', '18257'),
          Information_field('Geboortedatum', '25-03-2000'),
          Information_field('Telefoonnummer', '0629110215'),
          Information_field('E-mailadres', 'pim.veefkind@gmail.com'),
          Information_field('Adres', 'Schubertlaan 201, 2324CT Leiden'),
          Information_field('Jaar van aankomst', '2018'),
          Information_field('Ploeg', 'Clavis'),
          Information_field('Studie', 'Natuurkunde'),
          Information_field('IBAN', 'NL19 AWRD 8943 1193 10'),
          Information_field('Dubbellid', 'Nee'),
          Information_field('Aantal blikken', '0'),
          Information_field('Aantal taarten', '0'),
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

class Information_field extends StatelessWidget {
  final String info_kind;
  final String user_info;

  Information_field(this.info_kind, this.user_info);

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
        const Icon(Icons.edit, color: Colors.grey, size: 20),
      ]),
      const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    ]);
  }
}
