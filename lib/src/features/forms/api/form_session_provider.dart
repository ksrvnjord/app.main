import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';

/// Provider family for FormSession
final formSessionProvider = StateNotifierProvider.family<FormSessionNotifier,
    AsyncValue<FormSession>, FormSessionParams>(
  (ref, params) => FormSessionNotifier(ref, params),
);

/// Parameters for the provider family
class FormSessionParams {
  const FormSessionParams({
    required this.formId,
    this.ignoreFilledInForm = false,
  });

  final String formId;
  final bool ignoreFilledInForm;

  // Important for provider caching — equality must be consistent
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormSessionParams &&
          other.formId == formId &&
          other.ignoreFilledInForm == ignoreFilledInForm;

  @override
  int get hashCode => Object.hash(formId, ignoreFilledInForm);
}

/// StateNotifier that loads a FormSession once
class FormSessionNotifier extends StateNotifier<AsyncValue<FormSession>> {
  FormSessionNotifier(this.ref, this.params)
      : super(const AsyncValue.loading()) {
    _init();
  }

  final Ref ref;
  final FormSessionParams params;

  Future<void> _init() async {
    try {
      final doc = await ref.read(
          formProvider(FirestoreForm.firestoreConvert.doc(params.formId))
              .future);

      if (!doc.exists) {
        throw Exception('Form does not exist');
      }

      final session = await createSession(
        formDoc: doc,
        ignoreFilledInForm: params.ignoreFilledInForm,
        ref: ref,
      );

      state = AsyncValue.data(session);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
