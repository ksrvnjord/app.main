import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

class CreateEventPage extends ConsumerStatefulWidget {
  const CreateEventPage({super.key});

  @override
  CreateEventPageState createState() {
    return CreateEventPageState();
  }
}

class CreateEventPageState extends ConsumerState<CreateEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nieuw Evenement'),
      ),
      body: const Center(
        child: Text('Nieuw Evenement Pagina - Binnenkort Beschikbaar'),
      ),
    );
  }
}