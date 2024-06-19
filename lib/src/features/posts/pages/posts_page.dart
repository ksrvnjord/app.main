import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/lustrum_background_widget.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_topics_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/selected_topic_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(postTopicsProvider);
    const pageOffset = 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prikbord"),
        actions: [
          FirebaseWidget(
            onAuthenticated: IconButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (_) => UncontrolledProviderScope(
                  // When using a provider inside a modal bottom sheet, you need to wrap it in a ProviderScope, because the sheet is placed at the top of the widget tree.

                  container: ProviderScope.containerOf(
                    context,
                  ), // The new provider scope will share the same providers as the parent scope.

                  child: Consumer(
                    // We need a consumer to have access to the providers of the provider scope.
                    builder: (_, ref, __) {
                      final selectedTopic = ref.watch(selectedTopicProvider);

                      FirebaseAnalytics.instance.logEvent(
                        name: 'filter_posts_button_pressed',
                        parameters: {
                          'selected_topic': selectedTopic ?? "Alle posts",
                        },
                      );

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
              ).ignore(),
              icon: const Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      body: CustomPaint(
        painter: LustrumBackgroundWidget(pageOffset: pageOffset),
        child: const FirebaseWidget(
          onAuthenticated: PostList(),
          onUnauthenticated:
              Center(child: Text("Er zijn geen nieuwe berichten")),
        ),
      ),
      floatingActionButton: FirebaseWidget(
        onAuthenticated: FloatingActionButton.extended(
          onPressed: () => context.goNamed('New Post'),
          icon: const Icon(Icons.add),
          label: const Text('Nieuw bericht'),
        ),
      ),
    );
  }
}
