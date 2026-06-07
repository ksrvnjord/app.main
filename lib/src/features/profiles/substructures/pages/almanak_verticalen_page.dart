import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';

class AlmanakVerticalenPage extends ConsumerWidget {
  const AlmanakVerticalenPage({
    super.key,
    required this.id,
  });
  final int id;
  static const double titleHPadding = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verticalen'),
      ),
      body: ref.watch(ploegenProvider(id)).when(
            data: (ploegen) {
              if (ploegen.isEmpty) {
                return const Center(
                  child: Text('Geen ploegen gevonden voor dit verticaal.'),
                );
              }
              ploegen.sort((a, b) => b['year'].compareTo(a['year']));

              return ListView.separated(
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
    );
  }
}
