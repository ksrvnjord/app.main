import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';

class ShowFormsResultsPage extends ConsumerWidget {
  const ShowFormsResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formsVal = ref.watch(allFormsOnCreationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bekijk Formresultaten'),
      ),
      body: formsVal.when(
        data: (forms) => ListView.builder(
          itemBuilder: (context, index) {
            final form = forms.docs[index];

            return ListTile(
              title: Text(form['formName']),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context
                  .goNamed('View Form', pathParameters: {'formId': form.id}),
            );
          },
          itemCount: forms.size,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
