import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';

/// A widget that watches the current user from the database and only
/// renders [child] when the user is non-null (and thus logged in).
class FirebaseWidget extends ConsumerWidget {
  const FirebaseWidget({
    super.key,
    required this.onAuthenticated,
    this.onUnauthenticated,
  });

  final Widget onAuthenticated;
  final Widget? onUnauthenticated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseAuthUserProvider).value;

    return user == null
        ? onUnauthenticated == null
            ? const SizedBox.shrink()
            : onUnauthenticated as Widget
        : onAuthenticated;
  }
}
