import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/tag.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/widgets/group_info_tile.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../edit_my_profile/models/commissie_entry.dart';

class CommissiesListWidget extends StatelessWidget {
  const CommissiesListWidget({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final QuerySnapshot<CommissieEntry> snapshot;

  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot<CommissieEntry>> docs = snapshot.docs;
    docs.sort((a, b) => -1 * a.data().startYear.compareTo(b.data().startYear));

    const double fieldTitleFontSize = 16;
    const double fieldTitlePadding = 16;

    const double headerBottomPadding = 8;

    return docs.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Commissies")
                  .fontSize(fieldTitleFontSize)
                  .textColor(Colors.grey)
                  .padding(
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
                      GroupInfoTile(
                        header: doc.data().name,
                        startYear: doc.data().startYear,
                        endYear: doc.data().endYear,
                        tags: [
                          if (doc.data().function != null &&
                              doc.data().function!.isNotEmpty)
                            Tag(
                              label: doc.data().function!,
                              backgroundColor: {
                                    "Praeses": Colors.lightBlue[300]!,
                                    "Ab-actis": Colors.red[300]!,
                                    "Quaestor": Colors.lightGreen[300]!,
                                  }[doc.data().function!] ??
                                  Colors.blueGrey[300]!,
                              icon: Icons.person,
                            ),
                        ],
                      ),
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
