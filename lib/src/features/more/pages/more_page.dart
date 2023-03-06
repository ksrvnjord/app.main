import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/more_link_tile.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/more_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> optionMap = {
      "Mijn Njord-account": "/settings",
      "Agenda": "events",
      "Contact": "/contact",
      "Beleid van het bestuur": "beleid",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meer'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          ...optionMap.entries.map(
            // Make a list of options to display and navigate to
            // Each option is a tile with a divider below it
            (entry) => [
              MoreListTile(
                label: entry.key,
                routePath: entry.value,
              ),
              const Divider(),
            ].toColumn(),
          ),
          ListTile(
            title: const Text("Feedback geven"),
            trailing:
                const Icon(Icons.feedback_outlined, color: Colors.lightBlue),
            onTap: () => BetterFeedback.of(context).showAndUploadToSentry(
              name: GetIt.I<CurrentUser>()
                      .user
                      ?.username ?? // CurrentUser might not be filled yet
                  FirebaseAuth.instance.currentUser?.uid ??
                  "Anoniem",
            ),
          ),
          const Divider(),
          const MoreLinkTile(
            label: "Webshop",
            url: "https://k-s-r-v-njord.myshopify.com/",
          ),
          const Divider(),
          const MoreLinkTile(
            label: 'Declareren',
            url:
                'https://docs.google.com/forms/d/e/1FAIpQLSe75Utou3_t_Ja7Dmmjhasz2eVc5Ii3SkAOtKqnlwPACaBn4g/viewform',
          ),
          const Divider(),
          const MoreLinkTile(
            label: 'Handige linkjes - Linktree',
            url: 'https://linktr.ee/ksrvnjord_intern',
          ),
          const Divider(),
          ListTile(
            title: const Text('Uitloggen').textColor(Colors.red),
            trailing: const Icon(Icons.logout, color: Colors.red),
            onTap: () =>
                Provider.of<AuthModel>(context, listen: false).logout(),
          ),
        ],
      ),
    );
  }
}
