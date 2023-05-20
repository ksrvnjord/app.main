import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final selectedTopic = ref.watch(selectedTopicProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prikbord"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.lightBlue,
        ),
        actions: [
          // filter button
          IconButton(
            onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => Consumer(
                builder: (_, ref, __) => Wrap(
                  children: [
                    RadioListTile<String?>(
                      title: const Text("Alle posts"),
                      value: null,
                      groupValue: selectedTopic,
                      onChanged: (value) => ref
                          .read(selectedTopicProvider.notifier)
                          .state = value,
                    ),
                    for (final topic in topics)
                      RadioListTile<String>(
                        title: Text(topic),
                        value: topic,
                        groupValue: selectedTopic,
                        onChanged: (value) => ref
                            .read(selectedTopicProvider.notifier)
                            .state = value,
                      ),
                  ],
                ),
              ),
            ),
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      floatingActionButton: FirebaseWidget(
        onAuthenticated: FloatingActionButton.extended(
          // small function so we can use the ignore comment
          // ignore: prefer-extracting-callbacks
          onPressed: () => Routemaster.of(context).push('new'),
          backgroundColor: Colors.blue,
          icon: const Icon(Icons.add),
          label: const Text('Nieuw bericht'),
        ),
      ),
      body: const FirebaseWidget(
        onAuthenticated: PostList(),
        onUnauthenticated: Center(
          child: Text("Er zijn geen nieuwe berichten"),
        ),
      ),
    );
  }
}
