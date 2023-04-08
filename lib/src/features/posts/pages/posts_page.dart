import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prikbord"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Routemaster.of(context).push('new'),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text('Nieuw bericht'),
      ),
      body: ref.watch(postTopicsProvider).when(
            data: (topics) => DefaultTabController(
              length: topics.length,
              animationDuration: const Duration(milliseconds: 1726 ~/ 2),
              child: Scaffold(
                appBar: AppBar(
                  title: TabBar(
                    tabs: topics
                        .map((e) =>
                            Text(e, style: const TextStyle(fontSize: 25)))
                        .toList(),
                  ),
                ),
                body: TabBarView(
                  children: topics
                      .map((e) => ref.watch(postsProvider(e)).when(
                            data: (data) => PostList(snapshot: data),
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
          ),
    );
  }
}
