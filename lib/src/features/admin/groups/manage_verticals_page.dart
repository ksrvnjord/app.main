import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class ManageVerticalsPage extends ConsumerWidget {
  const ManageVerticalsPage({
    super.key,
  });

  Future<void> createNewVerticaal({
    required DjangoGroup group,
    required WidgetRef ref,
    required BuildContext ctx,
  }) async {
    final dio = ref.read(dioProvider);
    try {
      // ignore: avoid-ignoring-return-values
      await dio.post(
        "/api/v2/groups/",
        data: group.toJson(),
      );
    } catch (e) {
      if (ctx.mounted) {
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              "Het is niet gelukt om de verticaal aan te maken.",
            ),
          ),
        );
        return;
      }
    }

    if (!ctx.mounted) return;
    // ignore: avoid-ignoring-return-values
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(content: Text("Verticaal is aangemaakt.")),
    );
    // ignore: avoid-ignoring-return-values
    ref.invalidate(verticalsProvider("Verticaal"));
  }

  Widget _buildCreateGroupBottomSheet(
    String name,
  ) {
    final nameController = TextEditingController(text: name)
      ..selection = TextSelection.collapsed(
        offset: name.length,
      ); // If keyboard collapses, it triggers rebuild, which resets the selection. So we need to set it again.

    return Consumer(
      builder: (context, ref, _) {
        final type = "Verticaal";
        final year = getNjordYear();

        const double cardPadding = 16;

        const double bottomPaddingModal = 16;

        return [
          Text(
            'Maak nieuw verticaal',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Naam',
              border: OutlineInputBorder(),
            ),
            autocorrect: false,
            onChanged: (value) =>
                ref.read(djangoGroupNotifierProvider.notifier).setName(value),
          ),
          FilledButton(
            // ignore: prefer-extracting-callbacks
            onPressed: () {
              createNewVerticaal(
                group: DjangoGroup(
                  name: nameController.text.trim(),
                  type: type,
                  year: year,
                ),
                ref: ref,
                ctx: context,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Maak verticaal'),
          ),
        ]
            .toColumn(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              separator: const SizedBox(height: 16),
            )
            .padding(
              all: cardPadding,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom + bottomPaddingModal,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verticalsVal = ref.watch(verticalenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Beheer Verticalen"),
      ),
      body: verticalsVal.when(
        data: (data) {
          data = data
              .toList()
              ..sort((a, b) {
                final gender = (a['name'].startsWith("Dames") ? 0 : 1).compareTo(b['name'].startsWith("Dames") ? 0 : 1);
                if (gender != 0) {
                  return gender;
                }
                return a['name'].length.compareTo(b['name'].length);
              });
          return data.isEmpty
              ? const Center(
                  child: Text('Geen verticalen gevonden.'),
                )
              : ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final vertical = data[index];
                    final verticalId = vertical['id'];
                    final verticalName = vertical['name'];
                    return ListTile(
                      title: Text(verticalName),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () =>
                          context.goNamed('Edit Vertical', pathParameters: {
                        'verticaalId': verticalId.toString(),
                      }, queryParameters: {
                        'verticaalName': verticalName,
                      }),
                    );
                });
        },
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
      floatingActionButton: // Extended floating action button to Create a group.
          FloatingActionButton.extended(
        // ignore: prefer-extracting-callbacks
        onPressed: () {
          // ignore: avoid-ignoring-return-values
          showModalBottomSheet(
            context: context,
            builder: (context) {
              final name = ref.read(djangoGroupNotifierProvider).name;

              return _buildCreateGroupBottomSheet(name);
            },
            isScrollControlled: true,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nieuw Verticaal'),
      ),
    );
  }
}
