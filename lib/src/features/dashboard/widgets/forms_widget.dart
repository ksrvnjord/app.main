import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/polls_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/polls/widgets/poll_card.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:styled_widget/styled_widget.dart';

class FormsWidget extends ConsumerWidget {
  const FormsWidget({
    super.key,
  });

  Widget _buildOpenPollsList(
    QuerySnapshot<Poll> polls,
    BuildContext context,
  ) {
    if (polls.size == 0) {
      return const Text("Geen open forms op dit moment")
          .textColor(Theme.of(context).colorScheme.secondary);
    }
    final docs = polls.docs;
    final first = docs.first;

    return [
      ...docs.map((doc) {
        return PollCard(
          pollDoc: doc,
          isExpanded: doc == first,
        );
      }),
    ].toColumn();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openPolls = ref.watch(openPollsProvider);

    return [
      WidgetHeader(
        title: "Forms",
        titleIcon: Icons.edit_document,
        onTapName: "Alle forms",
        onTap: () => context.goNamed(RouteName.forms),
      ),
      openPolls.when(
        data: (data) => _buildOpenPollsList(data, context),
        loading: () => const CircularProgressIndicator.adaptive(),
        error: (error, stack) => Text(
          error.toString(),
        ),
      ),
    ].toColumn();
  }
}
