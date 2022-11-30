import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      <Widget>[const CircularProgressIndicator().padding(all: 10)].toRow()
    ].toColumn();
  }
}
