import 'dart:convert';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';

class FutureWrapper<T> extends StatelessWidget {
  final Future<T> future;
  final Widget? loading;
  final Widget Function(Object? error)? error;
  final Widget Function(T? data)? success;

  const FutureWrapper(
      {Key? key, required this.future, this.loading, this.error, this.success})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          if (success != null) {
            return success!(snapshot.data);
          }
          return Text(jsonEncode(snapshot.data));
        }

        if (snapshot.hasError) {
          if (error != null) {
            return error!(snapshot.error);
          }
          return Text(jsonEncode(snapshot.error));
        }

        if (loading != null) {
          return loading!;
        }

        return const CircularProgressIndicator().padding(all: 10);
      },
    );
  }
}
