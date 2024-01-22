import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/all_form_answers_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/download_csv_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/show_form_results_info_box.dart';
import 'package:styled_widget/styled_widget.dart';

class ShowFormResultsPage extends ConsumerWidget {
  const ShowFormResultsPage({Key? key, required this.formId}) : super(key: key);

  final String formId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider(formsCollection.doc(formId)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bekijk Formresultaten'),
        actions: [
          IconButton(
            // ignore: prefer-extracting-callbacks
            onPressed: () {
              // ignore: avoid-ignoring-return-values, avoid-async-call-in-sync-function
              showDialog(
                context: context,
                builder: (innerContext) => AlertDialog(
                  title: const Text('Verwijderen'),
                  content: const Text(
                    'Weet je zeker dat je deze form wilt verwijderen?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(innerContext).pop(),
                      child: const Text('Annuleren'),
                    ),
                    TextButton(
                      // ignore: prefer-extracting-callbacks, avoid-passing-async-when-sync-expected
                      onPressed: () async {
                        if (innerContext.mounted) {
                          Navigator.of(innerContext).pop();
                          if (context.mounted) context.pop();
                        }
                        final formPath = FirebaseFirestore.instance
                            .doc('forms/$formId')
                            .path;

                        // ignore: avoid-ignoring-return-values
                        await FormRepository.deleteForm(formPath);
                      },
                      child: const Text('Verwijderen').textColor(Colors.red),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: form.when(
        // ignore: avoid-long-functions
        data: (documentSnapshot) {
          final formData = documentSnapshot.data();

          return formData == null
              ? const Center(child: Text('No data available'))
              : Column(
                  children: [
                    const SizedBox(height: 16),
                    const Divider(),
                    ShowFormResultsInfoBox(
                      field: 'Form naam',
                      value: formData.formName,
                    ),
                    ShowFormResultsInfoBox(
                      field: 'Formauteur',
                      value: formData.authorId,
                    ),
                    ShowFormResultsInfoBox(
                      field: 'Beschrijving',
                      value: formData.description ?? 'N/A',
                    ),
                    ShowFormResultsInfoBox(
                      field: 'Open tot',
                      value: formData.openUntil.toString(),
                    ),
                    ShowFormResultsInfoBox(
                      field: 'Gecreerd op',
                      value: formData.createdTime.toString(),
                    ),
                    ref.watch(allFormAnswersProvider(formId)).when(
                      data: (snapshot) {
                        return ElevatedButton.icon(
                          onPressed: () => ref.read(downloadCsvProvider(
                            DownloadCsvParams(
                              formName: formData.formName,
                              formQuestions: formData.questions
                                  .map((e) => e.label)
                                  .toList(),
                              snapshot: snapshot,
                            ),
                          )),
                          icon: const Icon(Icons.download),
                          label: const Text('Download Resultaten als CSV'),
                        );
                      },
                      error: (error, stackTrace) {
                        return Text('Error: $error');
                      },
                      loading: () {
                        return const CircularProgressIndicator.adaptive();
                      },
                    ),
                  ],
                );
        },
        error: (error, stack) {
          return Center(child: Text('Error: $error'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }
}
