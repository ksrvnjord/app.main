import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrv_njord_app/assets/images.dart';
import 'package:ksrv_njord_app/widgets/app_icon_widget.dart';

double betweenFields = 20;
double marginContainer = 30;
double paddingBody = 30;

class MePage extends StatelessWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AppIconWidget(image: Images.appLogo),
        ),
        body: Padding(
            // add padding to entire body
            padding: EdgeInsets.all(paddingBody),
            child: Center(
                child: Column(
              children: <Widget>[
                Container(
                    child: Text('Ruimte voor profielfoto'),
                    margin: EdgeInsets.all(marginContainer),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ))),
                Information('Naam:', 'Pim'),
                SizedBox(height: betweenFields),
                Information('e-mail:', 'Pim@gmail.com'),
                SizedBox(height: betweenFields),
                Information('Telefoonnummer:', '02589374'),
              ],
            )
          )
        )
      );
    }
  }

class Information extends StatelessWidget {
  final String info_kind;
  final String user_info;

  const Information(this.info_kind, this.user_info);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: [
          Expanded(child: Text(info_kind)),
          Expanded(
            child:
                Align(alignment: Alignment.centerRight, child: Text(user_info)),
          ),
        ]),
        width: 280,
        padding: EdgeInsets.only(left: 5, bottom: 3, right: 5, top: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.lightBlue,
              width: 2,
            )));
  }
}
