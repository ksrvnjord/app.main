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
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => Consumer(
                builder: (_, ref, __) => Wrap(children: [
                  RadioListTile<String?>(
                    value: null,
                    groupValue: selectedTopic,
                    onChanged: (value) =>
                        ref.read(selectedTopicProvider.notifier).state = value,
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
                ]),
              ),
              isScrollControlled: true,
            ),
            icon: const Icon(Icons.filter_list),
          ),
        ],
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: const FirebaseWidget(
        onAuthenticated: PostList(),
        onUnauthenticated: Center(child: Text("Er zijn geen nieuwe berichten")),
      ),
      floatingActionButton: FirebaseWidget(
        onAuthenticated: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          onPressed: () => Routemaster.of(context).push('new'),
          icon: const Icon(Icons.add),
          label: const Text('Nieuw bericht'),
        ),
      ),
    );
  }
}
