import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_topics_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/selected_topic_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';
import 'package:routemaster/routemaster.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(postTopicsProvider);
    final firebaseUser = ref.watch(firebaseAuthUserProvider);

    return firebaseUser == null
        ? Scaffold(
            appBar: AppBar(
              title: const Text("Prikbord"),
              backgroundColor: Colors.lightBlue,
              shadowColor: Colors.transparent,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.lightBlue,
              ),
            ),
            body: const Center(
              child: Text("Er zijn geen nieuwe berichten"),
            ),
          )
        : Scaffold(
            // we need this extra top-level scaffold, in case of loading/error
            body: DefaultTabController(
              length: topics.length,
              initialIndex: 1,
              animationDuration: const Duration(
                milliseconds: 1726 ~/ 2,
              ), // no need to explain this
              child: Builder(builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("Prikbord"),
                    backgroundColor: Colors.lightBlue,
                    shadowColor: Colors.transparent,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.lightBlue,
                    ),
                    bottom: TabBar(
                      isScrollable: true,
                      labelColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: const TextStyle(fontSize: 12),
                      unselectedLabelColor: Colors.white60,
                      tabs: [
                        ...topics.map((topic) => Tab(
                              text: topic,
                            )),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    // small function so we can use the ignore comment
                    // ignore: prefer-extracting-callbacks
                    onPressed: () {
                      ref.read(selectedTopicProvider.notifier).state =
                          topics[DefaultTabController.of(context).index];
                      Routemaster.of(context).push('new');
                    },
                    backgroundColor: Colors.blue,
                    icon: const Icon(Icons.add),
                    label: const Text('Nieuw bericht'),
                  ),
                  body: TabBarView(
                    children: [
                      ...topics.map((topic) => PostList(topic: topic)),
                    ],
                  ),
                );
              }),
            ),
          );
  }
}
