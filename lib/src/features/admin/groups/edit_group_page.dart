import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/widgets/role_dialog.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

/// Page to perform CRD operations on group-members for a specific group (which is a year and groupname).
class EditGroupPage extends ConsumerWidget {
  final int groupId;

  const EditGroupPage({Key? key, required this.groupId}) : super(key: key);

  Future<void> removeUserFromGroup(
    int userId,
    WidgetRef ref,
    BuildContext ctx,
  ) async {
    final dio = ref.read(dioProvider);
    try {
      // ignore: avoid-ignoring-return-values
      await dio.post(
        "/api/users/groups/$groupId/delete/",
        data: {"user": userId},
      );
    } catch (e) {
      if (ctx.mounted) {
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text(
              "Het is niet gelukt om de gebruiker te verwijderen van de groep.",
            ),
          ),
        );

        return;
      }
    }

    if (!ctx.mounted) return;
    // ignore: avoid-ignoring-return-values
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(content: Text("Gebruiker is verwijderd van de groep.")),
    );
    // ignore: avoid-ignoring-return-values
    ref.invalidate(groupByIdProvider(groupId));
  }

  Future<void> addUserToGroup(
    String userId,
    WidgetRef ref,
    BuildContext ctx,
  ) async {
    final dio = ref.read(dioProvider);
    final res = await dio
        .post("/api/users/groups/$groupId/delete/", data: {"user": userId});

    const httpOK = 200;
    if (res.statusCode != httpOK && ctx.mounted) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text("Er is iets fout gegaan.")),
      );

      return;
    }

    if (!ctx.mounted) return;
    // ignore: avoid-ignoring-return-values
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(content: Text("Gebruiker is verwijderd van de groep.")),
    );
    // ignore: avoid-ignoring-return-values
    ref.invalidate(groupByIdProvider(groupId));
  }

  Future<void> Function(int) addUserToGroupCallBack(
    Map<String, dynamic> group,
    WidgetRef ref,
    BuildContext ctx,
  ) {
    return (int userId) async {
      final dio = ref.read(dioProvider);

      // Show a dialog to let the user select a role for the user
      // The role is either "Praeses" or "Ab-actis" or some custom entered role.
      final role = await showDialog<String>(
        context: ctx,
        builder: (context) => RoleDialog(
          groupType: group['type'],
        ),
      );

      try {
        // ignore: avoid-ignoring-return-values
        await dio.post(
          "/api/users/groups/$groupId/add/",
          data: {"user": userId, "role": role},
        );
      } catch (e) {
        if (!ctx.mounted) return;
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text(
              "Het is niet gelukt om de gebruiker toe te voegen aan de groep.",
            ),
          ),
        );

        return;
      }

      if (!ctx.mounted) return;
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text(
          "Gebruiker is toegevoegd aan de groep",
        ),
      ));

      // ignore: avoid-ignoring-return-values
      ref.invalidate(groupByIdProvider(groupId));
      if (!ctx.mounted) return;
      ctx.pop();
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupVal = ref.watch(groupByIdProvider(groupId));

    return Scaffold(
      body: groupVal.when(
        data: (data) {
          final String name = data['name'];
          final int year = data['year'];
          final List users = data['users'];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('$year - $name'),
                actions: [
                  IconButton(
                    // ignore: avoid-passing-async-when-sync-expected, prefer-extracting-callbacks
                    onPressed: () async {
                      final dio = ref.read(dioProvider);
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Bevestig verwijdering'),
                          content: const Text(
                            'Weet je zeker dat je deze groep wilt verwijderen?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Annuleren'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Verwijderen'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed != true) {
                        return;
                      }
                      try {
                        // ignore: avoid-ignoring-return-values
                        await dio.delete("/api/users/groups/$groupId/");
                      } catch (e) {
                        if (!context.mounted) return;

                        // ignore: avoid-ignoring-return-values
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Het is niet gelukt om de groep te verwijderen.",
                          ),
                        ));

                        return;
                      }
                      if (!context.mounted) return;
                      // ignore: avoid-ignoring-return-values
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Groep is verwijderd."),
                      ));
                      ref.invalidate(groupsProvider);
                      context.pop();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
                floating: true,
                pinned: true,
              ),
              users.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Text('Er zijn geen leden in deze groep.'),
                      ),
                    )
                  : SliverList.builder(
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> user = users[index]['user'];
                        final String? role = users[index]['role'];

                        return ListTile(
                          title: Text(
                            user['first_name'] + ' ' + user['last_name'],
                          ),
                          subtitle: role == null ? null : Text(role),
                          trailing: IconButton(
                            onPressed: () => removeUserFromGroup(
                              user['identifier'],
                              ref,
                              context,
                            ),
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      },
                      itemCount: users.length,
                    ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        error: (error, stack) => ErrorCardWidget(
          errorMessage: error.toString(),
        ),
      ),
      // Extended floating action button to add a new user to the group.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(
          "Leeden",
          extra: groupVal.when(
            data: (group) => addUserToGroupCallBack(group, ref, context),
            loading: () => null,
            error: (error, stack) => null,
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Voeg lid toe'),
      ),
    );
  }
}
