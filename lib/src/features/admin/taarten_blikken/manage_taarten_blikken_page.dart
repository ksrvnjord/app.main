import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/admin/taarten_blikken/taarten_blikken_form_widget.dart';

class ManageTaartenBlikkenPage extends StatelessWidget {
  const ManageTaartenBlikkenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beheer taarten/blikken'),
      ),
      body: const TaartenBlikkenCounters(),
    );
  }
}
