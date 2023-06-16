import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/more_link_tile.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/more_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';
import 'package:styled_widget/styled_widget.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(firebaseAuthUserProvider);

    final Map<String, String> optionRouteMap = {
      "Bekijk de agenda": "events",
      "Contacteer het bestuur / commissies": "contact",
      "Lees het beleid van het bestuur": "beleid",
      if (currentUser != null) 'Bekijk de fotogalerij': 'gallery',
      if (currentUser != null) 'Documenten': 'documents',
    };

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meer'),
      ),
      body: ListView(
        children: [
          ...optionRouteMap.entries.map(
            // Make a list of options to display and navigate to.
            // Each option is a tile with a divider below it.
            (entry) => [
              MoreListTile(
                label: entry.key,
                routePath: entry.value,
              ),
              const Divider(
                height: 0,
                thickness: 0.5,
              ),
            ].toColumn(),
          ),
          ListTile(
            title: Text(
              "Geef feedback over de app",
              style: textTheme.titleMedium,
            ),
            trailing: const Icon(
              Icons.feedback_outlined,
            ),
            onTap: () => BetterFeedback.of(context).showAndUploadToSentry(
              name: GetIt.I<CurrentUser>()
                      .user
                      ?.username ?? // CurrentUser might not be filled yet.
                  FirebaseAuth.instance.currentUser?.uid ??
                  "Anoniem",
            ),
          ),
          const Divider(
            height: 0,
            thickness: 0.5,
          ),
          const MoreLinkTile(
            label: "Ga naar de webshop",
            url: "https://k-s-r-v-njord.myshopify.com/",
          ),
          const Divider(
            height: 0,
            thickness: 0.5,
          ),
          const MoreLinkTile(
            label: 'Declareer kosten aan de Quaestor',
            url:
                'https://docs.google.com/forms/d/e/1FAIpQLSe75Utou3_t_Ja7Dmmjhasz2eVc5Ii3SkAOtKqnlwPACaBn4g/viewform',
          ),
          const Divider(
            height: 0,
            thickness: 0.5,
          ),
          const MoreLinkTile(
            label: 'Handige linkjes - Linktree',
            url: 'https://linktr.ee/ksrvnjord_intern',
          ),
          const Divider(
            height: 0,
            thickness: 0.5,
          ),
          ListTile(
            title: Text(
              'Uitloggen',
              style: textTheme.titleMedium,
            ).textColor(Colors.red),
            trailing: const Icon(Icons.logout, color: Colors.red),
            visualDensity: VisualDensity.standard,
            onTap: () => ref.read(authModelProvider).logout(),
          ),
        ],
      ),
    );
  }
}
