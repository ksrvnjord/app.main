import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/almanak_user_profile_view.dart';

class AlmanakProfilePage extends ConsumerWidget {
  const AlmanakProfilePage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Almanakprofiel"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: AlmanakUserProfileView(identifier: userId),
    );
  }
}
