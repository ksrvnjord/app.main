import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/more_link_tile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/form_section.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    const double sectionPadding = 8;

    const double sectionVPadding = 8;

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.goNamed("More"),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Admin Panel'),
      ),
      body: ListView(
        children: [
          // ignore: arguments-ordering
          ExpansionTile(
            leading: const Icon(Icons.info),
            title: Text(
              "We zijn op dit moment bezig met het vernieuwen van het admin panel. De app wordt het nieuwe startpunt voor admin-taken.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // ignore: prefer-moving-to-variable, no-magic-number
            backgroundColor: colorScheme.primaryContainer.withOpacity(0.2),
            // ignore: no-equal-arguments
            collapsedBackgroundColor:
                // ignore: prefer-moving-to-variable, no-magic-number
                colorScheme.primaryContainer.withOpacity(0.2),
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "De AppCo is bezig met het vernieuwen van het admin panel. Het doel is om het makkelijker te maken om het admin panel te onderhouden en de functionaliteiten ervan uit te breiden. Het oude admin panel is nog steeds beschikbaar op https://heimdall.njord.nl/admin/. Heb je een vraag of opmerking over dit admin panel? Stuur het in #admin-panel-feedback op Slack, zodat we als AppCo er iets mee kunnen doen.",
                ),
              ),
            ],
          ),

          ListTile(
            leading: const Icon(Icons.warning_amber),
            title: const Text('Beheer vaarverbod'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.goNamed('Manage Vaarverbod'),
          ),
          // List tile to navigate to push notification create page.
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Stuur Push Notificatie'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.goNamed('Create Push Notification'),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text("Beheer Evenementen"),
            trailing: const Text("Retool"),
            visualDensity: VisualDensity.standard,
            // ignore: prefer-correct-handler-name
            onTap: () => unawaited(launchUrl(Uri.parse(
              "https://ksrvnjord.retool.com/apps/6c363b96-9c68-11ee-a9e1-f7ed1c21743e/Evenementen%20-%20CRUD",
            ))),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Beheer Polls"),
            trailing: const Text("Heimdall"),
            visualDensity: VisualDensity.standard,
            // ignore: prefer-correct-handler-name
            onTap: () => unawaited(launchUrl(Uri.parse(
              "https://heimdall.njord.nl/admin/polls",
            ))),
          ),
          ListTile(
            leading: const Icon(Icons.announcement),
            title: const Text("Beheer Aankondigingen"),
            trailing: const Text("Retool"),
            visualDensity: VisualDensity.standard,
            // ignore: prefer-correct-handler-name
            onTap: () => unawaited(launchUrl(Uri.parse(
              "https://ksrvnjord.retool.com/apps/746434de-9c55-11ee-9791-27361826cb35/Aankondigingen%20-%20CRUD",
            ))),
          ),

          FormSection(title: "Leedenadministratie", children: [
            const MoreLinkTile(
              leading: Icon(Icons.people),
              label: "Beheer Leeden",
              url: "https://heimdall.njord.nl/users",
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Beheer Groepen'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.goNamed('Manage Groups'),
            ),
          ]).paddingDirectional(vertical: sectionPadding),

          FormSection(title: 'Beheer forms', children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Maak een form aan'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.goNamed('Create Form'),
            ),
            ListTile(
              leading: const Icon(Icons.remove_red_eye),
              title: const Text('Bekijk / Beheer Forms'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.goNamed('View Forms'),
            ),
          ]).paddingDirectional(vertical: sectionVPadding),
          FormSection(
            title: "Leedenadministratie",
            children: [
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text("Beheer Leeden"),
                trailing: const Text("Heimdall"),
                visualDensity: VisualDensity.standard,
                // ignore: prefer-correct-handler-name
                onTap: () => unawaited(launchUrl(Uri.parse(
                  "https://heimdall.njord.nl/admin/users",
                ))),
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Beheer Groepen'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.goNamed('Manage Groups'),
              ),
            ],
          ).paddingDirectional(vertical: sectionPadding),
          FormSection(
            title: 'Afschrijfsysteem',
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Maak (herhalende) Afschrijving"),
                trailing: const Text("Heimdall"),
                // ignore: prefer-correct-handler-name
                onTap: () => unawaited(launchUrl(Uri.parse(
                  "https://heimdall.njord.nl/admin/rowing/reservations/new",
                ))),
              ),
              ListTile(
                leading: const Icon(Icons.warning),
                title: const Text("Beheer Schades"),
                trailing: const Text("Retool"),
                visualDensity: VisualDensity.standard,
                // ignore: prefer-correct-handler-name
                onTap: () => unawaited(launchUrl(Uri.parse(
                  "https://ksrvnjord.retool.com/apps/373edd2a-9c0f-11ee-a7ef-375aea3b6e12/Afschrijfsysteem%20-%20Schades%20(RD)",
                ))),
              ),
              ListTile(
                leading: const Icon(Icons.directions_boat),
                title: const Text("Beheer boten"),
                trailing: const Text("Retool"),
                visualDensity: VisualDensity.standard,
                // ignore: prefer-correct-handler-name
                onTap: () => unawaited(launchUrl(Uri.parse(
                  "https://ksrvnjord.retool.com/apps/406a9678-8a53-11ee-8a54-d3ac821edb1c/Afschrijfsysteem%20-%20Objecten%20CRUD",
                ))),
              ),
              const ListTile(
                leading: Icon(Icons.perm_identity, color: Colors.grey),
                title: Text(
                  'Beheer permissies (Wordt nog aan gewerkt)',
                  style: TextStyle(color: Colors.grey),
                ),
                enabled: false,
              ),
            ],
          ).paddingDirectional(vertical: sectionVPadding),
        ],
      ),
    );
  }
}
