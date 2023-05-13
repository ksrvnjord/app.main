import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditGroupsPage extends ConsumerWidget {
  const EditGroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
        title: const Text(
          'Mijn ploegen',
        ), // TODO: in the future make this My groups as this page will serve as a hub for all groups
      ),
      body: const Center(
        child: Text('Mijn groepen'),
      ),
    );
  }
}
