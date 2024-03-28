import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartnersPage extends ConsumerWidget {
  const PartnersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Partners & Sponsors")),
      body: ListView(
        children: const [
          ListTile(title: Text("Partners")),
          ListTile(title: Text("Natura Sponsors")),
        ],
      ),
    );
  }
}
