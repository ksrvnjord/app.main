import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/all_form_answers_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/download_csv_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/show_form_results_info_box.dart';

class ShowFormResultsPage extends ConsumerWidget {
  final String formId;

  const ShowFormResultsPage({Key? key, required this.formId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider(formId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bekijk Formresultaten'),
      ),
      body: form.when(
        data: (documentSnapshot) {
          final FirestoreForm? formData = documentSnapshot.data();
          if (documentSnapshot.data() == null) {
            return const Center(child: Text('No data available'));
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              const Divider(),
              ShowFormResultsInfoBox(
                field: 'Form naam',
                value: formData?.formName ?? 'N/A',
              ),
              ShowFormResultsInfoBox(
                field: 'Formauteur',
                value: formData?.authorId ?? 'N/A',
              ),
              ShowFormResultsInfoBox(
                field: 'Beschrijving',
                value: formData?.description ?? 'N/A',
              ),
              ShowFormResultsInfoBox(
                field: 'Open tot',
                value: formData?.openUntil.toString() ?? 'N/A',
              ),
              ShowFormResultsInfoBox(
                field: 'Gecreerd op',
                value: formData?.createdTime.toString() ?? 'N/A',
              ),
              Consumer(builder: (context, ref, _) {
                final answerVal = ref.watch(
                  allFormAnswersProvider(formId),
                );

                return answerVal.when(
                  data: (snapshot) {
                    return ElevatedButton.icon(
                      onPressed: () => ref.read(downloadCsvProvider(
                        DownloadCsvParams(
                          formName: formData?.formName ?? '',
                          snapshot: snapshot,
                        ),
                      )),
                      icon: const Icon(Icons.download),
                      label: const Text('Download Resultaten als CSV'),
                    );
                  },
                  loading: () {
                    return const CircularProgressIndicator();
                  },
                  error: (error, stackTrace) {
                    return Text('Error: $error');
                  },
                );
              }),
            ],
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stack) {
          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}
