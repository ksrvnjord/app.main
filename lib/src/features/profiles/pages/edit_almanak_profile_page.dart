import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditAlmanakProfilePage extends StatefulWidget {
  const EditAlmanakProfilePage({Key? key}) : super(key: key);

  @override
  _EditAlmanakProfilePageState createState() => _EditAlmanakProfilePageState();
}

class _EditAlmanakProfilePageState extends State<EditAlmanakProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wijzig mijn almanak profiel'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: const Center(
        child: Text('Edit Almanak Profile'),
      ),
    );
  }
}
