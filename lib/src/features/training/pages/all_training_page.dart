import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_filters_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_overview.dart';
import 'package:styled_widget/styled_widget.dart';

class AllTrainingPage extends ConsumerWidget {
  const AllTrainingPage({super.key});

  // Generate a list of the coming 14 days (+1 if after 17:26).

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final currentUser = ref.watch(currentUserNotifierProvider);

    final now = DateTime.now();
    final int isAfter1726 = (now.hour >= 17 && now.minute >= 26) ? 1 : 0;
    final int amountOfDaysUserCanBookInAdvance = currentUser
                    ?.canBookTrainingFarInAdvance ==
                true ||
            currentUser?.isBestuur == true ||
            currentUser?.isAppCo == true
        ? 31 // Bestuur and AppCo and other users who are able to can book 28 days in the advance.
        : 4; // User can book 4 days in the advance.

    final List<DateTime> days = List.generate(
      amountOfDaysUserCanBookInAdvance + isAfter1726,
      (index) => now.add(Duration(days: index)),
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
          FloatingActionButton.extended(
            tooltip: "Kies afschrijf filters",
            foregroundColor: colorScheme.onPrimaryContainer,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ShowFiltersPage()),
            ),
            label: const Row(
              children: [
                Icon(Icons.filter_list_alt),
                SizedBox(
                  width: 8,
                ),
                Text("Filters"),
              ],
            ),
          ),
        ]),
      ),
      animationDuration: const Duration(milliseconds: 1726 ~/ 2),
    );
  }
}
