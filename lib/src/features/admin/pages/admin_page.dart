import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/more_link_tile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/form_section.dart';
import 'package:styled_widget/styled_widget.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    const double sectionPadding = 8;

    const double sectionVPadding = 8;

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
          const MoreLinkTile(
            leading: Icon(Icons.event),
            label: "Beheer Evenementen",
            url: "https://heimdall.njord.nl/events",
          ),
          const MoreLinkTile(
            leading: Icon(Icons.description),
            label: "Beheer Polls",
            url: "https://heimdall.njord.nl/polls",
          ),
          const MoreLinkTile(
            leading: Icon(Icons.announcement),
            label: "Beheer Aankondigingen",
            url: "https://heimdall.njord.nl/announcements",
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
          const FormSection(title: 'Afschrijfsysteem', children: [
            MoreLinkTile(
              leading: Icon(Icons.calendar_today),
              label: "Maak (herhalende) Afschrijving",
              url: "https://heimdall.njord.nl/rowing/reservations/new",
            ),
            MoreLinkTile(
              leading: Icon(Icons.warning),
              label: "Beheer Schades",
              url: "https://heimdall.njord.nl/rowing/damages",
            ),
            MoreLinkTile(
              leading: Icon(Icons.directions_boat),
              label: "Beheer Boten",
              url: "https://heimdall.njord.nl/rowing/equipment",
            ),
            ListTile(
              leading: Icon(Icons.perm_identity, color: Colors.grey),
              title: Text(
                'Beheer permissies (Wordt nog aan gewerkt)',
                style: TextStyle(color: Colors.grey),
              ),
              enabled: false,
            ),
          ]).paddingDirectional(vertical: sectionVPadding),
        ],
      ),
    );
  }
}
