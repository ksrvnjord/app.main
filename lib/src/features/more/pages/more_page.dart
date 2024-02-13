import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/lustrum_background_widget.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/more_link_tile.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/more_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';
import 'package:styled_widget/styled_widget.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuthUser = ref.watch(firebaseAuthUserProvider).value;
    final currentUserVal = ref.watch(currentUserProvider);
    const pageOffset = 0.0;

    final optionRouteMap = {
      "Over deze App": "About this app",
      // ignore: map-keys-ordering
      "Bekijk het Privacy Beleid": "More -> Privacy Beleid",
      "Contacteer het Bestuur / Commissies": "Contact",
      // The order isn't alphabetical, but the order in which the options are displayed.
      // ignore: map-keys-ordering
      "Bekijk het Lustrum Goede Doel": "Charity",
      // ignore: map-keys-ordering
      "Bekijk de Zwanehalzen": "Zwanehalzen",
      if (firebaseAuthUser != null) "Bekijk de Agenda": "Events",
      if (firebaseAuthUser != null) 'Bekijk de Fotogalerij': 'Gallery',
      if (firebaseAuthUser != null) 'Lees Verenigingsdocumenten': 'Documents',
    };

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Meer')),
      body: CustomPaint(
        painter: LustrumBackgroundWidget(pageOffset: pageOffset),
        child: ListView(
          children: [
            ...optionRouteMap.entries.map(
              // Make a list of options to display and navigate to.
              // Each option is a tile with a divider below it.
              (entry) => [
                MoreListTile(label: entry.key, routeName: entry.value),
                const Divider(height: 0, thickness: 0.5),
              ].toColumn(),
            ),
            ListTile(
              title: Text(
                "Geef Feedback over de App",
                style: textTheme.titleMedium,
              ),
              trailing: const Icon(Icons.feedback_outlined),
              onTap: () => BetterFeedback.of(context).showAndUploadToSentry(
                name: GetIt.I<CurrentUser>()
                        .user
                        ?.username ?? // CurrentUser might not be filled yet.
                    FirebaseAuth.instance.currentUser?.uid ??
                    "Anoniem",
              ),
            ),
            const Divider(height: 0, thickness: 0.5),
            const MoreLinkTile(
              label: "Ga naar de Webshop",
              url: "https://k-s-r-v-njord.myshopify.com/",
            ),
            const Divider(height: 0, thickness: 0.5),
            const MoreLinkTile(
              label: "Ga naar de Intekenlijst Instaposts",
              url:
                  "https://docs.google.com/spreadsheets/d/11xGtoqBiAfQCzrT3Gvl5wgXYDWOu8N6bOpWk3gwjFp4/edit#gid=0",
            ),
            const Divider(height: 0, thickness: 0.5),
            const MoreLinkTile(
              label: 'Declareer Kosten aan de Quaestor',
              url:
                  'https://docs.google.com/forms/d/e/1FAIpQLSe75Utou3_t_Ja7Dmmjhasz2eVc5Ii3SkAOtKqnlwPACaBn4g/viewform',
            ),
            const Divider(height: 0, thickness: 0.5),
            const MoreLinkTile(
              label: 'Handige Linkjes - Linktree',
              url: 'https://linktr.ee/ksrvnjord_intern',
            ),
            const Divider(height: 0, thickness: 0.5),
            ListTile(
              title: Text('Uitloggen', style: textTheme.titleMedium)
                  .textColor(Colors.red),
              trailing: const Icon(Icons.logout, color: Colors.red),
              visualDensity: VisualDensity.standard,
              onTap: () => ref.read(authModelProvider).logout(),
            ),
          ],
        ),
      ),
      // Floatingaction button to navigate to admin page.
      floatingActionButton: currentUserVal.when(
        data: (currentUser) {
          final canAccesAdminPanel = currentUser.isAdmin;

          return canAccesAdminPanel
              ? FloatingActionButton.extended(
                  foregroundColor: colorScheme.onTertiaryContainer,
                  backgroundColor: colorScheme.tertiaryContainer,
                  onPressed: () => context.goNamed('Admin'),
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text('Ga naar Admin Panel'),
                )
              : null;
        },
        error: (e, s) {
          FirebaseCrashlytics.instance.recordError(e, s);

          return const SizedBox.shrink();
        },
        loading: () => const SizedBox.shrink(),
      ),
    );
  }
}
