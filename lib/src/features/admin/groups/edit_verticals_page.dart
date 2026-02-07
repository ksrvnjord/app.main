import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditVerticals extends ConsumerWidget {
  const EditVerticals({
    super.key,
    required this.verticalName,
  });
  final String verticalName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(verticalName),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
