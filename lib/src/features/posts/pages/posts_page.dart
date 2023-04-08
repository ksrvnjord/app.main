import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_topics_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/posts_provider.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:routemaster/routemaster.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(postTopicsProvider).when(
          data: (topics) => DefaultTabController(
            length: topics.length,
            animationDuration: const Duration(
              milliseconds: 1726 ~/ 2,
            ), // no need to explain this
            child: Scaffold(
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
                  tabs: topics
                      .map((topic) => Tab(
                            text: topic,
                          ))
                      .toList(),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => Routemaster.of(context).push('new'),
                backgroundColor: Colors.blue,
                icon: const Icon(Icons.add),
                label: const Text('Nieuw bericht'),
              ),
              body: TabBarView(
                children: topics
                    .map((topic) => ref.watch(postsProvider(topic)).when(
                          data: (snapshot) => PostList(snapshot: snapshot),
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (error, stack) =>
                              ErrorCardWidget(errorMessage: error.toString()),
                        ))
                    .toList(),
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              ErrorCardWidget(errorMessage: error.toString()),
        );
  }
}
