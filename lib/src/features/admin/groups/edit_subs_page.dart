import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/home_users.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_users.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/substructures.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class EditSubstructurePage extends ConsumerWidget {
  const EditSubstructurePage(
      {super.key, this.type, required this.substructureName});

  final String? type;
  final String substructureName;

  Future<void> removeUserFromGroup(
      String iid, WidgetRef ref, BuildContext ctx) async {
    try {
      final userDoc = peopleCollection.doc(iid);
      if (type == "Substructuren") {
        await userDoc.update({
          'substructures': FieldValue.arrayRemove([substructureName])
        });
      } else {
        await userDoc.update({'huis': null});
      }
      if (ctx.mounted) {
        if (ctx.mounted) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text('Lid verwijderd')),
          );
        }
      }
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> addUserToSubstructure(
      String iid, WidgetRef ref, BuildContext ctx) async {
    try {
      final userDoc = peopleCollection.doc(iid);
      if (type == "Substructuren") {
        await userDoc.update({
          'substructures': FieldValue.arrayUnion([substructureName])
        });
      } else {
        await userDoc.update({'huis': substructureName});
      }
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSubstructure =
        substructures.toList().contains(substructureName);

    final subMembers = isSubstructure
        ? ref.watch(substructureUsersProvider(substructureName))
        : ref.watch(homeUsers(substructureName));

    return Scaffold(
        appBar: AppBar(
          title: Text(substructureName),
        ),
        body: subMembers.when(
          data: (members) {
            return ListView.builder(
                itemCount: members.size,
                itemBuilder: (context, index) {
                  final QueryDocumentSnapshot<FirestoreUser> userDoc =
                      members.docs[index];
                  final user = userDoc.data();

                  final String fullName = "${user.firstName} ${user.lastName}";
                  return ListTile(
                    title: Text(fullName),
                    trailing: IconButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Lid verwijderen?"),
                            content: Text(
                                "Weet je zeker dat je $fullName wil verwijderen?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Nee'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Ja'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          if (!context.mounted) return;
                          removeUserFromGroup(
                            user.identifier,
                            ref,
                            context,
                          );
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                });
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => ErrorCardWidget(
            errorMessage: error.toString(),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.pushNamed("Leeden", extra: (int userId) async {
              addUserToSubstructure(userId.toString(), ref, context);
              if (context.mounted) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lid toegevoegd')),
                );
              }
            });
          },
          icon: const Icon(Icons.add),
          label: const Text("Toevoegen"),
        ));
  }
}
