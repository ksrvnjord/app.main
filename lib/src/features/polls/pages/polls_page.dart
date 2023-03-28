import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/polls_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class PollsPage extends ConsumerWidget {
  const PollsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollsVal = ref.watch(pollsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: pollsVal.when(
        data: (polls) => ListView.builder(
          itemCount: polls.size,
          itemBuilder: (context, index) {
            final poll = polls.docs.toList()[index].data();

            return ListTile(
              title: Text(poll.question),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            ErrorCardWidget(errorMessage: error.toString()),
      ),
    );
  }
}
