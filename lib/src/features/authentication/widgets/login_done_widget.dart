import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/init_messaging_info.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/request_messaging_permission.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/save_messaging_token.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginDoneWidget extends ConsumerWidget {
  const LoginDoneWidget({Key? key}) : super(key: key);

  void onStartup(WidgetRef ref) {
    // ignore: avoid-ignoring-return-values
    ref.read(graphQLModelProvider);

    final user = ref.read(
      currentFirestoreUserProvider,
    ); // Get currentUser details from firebase.

    // ignore: avoid-ignoring-return-values

    if (!kIsWeb && user != null) {
      // Web does not support messaging, also user should be logged in to Firebase for it to work.
      requestMessagingPermission(); // TODO: Only prompt if the user is able to give permission, ie. not when user already gave permissies or denied them.
      saveMessagingToken(); // TODO: Retry on no internet connection.
      initMessagingInfo();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    onStartup(ref);

    // ignore: avoid-non-ascii-symbols
    const String swanEmoji = "\uD83E\uDDA2";

    const double textPadding = 16;
    const double columnPadding = 16;
    const double cardOuterPadding = 16;

    return <Widget>[
      <Widget>[const Text(swanEmoji, style: TextStyle(fontSize: 40))]
          .toRow(mainAxisAlignment: MainAxisAlignment.center),
      const Text('Je bent ingelogd.').padding(top: textPadding),
      <Widget>[
        ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('Doorgaan'),
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
    ]
        .toColumn(mainAxisSize: MainAxisSize.min)
        .padding(all: columnPadding)
        .card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        )
        .padding(all: cardOuterPadding)
        .alignment(Alignment.center);
  }
}
