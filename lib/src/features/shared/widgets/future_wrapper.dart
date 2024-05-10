import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

// No other idea than to use this function.
// ignore: prefer-static-class, avoid-returning-widgets
Widget onEmpty<T>(T arg) {
  return Text(arg.toString());
}

@immutable
class FutureWrapper<T> extends StatelessWidget {
  static Widget empty() => const SizedBox.shrink();
  final Future<T> future;
  final Widget loading;
  final Widget Function(Object error) error;
  final Widget Function(T data) success;
  final Widget Function() onNoData;
  final T? initialData;

  const FutureWrapper({
    super.key,
    required this.future,
    required this.success,
    this.loading = const LoadingWidget(),
    this.error = onEmpty,
    this.onNoData = empty,
    this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      initialData: initialData,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          return success(snapshot.data as T);
        } else if (snapshot.hasError) {
          log(snapshot.error.toString());

          // ignore: avoid-non-null-assertion
          return error(snapshot.error!);
        } else if (snapshot.data == null &&
            snapshot.connectionState == ConnectionState.done) {
          return onNoData();
        }

        return loading;
      },
    );
  }
}
