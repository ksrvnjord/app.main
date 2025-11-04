import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/delete_form_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/edit_form_datetime_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_filler.dart';
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
    required this.isAdmin,
    required this.isInAdminPanel,
  });

  final String formId;
  final bool isAdmin;
  final bool isInAdminPanel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formVal =
        ref.watch(formProvider(FirestoreForm.firestoreConvert.doc(formId)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beheer Form'),
        actions: [
          DeleteFormButton(
            formId: formId,
          )
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
                      if (isAdmin &&
                          formData.openUntil.isAfter(
                              DateTime.now().subtract(const Duration(days: 7))))
                        EditFormDateTimeWidget(
                          docRef: formSnapshot.reference,
                          name: 'Open tot',
                          initialDate: formData.openUntil,
                        )
                      else
                        DataTextListTile(
                          name: 'Open tot',
                          value:
                              '${MaterialLocalizations.of(context).formatFullDate(formData.openUntil)} '
                              '${TimeOfDay.fromDateTime(formData.openUntil).format(context)}',
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
                      if (formData.isV2) ...[
                        for (final contentIndex
                            in formData.formContentObjectIds) ...[
                          formData.questionsMap.containsKey(contentIndex)
                              ? FormQuestion(
                                  formQuestion:
                                      formData.questionsMap[contentIndex]!,
                                  form: formData,
                                  docRef: formSnapshot.reference,
                                  userCanEditForm: false,
                                )
                              : FormFiller(
                                  filler: formData.fillers[contentIndex]!.value,
                                  formId: formSnapshot.id,
                                ),
                          const SizedBox(height: 32),
                        ]
                      ] else ...[
                        for (final question in formData.questions) ...[
                          FormQuestion(
                            formQuestion: question,
                            form: formData,
                            docRef: formSnapshot.reference,
                            userCanEditForm: false, // Use it here
                          ),
                          const SizedBox(height: 32),
                        ]
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
