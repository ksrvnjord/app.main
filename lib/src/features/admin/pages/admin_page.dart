import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/form_section.dart';
import 'package:styled_widget/styled_widget.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            onTap: () => context.goNamed('Manage Boating Ban'),
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
            title: const Text('Beheer Evenementen'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.goNamed('Manage Events'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Beheer Forms'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.goNamed('Manage Forms'),
          ),
          ListTile(
            leading: const Icon(Icons.announcement),
            title: const Text('Beheer Aankondigingen'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.goNamed('Manage Announcements'),
          ),

          FormSection(title: "Leedenadministratie", children: [
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Beheer Leeden'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.goNamed('Manage Members'),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Beheer Groepen'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.goNamed('Manage Groups'),
            ),
          ]).paddingDirectional(vertical: 8),
          FormSection(title: 'Afschrijfsysteem', children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Maak (herhalende) Afschrijving'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.goNamed('Create Recurring Reservation'),
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Beheer Permissies'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.goNamed('Manage Permissions'),
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text('Beheer Schades'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.goNamed('Manage Damages'),
            ),
            ListTile(
              leading: const Icon(Icons.directions_boat),
              title: const Text('Beheer Boten'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.goNamed('Manage Boats'),
            ),
          ]).paddingDirectional(vertical: 8),
        ],
      ),
    );
  }
}
