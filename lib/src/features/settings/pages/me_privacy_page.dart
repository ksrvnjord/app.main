// ignore_for_file: prefer-single-widget-per-file
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/schema.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/form_section.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:styled_widget/styled_widget.dart';

class MePrivacyPage extends ConsumerWidget {
  const MePrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(graphQLModelProvider).client;
    final result = me(client);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Zichtbaarheid aanpassen'),
      ),
      body: FutureWrapper(
        future: result,
        success: (me) => MePrivacyWidget(me),
      ),
    );
  }
}

class MePrivacyWidget extends ConsumerStatefulWidget {
  const MePrivacyWidget(this.user, {Key? key}) : super(key: key);
  final Query$Me$me? user;

  @override
  createState() => _MePrivacyWidgetState();
}

class _MePrivacyWidgetState extends ConsumerState<MePrivacyWidget> {
  Map<String, bool> checkboxes = {};
  bool listed = false;
  Color buttonColor = Colors.lightBlue;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      final keys = widget.user?.fullContact.public.toJson().keys.toSet();
      if (keys != null) {
        // User can't change visibility of these fields.

        // ignore: avoid-ignoring-return-values
        keys.remove('first_name');
        // ignore: avoid-ignoring-return-values
        keys.remove('last_name');
        // ignore: avoid-ignoring-return-values
        keys.remove('__typename');

        final public = widget.user?.fullContact.public.toJson();

        for (String key in keys) {
          checkboxes[key] = !(public?[key] == '');
        }
      }

      listed = widget.user?.listed ?? false;
    }
  }

  void toggleCheckBoxes(String key, bool value) {
    setState(() {
      checkboxes[key] = value;
    });
  }

  void save(GraphQLClient client) async {
    final uid = ref.watch(currentFirestoreUserProvider)?.identifier;
    ref.invalidate(heimdallUserByLidnummerProvider(
      uid ?? "",
    )); // Invalidate the cache for the user profile, so the user sees the changes immediately.

    try {
      // ignore: avoid-ignoring-return-values
      await updatePublicContact(
        client,
        listed,
        Input$IBooleanContact.fromJson(checkboxes),
      );
      // ignore: avoid-ignoring-return-values, use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Vindbaarheid aangepast'),
      ));
    } catch (e) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Er is iets misgegaan bij het aanpassen van je vindbaarheid'),
        backgroundColor: Colors.red,
      ));
    }
    GetIt.I<CurrentUser>().fillContact(client);
  }

  @override
  Widget build(BuildContext context) {
    final client = ref.watch(graphQLModelProvider).client;
    const double pagePadding = 8;

    const Map<String, String> checkboxReadableMap = {
      "email": "Email",
      "street": "Straatnaam",
      "housenumber": "Huisnummer",
      "housenumber_addition": "Toevoeging",
      "city": "Woonplaats",
      "zipcode": "Postcode",
      "phone_primary": "Telefoonnummer",
    };

    return [
      [
        Switch(
          value: listed,
          onChanged: toggleCheckBox,
        ),
        const Text('Zichtbaar in de almanak'),
      ].toRow(),
      const Divider(),
      if (listed)
        FormSection(title: "Zichtbaarheid per veld", children: [
          ...(checkboxes.keys.map<Widget>(
            (key) {
              return [
                Checkbox(
                  value: checkboxes[key],
                  onChanged: (value) => toggleCheckBoxes(key, value ?? false),
                  checkColor: Colors.white,
                ),
                Text(checkboxReadableMap[key] ?? key),
              ].toRow();
            },
          ).toList()),
        ]),
      [
        ElevatedButton(
          onPressed: () => save(client),
          child: const Text('Opslaan'),
        ).expanded(),
      ].toRow(),
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(all: pagePadding);
  }

  void toggleCheckBox(bool value) {
    setState(() {
      listed = value;
    });
  }
}
