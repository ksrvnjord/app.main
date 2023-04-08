import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/board/api/post_topics_provider.dart';
import 'package:ksrvnjord_main_app/src/features/board/widgets/post_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:routemaster/routemaster.dart';

class MainBoardPage extends ConsumerWidget {
  const MainBoardPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Routemaster navigator = Routemaster.of(context);
    FirebaseFirestore db = FirebaseFirestore.instance;

    final postTopics = ref.watch(postTopicsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prikbord"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigator.push('/board/new_post'),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text('Nieuw bericht'),
      ),
      body: postTopics.when(
        data: (topics) => DefaultTabController(
          length: topics.length,
          animationDuration: const Duration(milliseconds: 1726 ~/ 2),
          child: Scaffold(
            appBar: AppBar(
              title: TabBar(
                tabs: topics
                    .map((e) => Text(e, style: const TextStyle(fontSize: 25)))
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: topics
                  .map(
                    (e) => StreamBuilder<QuerySnapshot>(
                      stream: db
                          .collection('posts')
                          .where('topic', isEqualTo: e)
                          .where(
                            'createdTime',
                            isGreaterThan: DateTime.now()
                                .subtract(const Duration(days: 14)),
                          )
                          .orderBy('createdTime', descending: true)
                          .snapshots(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot,
                      ) {
                        if (snapshot.hasData) {
                          return PostList(snapshot: snapshot);
                        }
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return const Text(
                            'Geen recente activiteit op dit onderwerp',
                          );
                        }
                      },
                    ),
                  )
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
