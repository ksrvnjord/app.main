import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/years_from_1874.dart';

class YearSelectorDropdown extends StatelessWidget {
  const YearSelectorDropdown({
    super.key,
    required this.onChanged,
    required this.selectedYear,
  });

  final void Function(int?) onChanged;
  final int selectedYear;

  @override
  Widget build(BuildContext context) {
    const double menuHeight = 240;

    return DropdownButton<int>(
      items: yearsFrom1874
          .map(
            (njordYear) => DropdownMenuItem(
              value: njordYear.item1,
              child: Text("${njordYear.item1}-${njordYear.item2}"),
            ),
          )
          .toList(),
      value: selectedYear,
      onChanged: onChanged,
      menuMaxHeight: menuHeight,
    );
  }
}
