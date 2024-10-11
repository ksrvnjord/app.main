// ignore_for_file: avoid-ignoring-return-values, no-magic-string

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/sensitive_data_bool_formfield.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/sensitive_data_subsection.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/sensitive_data_text_formfield.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

class SensitiveDataPage extends ConsumerStatefulWidget {
  const SensitiveDataPage({super.key});

  @override
  _SensitiveDataPageState createState() => _SensitiveDataPageState();
}

class _SensitiveDataPageState extends ConsumerState<SensitiveDataPage> {
  final _formKey = GlobalKey<FormState>();
  bool _buttonIsLoading = false;

  // Define controllers for each editable field.
  final _controllers = {
    'birthDate': TextEditingController(),
    'city': TextEditingController(),
    'dubbellid': TextEditingController(),
    'email': TextEditingController(),
    'houseNumber': TextEditingController(),
    'houseNumberAddition': TextEditingController(),
    'iban': TextEditingController(),
    'phonePrimary': TextEditingController(),
    'postalCode': TextEditingController(),
    'street': TextEditingController(),
    'studie': TextEditingController(),
  };

  final _dubbellidNotifier = ValueNotifier<bool>(false);
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  void _initializeControllersWithUserData(User user) {
    _controllers['city']!.text = user.address.city ?? '';
    _controllers['email']!.text = user.email;
    _controllers['houseNumber']!.text = user.address.houseNumber ?? '';
    _controllers['houseNumberAddition']!.text =
        user.address.houseNumberAddition ?? '';
    _controllers['iban']!.text = user.iban;
    _controllers['phonePrimary']!.text = user.contact.phonePrimary;
    _controllers['postalCode']!.text = user.address.postalCode ?? '';
    _controllers['street']!.text = user.address.street ?? '';
    _controllers['studie']!.text = user.info.studie ?? '';
    _dubbellidNotifier.value = user.info.dubbellid;
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
      'city': _controllers['city']?.text ?? '',
      'dubbellid': _dubbellidNotifier.value,
      'email': _controllers['email']?.text ?? '',
      'houseNumber': _controllers['houseNumber']?.text ?? '',
      'houseNumberAddition': _controllers['houseNumberAddition']?.text ?? '',
      'iban': _controllers['iban']?.text ?? '',
      'phonePrimary': _controllers['phonePrimary']?.text ?? '',
      'postalCode': _controllers['postalCode']?.text ?? '',
      'street': _controllers['street']?.text ?? '',
      'studie': _controllers['studie']?.text ?? '',
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
        const SnackBar(
          content: Text('Veranderingen opgeslagen!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Er is iets misgegaan. Probeer het later opnieuw.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose all controllers when the widget is disposed.
    _controllers.forEach((key, controller) => controller.dispose());
    _dubbellidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Persoonsgegevens aanpassen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: currentUser.when(
          // ignore: avoid-long-functions
          data: (user) {
            _initializeControllersWithUserData(user);

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SensitiveDataSubsection('Algemeen'),
                  SensitiveDataTextFormField(
                    title: 'Lidnummer',
                    isEditable: false,
                    initialValue: user.identifierString,
                  ),
                  SensitiveDataTextFormField(
                    title: 'Voornaam',
                    isEditable: false,
                    initialValue: user.firstName,
                  ),
                  SensitiveDataTextFormField(
                    title: 'Voorletters',
                    isEditable: false,
                    initialValue: user.initials,
                  ),
                  SensitiveDataTextFormField(
                    title: 'Tussenvoegsel',
                    isEditable: false,
                    initialValue: user.infix,
                  ),
                  SensitiveDataTextFormField(
                    title: 'Achternaam',
                    isEditable: false,
                    initialValue: user.lastName,
                    helperText:
                        'Mail naar ab-actis@njord.nl als je voornaam, voorletters, tussenvoegsel of achternaam verkeerd in het systeem staat.',
                  ),
                  SensitiveDataTextFormField(
                    title: 'E-mail',
                    isEditable: true,
                    controller: _controllers['email'],
                  ),
                  SensitiveDataTextFormField(
                    title: 'Telefoonnummer',
                    isEditable: true,
                    controller: _controllers['phonePrimary'],
                  ),
                  SensitiveDataTextFormField(
                    title: 'IBAN',
                    isEditable: true,
                    controller: _controllers['iban'],
                  ),
                  SensitiveDataTextFormField(
                    title: 'Geboortedatum',
                    isEditable: false,
                    initialValue: user.birthDate,
                    helperText:
                        "Mail naar abactis@njord.nl als je je geboortedatum wil aanpassen.",
                  ),
                  const Divider(),
                  const SensitiveDataSubsection('Adresgegevens'),
                  SensitiveDataTextFormField(
                    title: 'Straat',
                    isEditable: true,
                    controller: _controllers['street'],
                  ),
                  SensitiveDataTextFormField(
                    title: 'Huisnummer',
                    isEditable: true,
                    controller: _controllers['houseNumber'],
                  ),
                  SensitiveDataTextFormField(
                    title: 'Toevoeging',
                    isEditable: true,
                    controller: _controllers['houseNumberAddition'],
                  ),
                  SensitiveDataTextFormField(
                    title: 'Postcode',
                    isEditable: true,
                    controller: _controllers['postalCode'],
                  ),
                  SensitiveDataTextFormField(
                    title: 'Plaats',
                    isEditable: true,
                    controller: _controllers['city'],
                  ),
                  const Divider(),
                  const SensitiveDataSubsection('KNRB'),
                  SensitiveDataBoolFormfield(
                    title: 'Is ingeschreven bij KNRB',
                    initialValue: user.knrb?.knrb ?? false,
                    isEditable: false,
                  ),
                  SensitiveDataTextFormField(
                    title: 'KNRB nummer',
                    isEditable: false,
                    initialValue: user.knrb?.knrbId ?? '',
                  ),
                  SensitiveDataTextFormField(
                    title: 'Lid sinds',
                    isEditable: false,
                    initialValue: user.knrb?.startMembership?.toString() ?? '',
                  ),
                  const Divider(),
                  const SensitiveDataSubsection('Overig'),
                  SensitiveDataBoolFormfield(
                    title: 'Dubbellid',
                    valueNotifier: _dubbellidNotifier,
                    isEditable: true,
                  ),
                  SensitiveDataTextFormField(
                    title: 'Blikken',
                    isEditable: false,
                    initialValue: user.info.blikken.toString(),
                  ),
                  SensitiveDataTextFormField(
                    title: 'Taarten',
                    isEditable: false,
                    initialValue: user.info.taarten.toString(),
                  ),
                  SensitiveDataTextFormField(
                    title: 'Studie',
                    isEditable: true,
                    controller: _controllers['studie'],
                  ),
                  const Divider(),
                  ElevatedButton(
                    onPressed: () => _handleSubmitForm(user),
                    child: _buttonIsLoading
                        ? const CircularProgressIndicator.adaptive()
                        : const Text('Opslaan'),
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
