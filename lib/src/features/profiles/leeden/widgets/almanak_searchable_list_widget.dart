import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/leeden/widgets/almanak_scrolling_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakSearchableListWidget extends StatefulWidget {
  const AlmanakSearchableListWidget({super.key, required this.onTap});

  final void Function(int userId)? onTap;

  @override
  createState() => _AlmanakSearchableListWidgetState();
}

class _AlmanakSearchableListWidgetState
    extends State<AlmanakSearchableListWidget> {
  final _search = TextEditingController();
  final ValueNotifier<String> _searchText = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _search.addListener(() {
      _searchText.value = _search.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double searchBarPadding = 8;

    return <Widget>[
      ValueListenableBuilder<String>(
        valueListenable: _searchText,
        builder: (context, value, child) {
          return TextFormField(
            controller: _search,
            decoration: InputDecoration(
              labelText: 'Zoek Leeden op naam',
              labelStyle: Theme.of(context).textTheme.titleMedium,
              hintText: "James Cohen Stuart",
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              suffixIcon: value.isNotEmpty
                  ? IconButton(
                      onPressed: _search.clear,
                      icon: Icon(Icons.clear),
                    )
                  : null,
            ),
            autocorrect: false,
            enableSuggestions: false,
          ).padding(all: searchBarPadding);
        },
      ),
      AnimatedBuilder(
        animation: _search,
        builder: (_, __) => AlmanakScrollingWidget(
          search: _search.text,
          onTap: widget.onTap,
        ).expanded(),
      ),
    ].toColumn();
  }
}
