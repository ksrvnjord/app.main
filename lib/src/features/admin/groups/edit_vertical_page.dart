import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

/// Page to perform CRD operations on group-members for a specific group (which is a year and groupname).
class EditVerticalPage extends ConsumerWidget {
  const EditVerticalPage(
      {super.key, required this.verticaalId, required this.verticaalName});

  final int verticaalId;
  final String verticaalName;

  Future<void> removePloegFromVerticaal(
    int ploegId,
    WidgetRef ref,
    BuildContext ctx,
  ) async {
    final dio = ref.read(dioProvider);
    try {
      // ignore: avoid-ignoring-return-values
      await dio.patch(
            "/api/v2/groups/$ploegId/",
            data: {"verticaal_id": null},
      );
    } catch (e) {
      if (ctx.mounted) {
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text(
              "Het is niet gelukt om de ploeg te verwijderen van de groep.",
            ),
          ),
        );

        return;
      }
    }

    if (!ctx.mounted) return;
    // ignore: avoid-ignoring-return-values
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(content: Text("Ploeg is verwijderd van de groep.")),
    );
    // ignore: avoid-ignoring-return-values
    ref.invalidate(groupByIdProvider(ploegId));

  }

  Future<void> Function(int) addPloegToVerticaalCallBack(
    WidgetRef ref,
    BuildContext ctx,
  ) {
    return (int ploegId) async {
      debugPrint(
        '[EditVerticalPage] addPloegToVerticaalCallBack start: verticaalId=$verticaalId, ploegId=$ploegId',
      );
      final dio = ref.read(dioProvider);

      try {
        // ignore: avoid-ignoring-return-values
        await dio.patch(
          "/api/v2/groups/$ploegId/",
          data: {"verticaal_id": verticaalId},
        );
      } catch (e) {
        if (!ctx.mounted) return;
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text(
              "Het is niet gelukt om de ploeg toe te voegen aan de groep.",
            ),
          ),
        );

        return;
      }

      if (!ctx.mounted) return;
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text(
          "Ploeg is toegevoegd aan de groep",
        ),
      ));

      // ignore: avoid-ignoring-return-values
      ref.invalidate(groupByIdProvider(ploegId));
      ref.invalidate(ploegenProvider(verticaalId));
      if (!ctx.mounted) return;
      ctx.pop();
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ploegenVal = ref.watch(ploegenProvider(verticaalId));

    return Scaffold(
      appBar: AppBar(
        title: Text(verticaalName),
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
                // TODO: FIXME create api/v2 delete group
                await dio.delete("/api/users/groups/$verticaalId/");
              } on DioException catch (e) {
                if (!context.mounted) return;

                // ignore: avoid-ignoring-return-values
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    e.message ??
                        "Het is niet gelukt om dit verticaal te verwijderen.",
                  ),
                ));

                return;
              }
              if (!context.mounted) return;
              // ignore: avoid-ignoring-return-values
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Verticaal is verwijderd."),
              ));
              ref.invalidate(groupsProvider);
              ref.invalidate(ploegenProvider(verticaalId));
              context.pop();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: ploegenVal.when(
        // ignore: avoid-long-functions
        data: (ploegen) {
          return CustomScrollView(
            slivers: [
              // Header for the SliverList
              const SliverToBoxAdapter(
                child: ListTile(
                  title: Text("Ploegen"),
                ),
              ),
              if (ploegen.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text('Er zijn geen ploegen in dit verticaal.'),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 96.0),
                  sliver: SliverList.builder(
                    itemBuilder: (context, index) {
                      final ploeg = ploegen[index];
                      return ListTile(
                        title: Text(ploeg['name']),
                        subtitle: Text('${ploeg['type']} - ${ploeg['year']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Bevestig verwijdering"),
                                    content: Text(
                                        "Weet je zeker dat je ${ploeg['name']} wil verwijderen?"),
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
                                  removePloegFromVerticaal(
                                    ploeg['id'],
                                    ref,
                                    context,
                                  );
                                }
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: ploegen.length,
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
          "Ploegen",
          queryParameters: {
            'year': getNjordYear().toString(),
          },
          extra: addPloegToVerticaalCallBack(ref, context),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Voeg ploeg toe'),
      ),
    );
  }
}
