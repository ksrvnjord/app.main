import 'package:flutter/material.dart';

class CoachOrCoxRegisterPage extends StatelessWidget {
  const CoachOrCoxRegisterPage({super.key, required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zichtbaar worden als $role')),
      body: Center(child: Text('Registratiepagina voor $role')),
    );
  }
}
