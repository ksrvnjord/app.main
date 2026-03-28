// ignore_for_file: prefer-extracting-function-callbacks
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_session_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_content.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_definitive_submit_button.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_page_delete_button.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class FormPage extends ConsumerStatefulWidget {
  const FormPage({
    super.key,
    required this.formId,
    this.ignoreFilledInForm = false,
  });

  final String formId;
  final bool ignoreFilledInForm;

  @override
  ConsumerState<FormPage> createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(formSessionProvider(
      FormSessionParams(
        formId: widget.formId,
        ignoreFilledInForm: widget.ignoreFilledInForm,
      ),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulier'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: sessionAsync.when(
        data: (session) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _buildFormContent(session),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) => ErrorCardWidget(
          errorMessage: err.toString(),
        ),
      ),
    );
  }

  Widget _buildFormContent(FormSession session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormPageContent(
          formKey: _formKey,
          session: session,
        ),
        FormPageDefinitiveSubmitButton(
          formKey: _formKey,
          session: session,
        ),
        const SizedBox(height: 12),
        FormPageDeleteButton(
          session: session,
          formKey: _formKey,
        ),
      ],
    );
  }
}
