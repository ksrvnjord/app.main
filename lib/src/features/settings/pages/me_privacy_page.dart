import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/schema.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/settings/models/me.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

const double betweenFields = 20;
const double marginContainer = 5;
const double paddingBody = 15;

class MePrivacyPage extends StatelessWidget {
  const MePrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;
    final result = me(client);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zichtbaarheid aanpassen'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: true,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: FutureWrapper(
        future: result,
        success: (me) {
          return MePrivacyWidget(me);
        },
      ),
    );
  }
}

class MePrivacyWidget extends StatefulWidget {
  const MePrivacyWidget(this.user, {Key? key}) : super(key: key);
  final Query$Me$me? user;

  @override
  createState() => _MePrivacyWidgetState();
}

class _MePrivacyWidgetState extends State<MePrivacyWidget> {
  Map<String, bool> checkboxes = {};
  bool listed = false;
  bool saving = false;
  Color buttonColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      var keys = widget.user!.fullContact.public.toJson().keys.toSet();
      // User can't change visibility of these fields
      keys.remove('first_name');
      keys.remove('last_name');
      keys.remove('__typename');

      final public = widget.user!.fullContact.public.toJson();

      for (String key in keys) {
        checkboxes[key] = !(public[key] == '');
      }

      listed = widget.user!.listed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;
    const double saveButtonPadding = 8;
    const double pagePadding = 8;

    return [
      [
        Switch(
          value: listed,
          onChanged: (bool? value) {
            setState(() {
              listed = value!;
            });
          },
        ),
        const Text('Vindbaar in Almanak'),
      ].toRow(),
      const Divider(),
      ...(listed
          ? checkboxes.keys.map<Widget>(
              (key) {
                return [
                  Checkbox(
                    checkColor: Colors.white,
                    value: checkboxes[key],
                    onChanged: (bool? value) {
                      setState(() {
                        checkboxes[key] = value!;
                      });
                    },
                  ),
                  Text(key),
                ].toRow();
              },
            ).toList()
          : <Widget>[]),
      [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
          onPressed: () {
            setState(() {
              saving = true;
              buttonColor = Colors.blueGrey;
            });

            updatePublicContact(
              client,
              listed,
              Input$IBooleanContact.fromJson(checkboxes),
            ).then((data) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Vindbaarheid aangepast'),
              ));
              setState(() {
                saving = false;
                buttonColor = Colors.blue;
              });
            }).onError((error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Aanpassen mislukt, melding gemaakt.'),
              ));
              setState(() {
                saving = false;
                buttonColor = Colors.red;
              });
            });
          },
          child: saving
              ? const SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(color: Colors.white),
                ).center().padding(all: saveButtonPadding)
              : const Text('Opslaan'),
        ).expanded(),
      ].toRow(),
    ].toColumn().padding(all: pagePadding);
  }
}
