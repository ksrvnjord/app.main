import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

// No other idea than to use this function
// ignore: avoid-returning-widgets
Widget onEmpty<T>(T arg) {
  return Text(arg.toString());
}

class FutureWrapper<T> extends StatelessWidget {
  final Future<T> future;
  final Widget loading;
  final Widget Function(Object error) error;
  final Widget Function(T data) success;
  final Widget Function() onNoData;
  final T? initialData;

  const FutureWrapper({
    Key? key,
    required this.future,
    required this.success,
    this.loading = const LoadingWidget(),
    this.error = onEmpty,
    this.onNoData = empty,
    this.initialData,
  }) : super(key: key);

  static Widget empty() => const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          // data can't be null, but the type system doesn't know that
          // ignore: null_check_on_nullable_type_parameter
          return success(snapshot.data!);
        } else if (snapshot.hasError) {
          log(snapshot.error.toString()); // show error in console aswell

          return error(snapshot.error!);
        } else if (snapshot.data == null &&
            snapshot.connectionState == ConnectionState.done) {
          return onNoData();
        }

        return loading;
      },
      initialData: initialData,
    );
  }
}
