import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/tag.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/widgets/group_info_tile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/group_entry.dart';
import 'package:styled_widget/styled_widget.dart';

class UserGroupsListWidget extends StatelessWidget {
  const UserGroupsListWidget({
    super.key,
    required this.snapshot,
  });

  final List<GroupEntry> snapshot;

  Widget _buildGroupInfoTile(
    BuildContext context,
    GroupEntry entry,
  ) {
    String groupPath = "";
    switch (entry.groupType) {
      case "Commissie":
      case "Bestuur":
        groupPath = entry.groupType;
        break;
      case "Competitieploeg" || "Wedstrijdsectie":
        groupPath = "Ploeg";
        break;
      default:
        throw UnimplementedError("Unknown group type: ${entry.groupType}");
    }

    return GroupInfoTile(
      endYear: entry.year + 1,
      header: entry.name,
      onTap: () => context.pushNamed(
        groupPath,
        pathParameters: {
          if (groupPath != "Bestuur")
            "name": entry
                .name, // Bestuur has no path parameter, as it is always the same.
        },
        queryParameters: {
          "year": entry.year.toString(),
        },
      ),
      startYear: entry.year,
      tags: (entry.role == null || (entry.role as String).isEmpty)
          ? null
          : [
              Tag(
                label: entry.role as String,
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                icon: Icons.person,
              ),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final docs = snapshot;

    const double fieldTitlePadding = 16;

    const double headerBottomPadding = 8;

    return docs.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Betrokken met",
                style: Theme.of(context).textTheme.labelLarge,
              ).padding(
                horizontal: fieldTitlePadding,
                bottom: headerBottomPadding,
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              docs
                  .map(
                    (doc) => [
                      _buildGroupInfoTile(context, doc),
                      const Divider(
                        height: 1,
                        thickness: 1,
                      ),
                    ].toColumn(),
                  )
                  .toList()
                  .toColumn(),
            ],
          )
        : const SizedBox.shrink();
  }
}
