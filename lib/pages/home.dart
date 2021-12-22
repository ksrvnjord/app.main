import 'package:flutter/material.dart';
import 'package:ksrv_njord_app/widgets/general/vaarverbod.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: const [VaarverbodWidget()]),
    );
  }
}
