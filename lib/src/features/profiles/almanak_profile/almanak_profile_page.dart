import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/widgets/almanak_user_profile_view.dart';

class AlmanakProfilePage extends ConsumerWidget {
  const AlmanakProfilePage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profiel"),
      ),
      body: AlmanakUserProfileView(identifier: userId),
    );
  }
}
