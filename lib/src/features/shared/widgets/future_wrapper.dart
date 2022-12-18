import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

/// A Flutter widget that wraps a `Future` object and displays different widgets
/// based on the state of the `Future`.
///
/// The `FutureWrapper` widget can display a loading widget while the `Future` is
/// still processing, a widget returned by the `success` function if the `Future`
/// completes successfully, and a fallback widget if the `Future` encounters an
/// error or has a connection state of none.
///
/// The `FutureWrapper` widget requires the following parameters to be passed in:
///
/// - `future`: The `Future` object to wrap.
/// - `success`: A function that takes in a value of type T and returns a widget
///   to display if the `Future` completes successfully.
/// - `loading`: The widget to display while the `Future` is loading (optional,
///   defaults to a `LoadingWidget`).
/// - `fallback`: The widget to display if the `Future` encounters an error or
///   has a connection state of none (optional, defaults to an `ErrorCardWidget`
///   with the error message 'Error').
class FutureWrapper<T> extends StatelessWidget {
  /// The Future object to wrap.
  final Future<T> future;

  /// The widget to display while the Future is loading.
  final Widget loading;

  /// A function that takes in a value of type T and returns a widget to display
  /// if the Future completes successfully.
  final Function(T) success;

  /// The widget to display if the Future encounters an error or has a connection
  /// state of none.
  final Widget fallback;

  const FutureWrapper({
    Key? key,
    required this.future,
    required this.success,
    this.loading = const LoadingWidget(),
    this.fallback = const ErrorCardWidget(
      errorMessage: 'Error',
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          return success(snapshot.data as T);
        } else if (snapshot.hasError) {
          return fallback;
        } else if (snapshot.connectionState == ConnectionState.none) {
          return fallback;
        }
        return loading;
      },
    );
  }
}
