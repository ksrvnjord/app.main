import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_filters_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_overview.dart';
import 'package:styled_widget/styled_widget.dart';

class AllTrainingPage extends ConsumerWidget {
  const AllTrainingPage({Key? key}) : super(key: key);

  // Generate a list of the coming 14 days.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final currentUser = ref.watch(currentFirestoreUserProvider);

    final int amountOfDaysUserCanBookInAdvance =
        currentUser?.isBestuur == true || currentUser?.isAppCo == true
            ? 28 // Bestuur and AppCo can book 28 days in the advance.
            : 4; // User can book 4 days in the advance.

    final List<DateTime> days = List.generate(
      amountOfDaysUserCanBookInAdvance,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    return DefaultTabController(
      length: days.length,
      // ignore: sort_child_properties_last
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Afschrijven'),
          bottom: TabBar(
            tabs: days
                .map<Widget>((e) => Tab(
                      text: DateFormat('EEEE d MMM', 'nl_NL').format(e),
                    ))
                .toList(),
            isScrollable: true,
          ),
        ),
        body: [
          TabBarView(
            // ignore: sort_child_properties_last
            children: days
                .map<Widget>((date) => CalendarOverview(date: date))
                .toList(),
            physics: const NeverScrollableScrollPhysics(),
          ).expanded(),
        ].toColumn(),
        floatingActionButton: Stack(children: [
          FloatingActionButton(
            // ignore: sort_child_properties_last
            child: const Icon(Icons.filter_list_alt),
            tooltip: "Kies afschrijf filters",
            foregroundColor: colorScheme.onPrimaryContainer,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShowFiltersPage(),
            )),
          ),
        ]),
      ),
      animationDuration: const Duration(milliseconds: 1726 ~/ 2),
    );
  }
}
