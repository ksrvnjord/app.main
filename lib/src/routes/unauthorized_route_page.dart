import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:styled_widget/styled_widget.dart';

class UnauthorizedRoutePage extends StatelessWidget {
  const UnauthorizedRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    const double padding = 16;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Onbevoegde toegang'),
      ),
      body: [
        Text(
          'Je hebt niet de juiste rechten om deze pagina te bekijken.',
          style: textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ).padding(all: padding),
        Text(
          'Contacteer de Appcommissie voor meer informatie.',
          style: textTheme.labelLarge,
          textAlign: TextAlign.center,
        ).padding(horizontal: padding),
        Image.asset(
          Images.unknownRoute404,
          fit: BoxFit.cover,
        ),
      ].toColumn(
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.home),
        label: const Text('Go to Dashboard'),
      ),
    );
  }
}
