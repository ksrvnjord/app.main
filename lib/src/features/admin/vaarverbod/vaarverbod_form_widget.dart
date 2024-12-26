// ignore_for_file: prefer-single-declaration-per-file, no-magic-string

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

class VaarverbodFormWidget extends ConsumerStatefulWidget {
  const VaarverbodFormWidget({
    super.key,
    required this.status,
    required this.message,
  });

  final bool status;
  final String message;

  @override
  VaarverbodFormWidgetState createState() => VaarverbodFormWidgetState();
}

class VaarverbodFormWidgetState extends ConsumerState<VaarverbodFormWidget> {
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool status = false;

  @override
  void initState() {
    super.initState();
    status = widget.status;
    _messageController.text = widget.message;
  }

  Future<void> _sendForm() async {
    final dio = ref.watch(dioProvider);
    try {
      // ignore: avoid-ignoring-return-values
      await dio.post(
        '/api/v2/vaarverbod/',
        data: {'message': _messageController.text, 'status': status},
      );
      if (!mounted) return;
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vaarverbod aangepast')),
      );
    } catch (e) {
      if (!context.mounted) return;
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send form: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Vaarverbod'),
                Switch.adaptive(
                  value: status,
                  onChanged: (value) => setState(() {
                    status = value;
                    _messageController.text = status
                        ? "Er is een vaarverbod van kracht"
                        : "Er is geen vaarverbod!";
                  }),
                ),
                const SizedBox(height: 16.0),
                const Text('Bericht'),
                TextFormField(
                  controller: _messageController,
                  onChanged: (value) => setState(() {
                    _messageController.text = value;
                  }),
                  // ignore: prefer-extracting-callbacks
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Voer een bericht in';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  // ignore: prefer-extracting-callbacks
                  onPressed: () {
                    final currentState = _formKey.currentState;
                    if (currentState != null && currentState.validate()) {
                      _sendForm().ignore();
                    }
                  },
                  child: const Text('Wijzig Vaarverbod'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
