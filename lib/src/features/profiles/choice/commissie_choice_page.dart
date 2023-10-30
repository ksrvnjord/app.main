import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/substructure_choice_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/year_selector_dropdown.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

/// Page that shows a list of choices, and pushes a new page when a choice is chosen.
class CommissieChoicePage extends ConsumerWidget {
  const CommissieChoicePage({
    Key? key,
    required this.year,
  }) : super(key: key);

  final int year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commissies = ref.watch(groupsProvider(
      Tuple2(
        "commissie",
        year,
      ),
    ));

    const double yearSpacing = 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Commissies"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: [
              const Text("Kies een jaar:"),
              YearSelectorDropdown(
                onChanged: (y) => context.goNamed(
                  "Commissies",
                  queryParameters: {"year": y.toString()},
                ),
                selectedYear: year,
              ),
            ].toWrap(
              alignment: WrapAlignment.end,
              spacing: yearSpacing,
              crossAxisAlignment: WrapCrossAlignment.center,
            ),
          ),
          commissies.when(
            data: (choices) => SliverList.builder(
              itemBuilder: (context, index) => [
                SubstructureChoiceListTile(
                  name: choices[index].name,
                  imageProvider: ref.watch(commissieThumbnailProvider(
                    Tuple2(
                      choices[index].name,
                      // ignore: no-magic-number
                      2022,
                    ), // # FIXME: hardcoded year, we keep this until commissies can edit their own info.
                  )),
                  onTap: () => context.goNamed(
                    "Commissie",
                    pathParameters: {
                      "name": choices[index].name,
                    },
                    queryParameters: {
                      "year": year.toString(),
                    },
                  ),
                ),
                const Divider(height: 0, thickness: 0.5),
              ].toColumn(),
              itemCount: choices.length,
            ),
            error: (err, __) => SliverToBoxAdapter(
              child: ErrorCardWidget(errorMessage: err.toString()),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          ),
        ],
      ),
    );
  }
}
