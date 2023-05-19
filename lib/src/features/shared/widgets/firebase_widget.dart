import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';

/// A widget that watches the current user from the database and only
/// renders [child] when the user is non-null (and thus logged in).
class FirebaseWidget extends ConsumerWidget {
  final Widget onAuthenticated;
  final Widget? onUnauthenticated;

  const FirebaseWidget({
    Key? key,
    required this.onAuthenticated,
    this.onUnauthenticated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseAuthUserProvider);

    return user == null
        ? onUnauthenticated == null
            ? const SizedBox.shrink()
            : onUnauthenticated!
        : onAuthenticated;
  }
}
