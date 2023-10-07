import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/polls_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/widgets/poll_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class PollPage extends ConsumerWidget {
  // Constructor which takes a String pollId.
  const PollPage({Key? key, required this.pollId}) : super(key: key);

  final String pollId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollVal = ref.watch(pollProvider(pollId));
    const double cardPadding = 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
      ),
      body: pollVal.when(
        data: (poll) => PollCard(
          pollDoc: poll,
          isExpanded: true,
        ).padding(all: cardPadding),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            ErrorCardWidget(errorMessage: error.toString()),
      ),
    );
  }
}
