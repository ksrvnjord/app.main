import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginDoneWidget extends ConsumerWidget {
  const LoginDoneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: avoid-ignoring-return-values
    ref.watch(
      currentFirebaseUserProvider,
    ); // Get currentUser details from firebase.
    // ignore: avoid-non-ascii-symbols
    const String swanEmoji = "\uD83E\uDDA2";

    const double textPadding = 16;
    const double columnPadding = 16;
    const double cardElevation = 8;
    const double cardOuterPadding = 16;

    return <Widget>[
      <Widget>[const Text(swanEmoji, style: TextStyle(fontSize: 40))]
          .toRow(mainAxisAlignment: MainAxisAlignment.center),
      const Text('Je bent ingelogd.').padding(top: textPadding),
      <Widget>[
        ElevatedButton(
          onPressed: () => Routemaster.of(context).push('/'),
          child: const Text('Doorgaan'),
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
    ]
        .toColumn(mainAxisSize: MainAxisSize.min)
        .padding(all: columnPadding)
        .card(
          elevation: cardElevation,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        )
        .padding(all: cardOuterPadding)
        .alignment(Alignment.center);
  }
}
