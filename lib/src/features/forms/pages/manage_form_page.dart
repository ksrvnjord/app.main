import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class ManageFormPage extends ConsumerWidget {
  const ManageFormPage({
    super.key,
    required this.formId,
    required this.isInAdminPanel,
  });

  final String formId;
  final bool isInAdminPanel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formVal =
        ref.watch(formProvider(FirestoreForm.firestoreConvert.doc(formId)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beheer Form'),
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
                            .doc('$firestoreFormCollectionName/$formId')
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
      body: formVal.when(
        data: (formSnapshot) {
          final formData = formSnapshot.data();

          final formatter = DateFormat('yyyy-MM-dd HH:mm');

          return formData == null
              ? const ErrorCardWidget(errorMessage: 'Formulier niet gevonden')
                  .center()
              : ListView(
                  padding: const EdgeInsets.only(bottom: 104),
                  children: [
                      DataTextListTile(
                          name: "Form naam", value: formData.title),
                      DataTextListTile(
                        name: 'Open tot',
                        value: formatter.format(formData.openUntil),
                      ),
                      DataTextListTile(
                        name: 'Beschrijving',
                        value: formData.description ?? 'N/A',
                      ),
                      DataTextListTile(
                        name: 'Formauteur id',
                        value: formData.authorId,
                      ),
                      DataTextListTile(
                        name: 'Aangemaakt door:',
                        value: formData.authorName,
                      ),
                      DataTextListTile(
                        name: 'Gecreëerd op:',
                        value: formatter.format(formData.createdTime),
                      ),
                      const Divider(),
                      const SizedBox(height: 32),
                      const Center(
                        child: Text(
                          'Vragen',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      for (final question in formData.questions) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: FormQuestion(
                            formQuestion: question,
                            form: formData,
                            docRef: formVal.value!.reference,
                            formIsOpen: false, // Use it here
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ]);
        },
        error: (error, stack) {
          return Center(
            child: ErrorTextWidget(errorMessage: error.toString()),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Bekijk (volledige ingevulde) reacties',
        heroTag: 'form_results',
        onPressed: () => context.pushNamed(
          isInAdminPanel ? 'Admin -> Form Results' : 'Forms -> Form Results',
          pathParameters: {
            'formId': formId,
          },
        ).ignore(),
        icon: const Icon(Icons.list),
        label: const Text('Bekijk (volledig ingevulde) reacties'),
      ),
    );
  }
}
