import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_card.dart';

class FormsPage extends StatelessWidget {
  const FormsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
      ),
      body: FirestorePagination(
        query: formsCollection.orderBy('OpenUntil', descending: true),
        itemBuilder: (context, snap, index) => FormCard(formDoc: snap),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        isLive: true,
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
