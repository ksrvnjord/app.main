import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddAnnouncementPage extends HookConsumerWidget {
  const AddAnnouncementPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Nieuwe Aankondiging'),
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
        ),
    );
  }
}