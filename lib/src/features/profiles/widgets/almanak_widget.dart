import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_scrolling_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakWidget extends StatefulWidget {
  final GraphQLClient client;
  const AlmanakWidget({Key? key, required this.client}) : super(key: key);

  @override
  createState() => _AlmanakWidgetState();
}

class _AlmanakWidgetState extends State<AlmanakWidget> {
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const double searchBarPadding = 8;

    return <Widget>[
      TextFormField(
        controller: _search,
        obscureText: false,
        autocorrect: false,
        enableSuggestions: false,
        textCapitalization: TextCapitalization.none,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          labelText: 'Zoeken',
        ),
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
