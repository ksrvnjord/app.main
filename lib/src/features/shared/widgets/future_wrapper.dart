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
  final T? initialData;

  const FutureWrapper({
    Key? key,
    required this.future,
    required this.success,
    this.loading = const LoadingWidget(),
    this.error = onEmpty,
    this.initialData,
  }) : super(key: key);

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
          return error(snapshot.error!);
        }

        return loading;
      },
      initialData: initialData,
    );
  }
}
