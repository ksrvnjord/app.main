import 'dart:async';

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
  Timer? _debounceTimer;
  String _searchText = '';
  String _debouncedSearchText = '';

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double searchBarPadding = 8;

    return <Widget>[
      TextFormField(
        controller: _search,
        onChanged: (value) {
          setState(() {
            _searchText = value;
          });

          _debounceTimer?.cancel();
          _debounceTimer = Timer(const Duration(milliseconds: 250), () {
            if (!mounted) {
              debugPrint
              return;
            }
            setState(() {
              _debouncedSearchText = value;
            });
          });
        },
        decoration: InputDecoration(
          labelText: 'Zoek Leeden op naam',
          labelStyle: Theme.of(context).textTheme.titleMedium,
          hintText: "James Cohen Stuart",
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          suffixIcon: _searchText.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _debounceTimer?.cancel();
                    _search.clear();
                    setState(() {
                      _searchText = '';
                      _debouncedSearchText = '';
                    });
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
        ),
        autocorrect: false,
        enableSuggestions: false,
      ).padding(all: searchBarPadding),
      AlmanakScrollingWidget(
        search: _debouncedSearchText,
        onTap: widget.onTap,
      ).expanded(),
    ].toColumn();
  }
}
