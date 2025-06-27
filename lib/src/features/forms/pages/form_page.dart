// ignore_for_file: prefer-extracting-function-callbacks
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_content.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_delete_button.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/routing_constants.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:share_plus/share_plus.dart';

class FormPage extends ConsumerStatefulWidget {
  // Constructor which takes a String formId.
  const FormPage({super.key, required this.formId});

  final String formId;

  @override
  createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  // Constructor which takes a String formId.

  final _formKey = GlobalKey<FormState>();

  /// This method is used to unfocus the current form field when the user taps outside of it.
  /// This is useful in cases where the keyboard should be dismissed.
  void _handleTapOutsidePrimaryFocus() {
    final focus = FocusManager.instance.primaryFocus;
    // Guard clause: if there's no focus or it doesn't have primary focus, return early.
    if (focus == null || !focus.hasPrimaryFocus) {
      return;
    }
    // Unfocus the current form field.
    focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final doc = FirestoreForm.firestoreConvert.doc(widget.formId);

    final formVal = ref.watch(formProvider(doc));

    return GestureDetector(
      onTap: _handleTapOutsidePrimaryFocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Form'),
          actions: [
            IconButton(
              onPressed: () {
                const snackbar = SnackBar(
                  content: Text(
                    'Er is iets misgegaan bij het delen van de form',
                  ),
                );
                final routeInformation =
                    GoRouter.of(context).routeInformationProvider.value;

                final state = routeInformation.state as Map<Object?, Object?>?;
                if (state == null) {
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  return;
                }
                final currentPath = state['location'] as String;

                const prefixPath = RoutingConstants.appBaseUrl;
                final url = "$prefixPath$currentPath";
                Share.share(url).ignore();
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: ListView(
          padding:
              const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 64),
          children: [
            formVal.when(
              data: (formDoc) {
                if (!formDoc.exists) {
                  return const ErrorCardWidget(
                    errorMessage: 'Deze form bestaat niet (meer)',
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FormPageContent(formKey: _formKey, formDoc: formDoc),
                    FormPageDeleteButton(
                      doc: doc,
                      formId: widget.formId,
                      formKey: _formKey,
                    ),
                  ],
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              error: (err, stack) => ErrorCardWidget(
                errorMessage: 'Fout bij het laden van het formulier',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
