import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/almanak_substructure_cover_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class AlmanakVerticalenPage extends ConsumerWidget {
  const AlmanakVerticalenPage({
    super.key,
    required this.id,
    required this.verticaalName,
  });
  final int id;
  final String verticaalName;
  static const double titleHPadding = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentUserVal = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verticalen'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96.0),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: AlmanakSubstructureCoverPicture(
              imageProvider:
                  ref.watch(verticaalPictureProvider(verticaalName)),
            ),
          ),
          ref.watch(ploegenProvider(id)).when(
                data: (ploegen) {
                  if (ploegen.isEmpty) {
                    return const Center(
                      child: Text('Geen ploegen gevonden voor dit verticaal.'),
                    );
                  }
                  ploegen.sort((a, b) => b['year'].compareTo(a['year']));

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: ploegen.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      final ploeg = ploegen[index];
                      final ploegName = ploeg['name'];
                      final ploegYear = ploeg['year'];

                      return ListTile(
                        title: Text(ploegName),
                        subtitle: Text(ploegYear.toString()),
                        onTap: () {
                          context.pushNamed(
                            'Ploeg',
                            pathParameters: {'name': ploegName},
                            queryParameters: {'year': ploegYear.toString()},
                          );
                        },
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
        ],
      ),
      floatingActionButton: currentUserVal.when(
        data: (currentUser) {
          final canAccessEditGroupPage = currentUser.isAdmin;
          if (!canAccessEditGroupPage) return null;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                heroTag: "Verticaal -> Edit",
                foregroundColor: colorScheme.onTertiaryContainer,
                backgroundColor: colorScheme.tertiaryContainer,
                onPressed: () {
                  context.pushNamed(
                    "Verticaal -> Edit",
                    pathParameters: {
                      "id": id.toString(),
                    },
                    queryParameters: {
                      "verticaalName": verticaalName,
                    },
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit'),
              ),
            ],
          );
        },
        error: (e, s) {
          debugPrint("Error message when retrieving permission: $e");
          return null;
        },
        loading: () => const SizedBox.shrink(),
      ),
    );
  }
}
