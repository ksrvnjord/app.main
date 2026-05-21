import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_type.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/years_from_1874.dart';

class YearSelectorDropdown extends ConsumerWidget {
  YearSelectorDropdown({
    super.key,
    required this.onChanged,
    required this.selectedYear,
    this.officialName,
    this.isBestuur = false,
  });

  final void Function(int?)? onChanged;
  final int selectedYear;
  final String? officialName;
  final bool isBestuur;

  final allYearsDropdownItemList = yearsFrom1874
      .map(
        (njordYear) => DropdownMenuItem(
          value: njordYear.item1,
          child: Text("${njordYear.item1}-${njordYear.item2}"),
        ),
      )
      .toList();

  List<DropdownMenuItem<int>> _buildDropdownItemList(
      AsyncValue<List<DjangoGroup>>? groupsVal) {
    if (groupsVal != null) {
      return groupsVal.when(
        data: (data) {
          /// List of groups already in the database
          final activeYearsList = data.map((group) => group.year).toList();
          activeYearsList.sort((a, b) => b.compareTo(a));

          return customYears(activeYearsList)
              .map(
                (njordYear) => DropdownMenuItem(
                  value: njordYear.item1,
                  child: Text("${njordYear.item1}-${njordYear.item2}"),
                ),
              )
              .toList();
        },
        error: (e, st) {
          debugPrint(e.toString());
          return allYearsDropdownItemList;
        },
        loading: () => allYearsDropdownItemList,
      );
    }

    return allYearsDropdownItemList;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double menuHeight = 240;

    AsyncValue<List<DjangoGroup>>? groupsVal;
    if (isBestuur) {
      groupsVal = ref.watch(allGroupsByTypeProvider(GroupType.bestuur));
    } else if (officialName != null) {
      groupsVal = ref.watch(allGroupsByOfficialNameProvider(officialName!));
    }

    return DropdownButton<int>(
      items: _buildDropdownItemList(groupsVal),
      value: selectedYear,
      onChanged: onChanged,
      menuMaxHeight: menuHeight,
    );
  }
}
