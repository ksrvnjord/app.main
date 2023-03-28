import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/polls_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class PollsPage extends ConsumerWidget {
  const PollsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollsVal = ref.watch(pollsProvider);
    // create DateFormat for Dayname Day Month Year Time
    final DateFormat dateFormat = DateFormat('EEEE d MMMM y HH:mm', 'nl_NL');

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
          padding: const EdgeInsets.all(8),
          itemCount: polls.size,
          itemBuilder: (context, index) {
            final poll = polls.docs.toList()[index].data();

            return [
              ListTile(
                title: Text(poll.question),
                subtitle: Text(
                  'Sluit op ${dateFormat.format(poll.openUntil)}',
                ),
              ),
              ...poll.options.map((option) => RadioListTile(
                    value: option,
                    title: Text(option),
                    onChanged: (_) => {},
                    groupValue: 'Ja',
                  )),
            ].toColumn().card(
                  color: Colors.white,
                  elevation: 0,
                  // add lightblue border
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.lightBlue, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 5),
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
