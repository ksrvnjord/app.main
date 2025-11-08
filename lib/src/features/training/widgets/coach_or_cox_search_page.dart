import 'package:flutter/material.dart';

class CoachOrCoxSearchPage extends StatelessWidget {
  const CoachOrCoxSearchPage({super.key, required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('${role[0].toUpperCase()}${role.substring(1)} zoeken')),
      body: Center(child: Text('Zoekpagina voor $role')),
    );
  }
}
