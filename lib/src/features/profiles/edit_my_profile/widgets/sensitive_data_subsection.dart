import 'package:flutter/material.dart';

class SensitiveDataSubsection extends StatelessWidget {
  const SensitiveDataSubsection(this.headerName, {super.key});

  final String headerName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        headerName,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
