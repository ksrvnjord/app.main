import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
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
    WidgetRef ref,
    BuildContext ctx,
  ) {
    return (int userId) async {
      final dio = ref.read(dioProvider);
      try {
        // ignore: avoid-ignoring-return-values
        await dio.post(
          "/api/users/groups/$groupId/add/",
          data: {"user": userId},
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
                floating: true,
                pinned: true,
              ),
              SliverList.builder(
                itemBuilder: (context, index) {
                  final Map<String, dynamic> user = users[index]['user'];
                  final String? role = users[index]['role'];

                  return ListTile(
                    title: Text(user['first_name'] + ' ' + user['last_name']),
                    subtitle: role == null ? null : Text(role),
                    trailing: IconButton(
                      onPressed: () =>
                          removeUserFromGroup(user['identifier'], ref, context),
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
          extra: addUserToGroupCallBack(ref, context),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Voeg lid toe'),
      ),
    );
  }
}
