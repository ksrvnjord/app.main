import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/tag.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/widgets/group_info_tile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/group_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../edit_my_profile/models/commissie_entry.dart';

class UserGroupsListWidget extends StatelessWidget {
  const UserGroupsListWidget({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<GroupEntry>> snapshot;

  Widget _buildGroupInfoTile(
    BuildContext context,
    QueryDocumentSnapshot<GroupEntry> doc,
  ) {
    final GroupEntry entry = doc.data();

    switch (entry.runtimeType) {
      case CommissieEntry:
        final commissieEntry = entry as CommissieEntry;
        return GroupInfoTile(
          header: doc.data().name,
          startYear: doc.data().year,
          endYear: doc.data().year + 1,
          tags: (commissieEntry.function == null ||
                  (commissieEntry.function as String).isEmpty)
              ? null
              : [
                  Tag(
                    label: commissieEntry.function as String,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    icon: Icons.person,
                  ),
                ],
          groupPath: "Commissie",
        );
      case PloegEntry:
        final ploegEntry = entry as PloegEntry;
        return GroupInfoTile(
          header: doc.data().name,
          startYear: doc.data().year,
          endYear: doc.data().year + 1,
          tags: [
            Tag(
              label: ploegEntry.role.value,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              icon: Icons.person,
            ),
          ],
          groupPath: "Ploeg",
        );
      default:
        throw UnimplementedError(
          "GroupInfoTile for ${entry.runtimeType} is not implemented",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot<GroupEntry>> docs = snapshot;
    bool usedPloegFeature =
        false; // TODO: remove this when we most users have migrated to the new system.
    for (final doc in docs) {
      if (doc.data() is PloegEntry) {
        usedPloegFeature = true;
        break;
      }
    }

    const double fieldTitlePadding = 16;

    const double headerBottomPadding = 8;

    return docs.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Commissies${usedPloegFeature ? " & Ploegen" : ""}",
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
