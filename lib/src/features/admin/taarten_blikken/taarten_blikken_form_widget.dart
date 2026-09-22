import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaartenBlikkenFormWidget extends StatefulWidget {
  const TaartenBlikkenFormWidget({super.key});

  @override
  State<TaartenBlikkenFormWidget> createState() =>
      _TaartenBlikkenFormWidgetState();
}

class _TaartenBlikkenFormWidgetState extends State<TaartenBlikkenFormWidget> {
  static const String _documentPath = 'wins/wincounter';

  final _formKey = GlobalKey<FormState>();
  final _blikkenController = TextEditingController();
  final _taartenController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _blikkenController.dispose();
    _taartenController.dispose();
    super.dispose();
  }

  int _readCount(Map<String, dynamic>? data, String fieldName) {
    final value = data?[fieldName];
    if (value is num) {
      return value.toInt();
    }

    return 0;
  }

  void _initializeControllers(Map<String, dynamic>? data) {
    if (_initialized) {
      return;
    }

    _blikkenController.text = _readCount(data, 'blikken').toString();
    _taartenController.text = _readCount(data, 'taarten').toString();
    _initialized = true;
  }

  Future<void> _saveCounters() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final blikkenCount = int.parse(_blikkenController.text.trim());
    final taartenCount = int.parse(_taartenController.text.trim());

    try {
      await FirebaseFirestore.instance.doc(_documentPath).set(
        {
          'blikken': blikkenCount,
          'taarten': taartenCount,
        },
        SetOptions(merge: true),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('De taarten- en blikkenteller is gewijzigd.'),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      debugPrint('Error saving counters: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Er is een fout opgetreden bij het wijzigen van de tellers.',
          ),
        ),
      );
    }
  }

  String? _validateCount(String? value) {
    if (int.tryParse((value ?? '').trim()) == null) {
      return 'Voer een geldig getal in';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.doc(_documentPath).snapshots(),
      builder: (context, snapshot) {
        _initializeControllers(snapshot.data?.data());

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pas hier de blikken- en taartentellers aan die op het prikboard worden getoond.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _blikkenController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Blikkenteller',
                          prefixIcon: Icon(Icons.military_tech),
                        ),
                        validator: _validateCount,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _taartenController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Taartenteller',
                          prefixIcon: Icon(Icons.cake),
                        ),
                        validator: _validateCount,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _saveCounters,
                        child: const Text('Wijzig tellers'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
