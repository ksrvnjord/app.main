import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

Widget? onEmpty<T>(T arg) {
  return Text(arg.toString());
}

class FutureWrapper<T> extends StatelessWidget {
  final Future<T> future;
  final Widget? loading;
  final Widget? Function(Object? error)? error;
  final Widget? Function(T? data)? success;

  const FutureWrapper(
      {Key? key,
      required this.future,
      required this.success,
      this.loading,
      this.error = onEmpty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          return success != null
              ? success!(snapshot.data) ?? Container()
              : Container();
        }

        if (snapshot.hasError) {
          return error != null
              ? error!(snapshot.data) ?? Container()
              : Container();
        }

        return loading ?? const LoadingWidget();
      },
    );
  }
}
