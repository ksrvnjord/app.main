import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';

Widget? onEmpty<T>(T arg) {
  return Text(arg.toString());
}

class FutureWrapper<T> extends StatelessWidget {
  final Future<T> future;
  final Widget? loading;
  final Widget? Function(Object? error)? error;
  final Widget? Function(dynamic data)? success;

  const FutureWrapper(
      {Key? key,
      required this.future,
      this.loading,
      this.error = onEmpty,
      this.success = onEmpty})
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
