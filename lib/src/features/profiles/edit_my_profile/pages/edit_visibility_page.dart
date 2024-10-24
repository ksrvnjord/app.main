// ignore_for_file: avoid-ignoring-return-values

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/sensitive_data_bool_formfield.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

class EditVisibilityPage extends ConsumerStatefulWidget {
  const EditVisibilityPage({super.key});

  @override
  createState() => _EditVisibilityPageState();
}

class _EditVisibilityPageState extends ConsumerState<EditVisibilityPage> {
  final _notifiers = {
    'address': ValueNotifier<bool>(false),
    'email': ValueNotifier<bool>(false),
    'phoneNumber': ValueNotifier<bool>(false),
  };

  final _formKey = GlobalKey<FormState>();
  bool _buttonIsLoading = false;

  void _initializeNotifiersWithData(User user) {
    _notifiers['email']!.value = user.contact.emailVisible;
    _notifiers['phoneNumber']!.value = user.contact.phoneVisible;
    _notifiers['address']!.value = user.address.visible ?? false;
  }

  void _handleSubmitForm(User user) async {
    // ignore: avoid-non-null-assertion
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _buttonIsLoading = true;
    });

    // Collect all form data.
    final formData = {
      'addressVisible': _notifiers['address']!.value,
      'emailVisible': _notifiers['email']!.value,
      'phoneVisible': _notifiers['phoneNumber']!.value,
    };

    // Update the user with the new data.
    user.django.updateWithPartialData(formData);

    // Update the user in the database.
    final success = await DjangoUser.updateByIdentifier(ref, user.django);

    // ignore: use-setstate-synchronously
    setState(() {
      _buttonIsLoading = false;
    });

    if (success) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veranderingen opgeslagen!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Er is iets misgegaan. Probeer het later opnieuw.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _notifiers.forEach((key, notifier) => notifier.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Zichtbaarheid Almanak Aanpassen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: currentUser.when(
          data: (user) {
            _initializeNotifiersWithData(user);

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  SensitiveDataBoolFormfield(
                    title: 'Email zichtbaar in almanak',
                    valueNotifier: _notifiers['email']!,
                    isEditable: true,
                  ),
                  SensitiveDataBoolFormfield(
                    title: 'Telefoonnummer zichtbaar in almanak',
                    valueNotifier: _notifiers['phoneNumber']!,
                    isEditable: true,
                  ),
                  SensitiveDataBoolFormfield(
                    title: 'Adresgegevens zichtbaar in almanak',
                    valueNotifier: _notifiers['address']!,
                    isEditable: true,
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => _handleSubmitForm(user),
                      child: _buttonIsLoading
                          ? const CircularProgressIndicator.adaptive()
                          : const Text('Opslaan'),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (e, s) {
            // ignore: avoid-async-call-in-sync-function
            FirebaseCrashlytics.instance.recordError(e, s);

            return const SizedBox.shrink();
          },
          loading: () => const LoadingWidget(),
        ),
      ),
    );
  }
}
