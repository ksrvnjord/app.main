import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

Widget onEmpty<T>(T arg) {
  return Text(arg.toString());
}

class FutureWrapper<T> extends StatelessWidget {
  final Future<T> future;
  final Widget loading;
  final Widget Function(Object? error) error;
  final Widget Function(T? data) success;

  const FutureWrapper(
      {Key? key,
      required this.future,
      required this.success,
      this.loading = const LoadingWidget(),
      this.error = onEmpty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading;
        } else if (snapshot.connectionState == ConnectionState.none) {
          return error(snapshot.data);
        }

        if (snapshot.hasError) {
          return error(snapshot.data);
        }

        return success(snapshot.data);
      },
    );
  }
}
