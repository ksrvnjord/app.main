import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_topics_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/selected_topic_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:routemaster/routemaster.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(postTopicsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prikbord"),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => ProviderScope(
                // When using a provider inside a modal bottom sheet, you need to wrap it in a ProviderScope, because the sheet is placed at the top of the widget tree.

                parent: ProviderScope.containerOf(
                  context,
                ), // The new provider scope will share the same providers as the parent scope.

                child: Consumer(
                  // We need a consumer to have access to the providers of the provider scope.
                  builder: (_, ref, __) {
                    final selectedTopic = ref.watch(selectedTopicProvider);

                    return Wrap(children: [
                      RadioListTile<String?>(
                        // Add extra option to show all posts.
                        value: null, // Null means no topic selected.
                        groupValue: selectedTopic,
                        onChanged: (value) => ref
                            .read(selectedTopicProvider.notifier)
                            .state = value,
                        title: const Text("Alle posts"),
                      ),
                      for (final topic in topics)
                        RadioListTile<String>(
                          value: topic,
                          groupValue: selectedTopic,
                          onChanged: (value) => ref
                              .read(selectedTopicProvider.notifier)
                              .state = value,
                          title: Text(topic),
                        ),
                    ]);
                  },
                ),
              ),
              isScrollControlled: true,
            ),
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: const FirebaseWidget(
        onAuthenticated: PostList(),
        onUnauthenticated: Center(child: Text("Er zijn geen nieuwe berichten")),
      ),
      floatingActionButton: FirebaseWidget(
        onAuthenticated: FloatingActionButton.extended(
          onPressed: () => Routemaster.of(context).push('new'),
          icon: const Icon(Icons.add),
          label: const Text('Nieuw bericht'),
        ),
      ),
    );
  }
}
