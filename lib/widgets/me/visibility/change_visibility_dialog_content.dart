import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/me/visibility/change_visibility_field.dart';
import 'package:ksrvnjord_main_app/widgets/me/visibility/remove_visibility_almanak.dart';
import 'package:ksrvnjord_main_app/queries/mutations/change_visibility.dart'
    as mutation;

class ChangeVisibilityDialogContent extends StatefulHookConsumerWidget {
  ChangeVisibilityDialogContent(
      this.listed, this.labels, this.initialSettings, this.changedSettings,
      {Key? key})
      : super(key: key);

  bool listed;
  List<Map<String, dynamic>> labels;
  Map<String, bool> initialSettings;
  Map<String, bool> changedSettings;

  @override
  _ChangeVisibilityDialogContentState createState() =>
      _ChangeVisibilityDialogContentState();
}

class _ChangeVisibilityDialogContentState
    extends ConsumerState<ChangeVisibilityDialogContent> {
  callBackField(String label, bool value) {
    widget.changedSettings[label] = !value;
  }

  callBackListed() {
    widget.listed = !widget.listed;
  }

  Future<QueryResult> _sendChangesToHeimdall(changes) async {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final MutationOptions options = MutationOptions(
        document: gql(mutation.changeVisibilityMutation), variables: changes);
    final QueryResult result = await client.mutate(options);
    return (result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
          '''Geef hier aan welke van je gegevens voor andere leden zichtbaar mogen zijn.'''),
      const SizedBox(
        height: 30,
      ),
      const Divider(
        color: Colors.black,
        thickness: 1,
      ),
      SizedBox(
          height: MediaQuery.of(context).size.height - 370,
          width: 300,
          child: ListView.separated(
              physics: const PageScrollPhysics(),
              padding: const EdgeInsets.all(0),
              itemCount: widget.labels.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
              itemBuilder: (BuildContext context, int index) {
                return (changeVisibilityField(
                    widget.labels[index],
                    widget.initialSettings[widget.labels[index]['backend']],
                    callBackField));
              })),
      const Divider(
        color: Colors.black,
        thickness: 1,
      ),
      const Spacer(),
      RemoveVisibilityAlmanak(widget.listed, callBackListed),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.red),
          child: const Text(
            'Teruggaan zonder opslaan',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
          ),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.green),
          child: const Text(
            'Wijzigingen opslaan',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
          ),
          onPressed: () {
            _sendChangesToHeimdall({'listed': widget.listed});
            Navigator.pop(context);
          },
        ),
      ]),
    ]);
  }
}
