import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';

/// A widget that watches the current user from the database and only
/// renders [child] when the user is non-null (and thus logged in).
class FirebaseWidget extends ConsumerWidget {
  final Widget child;

  const FirebaseWidget(this.child, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentFirebaseUserProvider);

    return user == null ? const SizedBox.shrink() : child;
  }
}
