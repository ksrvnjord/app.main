import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/polls_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/widgets/poll_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

// TODO: Only polls that are open should be modifiable
class PollsPage extends ConsumerWidget {
  const PollsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollQuery = ref.watch(pollsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: pollQuery.when(
        data: (snapshot) => ListView.separated(
          padding: const EdgeInsets.all(8),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: snapshot.size,
          itemBuilder: (context, index) => PollCard(
            pollDoc: snapshot.docs[index],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            ErrorCardWidget(errorMessage: error.toString()),
      ),
    );
  }
}
