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
  final _formKey = GlobalKey<FormState>();
  bool status = false;
  String message = "";

  @override
  void initState() {
    super.initState();
    status = widget.status;
    message = widget.message;
  }

  Future<void> _sendForm() async {
    final dio = ref.watch(dioProvider);
    try {
      // ignore: avoid-ignoring-return-values
      await dio.post(
        '/api/v2/vaarverbod/',
        data: {
          'status': status,
          'message': message,
        },
      );
      if (!context.mounted) return;
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
                  }),
                ),
                const SizedBox(height: 16.0),
                const Text('Bericht'),
                TextFormField(
                  initialValue: message,
                  onChanged: (value) => setState(() {
                    message = value;
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
                      _sendForm();
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
