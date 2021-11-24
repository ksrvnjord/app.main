import 'package:flutter/material.dart';
import 'package:ksrv_njord_app/assets/images.dart';
import 'package:ksrv_njord_app/widgets/app_icon_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppIconWidget(image: Images.appLogo),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/auth');
          },
          child: const Text('Launch screen'),
        ),
      ),
    );
  }
}
