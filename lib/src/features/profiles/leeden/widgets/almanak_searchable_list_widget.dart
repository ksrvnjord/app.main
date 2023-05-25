import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/leeden/widgets/almanak_scrolling_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakSearchableListWidget extends StatefulWidget {
  final GraphQLClient client;
  const AlmanakSearchableListWidget({Key? key, required this.client})
      : super(key: key);

  @override
  createState() => _AlmanakSearchableListWidgetState();
}

class _AlmanakSearchableListWidgetState
    extends State<AlmanakSearchableListWidget> {
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const double searchBarPadding = 8;

    return <Widget>[
      TextFormField(
        controller: _search,
        decoration: const InputDecoration(
          labelText: 'Zoeken',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        textCapitalization: TextCapitalization.none,
        obscureText: false,
        autocorrect: false,
        enableSuggestions: false,
      ).padding(all: searchBarPadding),
      AnimatedBuilder(
        animation: _search,
        builder: (_, __) => AlmanakScrollingWidget(
          client: widget.client,
          search: _search.text,
        ).expanded(),
      ),
    ].toColumn();
  }
}
