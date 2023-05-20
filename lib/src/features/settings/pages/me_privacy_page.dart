// ignore_for_file: prefer-single-widget-per-file
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/schema.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/settings/models/me.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:styled_widget/styled_widget.dart';

const double betweenFields = 20;
const double marginContainer = 5;
const double paddingBody = 15;

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
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
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
  bool saving = false;
  Color buttonColor = Colors.lightBlue;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      var keys = widget.user!.fullContact.public.toJson().keys.toSet();
      // User can't change visibility of these fields

      // ignore: avoid-ignoring-return-values
      keys.remove('first_name');
      // ignore: avoid-ignoring-return-values
      keys.remove('last_name');
      // ignore: avoid-ignoring-return-values
      keys.remove('__typename');

      final public = widget.user!.fullContact.public.toJson();

      for (String key in keys) {
        checkboxes[key] = !(public[key] == '');
      }

      listed = widget.user!.listed;
    }
  }

  void toggleCheckBoxes(String key, bool value) {
    setState(() {
      checkboxes[key] = value;
    });
  }

  void save(GraphQLClient client) async {
    setState(() {
      saving = true;
      buttonColor = Colors.blueGrey;
    });

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
      if (mounted) {
        setState(() {
          saving = false;
          buttonColor = Colors.blue;
        });
      }
    } catch (e) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Aanpassen mislukt, melding gemaakt.'),
        backgroundColor: Colors.red,
      ));
      if (mounted) {
        setState(() {
          saving = false;
          buttonColor = Colors.red;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = ref.watch(graphQLModelProvider).client;
    const double saveButtonPadding = 8;
    const double pagePadding = 8;
    const double buttonRounding = 16;

    return [
      [
        Switch(
          value: listed,
          onChanged: toggleCheckBox,
        ),
        const Text('Vindbaar in Almanak'),
      ].toRow(),
      const Divider(),
      ...(listed
          ? checkboxes.keys.map<Widget>(
              (key) {
                return [
                  Checkbox(
                    value: checkboxes[key],
                    onChanged: (value) => toggleCheckBoxes(key, value!),
                    checkColor: Colors.white,
                  ),
                  Text(key),
                ].toRow();
              },
            ).toList()
          : <Widget>[]),
      [
        ElevatedButton(
          onPressed: () => save(client),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRounding),
            ),
          ),
          child: saving
              ? const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(color: Colors.white),
                ).center().padding(all: saveButtonPadding)
              : const Text('Opslaan'),
        ).expanded(),
      ].toRow(),
    ].toColumn().padding(all: pagePadding);
  }

  void toggleCheckBox(bool? value) {
    setState(() {
      listed = value!;
    });
  }
}
