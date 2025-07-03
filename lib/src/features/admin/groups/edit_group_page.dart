import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_type.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/widgets/role_dialog.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

/// Page to perform CRD operations on group-members for a specific group (which is a year and groupname).
class EditGroupPage extends ConsumerWidget {
  const EditGroupPage({super.key, required this.groupId});

  final int groupId;

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
          groupType: GroupType.values.byName(group['type']),
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

  void giveUserPermission(int userId, String permission, bool add,
      WidgetRef ref, BuildContext ctx) async {
    final dio = ref.read(dioProvider);
    try {
      final response = await dio.get("/api/v2/groups/$groupId/$userId/");
      final permissions =
          (response.data["permissions"] as List<dynamic>).toSet();

      if (add) {
        permissions.add(permission);
      } else {
        permissions.remove(permission);
      }

      // ignore: avoid-ignoring-return-values
      await dio.patch("/api/v2/groups/$groupId/$userId/", data: {
        "permissions": permissions.toList(),
      });
      if (!ctx.mounted) return;
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
              "Gebruiker heeft nu ${add ? '' : 'geen '} $permission permissie."),
        ),
      );
    } catch (error) {
      if (!ctx.mounted) return;
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(
              "Het is niet gelukt om de gebruiker's toestemming te veranderen."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupVal = ref.watch(groupByIdProvider(groupId));

    return Scaffold(
      body: groupVal.when(
        // ignore: avoid-long-functions
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
                      } on DioException catch (e) {
                        if (!context.mounted) return;

                        // ignore: avoid-ignoring-return-values
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            e.message ??
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
              // Header for the SliverList
              SliverToBoxAdapter(
                child: ListTile(
                  title: const Text("Lid"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(width: 32.0, child: Icon(Icons.edit_document)),
                      SizedBox(width: 32.0, child: Icon(Icons.book)),
                    ],
                  ),
                ),
              ),
              users.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Text('Er zijn geen leden in deze groep.'),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.only(bottom: 96.0),
                      sliver: SliverList.builder(
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> user =
                              users[index]['user'];
                          final String? role = users[index]['role'];
                          bool hasFormsPermission = (users[index]['permissions']
                                  as List<dynamic>)
                              .map((e) => e as String)
                              .contains(
                                  "forms:*"); // TODO: should be forms:* or forms:create
                          bool hasAlmanakPermission = (users[index]
                                  ['permissions'] as List<dynamic>)
                              .map((e) => e as String)
                              .contains(
                                  "almanak:*"); // TODO: should be alamank:* or almanak:create

                          return StatefulBuilder(
                            builder: (context, setState) {
                              final userLastName = user['infix'].isEmpty
                                  ? user['last_name']
                                  : '${user['infix'].toString().toLowerCase()} ${user['last_name']}';
                              final userFullName =
                                  "${user['first_name']} $userLastName";

                              return ListTile(
                                title: Text(
                                  userFullName,
                                ),
                                subtitle: role == null ? null : Text(role),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) =>
                                                DeleteUserAlertDialogue(
                                                    user: user));

                                        if (confirm == true) {
                                          if (!context.mounted) return;
                                          removeUserFromGroup(
                                            user['iid'],
                                            ref,
                                            context,
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                    Checkbox.adaptive(
                                      value: hasFormsPermission,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          hasFormsPermission = value ?? false;
                                        });
                                        giveUserPermission(
                                            user['iid'],
                                            "forms:*",
                                            value ?? false,
                                            ref,
                                            context);
                                      },
                                    ),
                                    Checkbox.adaptive(
                                      value: hasAlmanakPermission,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          hasAlmanakPermission = value ?? false;
                                        });
                                        giveUserPermission(
                                            user['iid'],
                                            "almanak:*",
                                            value ?? false,
                                            ref,
                                            context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        itemCount: users.length,
                      ),
                    ),
            ],
          );
        },
        error: (error, stack) => ErrorCardWidget(
          errorMessage: error.toString(),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
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

class DeleteUserAlertDialogue extends StatelessWidget {
  const DeleteUserAlertDialogue({
    super.key,
    required this.user,
  });

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    final userLastName = user['infix'].isEmpty
        ? user['last_name']
        : '${user['infix'].toString().toLowerCase()} ${user['last_name']}';
    final userFullName = "${user['first_name']} $userLastName";

    return AlertDialog(
        title: const Text("Lid verwijderen?"),
        content: Text("Weet je zeker dat je $userFullName wil verwijderen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Nee'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ja'),
          ),
        ]);
  }
}
