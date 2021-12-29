import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrv_njord_app/assets/images.dart';
import 'package:ksrv_njord_app/widgets/general/vaarverbod.dart';
import 'package:ksrv_njord_app/widgets/images/bar_logo.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const BarLogoWidget(image: Images.appLogo),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
        body: Center(
          child: Column(children: const [VaarverbodWidget()]),
        ));
  }
}
