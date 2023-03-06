import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/chip_widget.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../edit_my_profile/models/commissie_entry.dart';

class CommissiesListWidget extends StatelessWidget {
  const CommissiesListWidget({
    Key? key,
    required this.snapshot,
    required this.legacyCommissies, // TODO: remove this after 1 june 2023, this is to support old way to enter commissies
  }) : super(key: key);

  final QuerySnapshot<CommissieEntry> snapshot;
  final List<String>? legacyCommissies;

  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot<CommissieEntry>> docs = snapshot.docs;
    docs.sort((a, b) => -1 * a.data().startYear.compareTo(b.data().startYear));

    const double fieldTitleFontSize = 16;
    const double fieldTitlePadding = 16;

    Map<String, Color> functionMap = {
      "Praeses": Colors.lightBlue[300]!,
      "Ab-actis": Colors.red[300]!,
      "Quaestor": Colors.lightGreen[300]!,
    };

    const double commissieNameFontSize = 20;
    const double headerBottomPadding = 8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: docs.isNotEmpty
          ? [
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
                      ListTile(
                        tileColor: Colors.white,
                        title: Text(doc.data().name)
                            .fontSize(commissieNameFontSize),
                        subtitle: <Widget>[
                          Chip(
                            label: Text(
                              "${doc.data().startYear}-${doc.data().endYear}",
                            ),
                            avatar: const Icon(
                              Icons.date_range,
                              color: Colors.white,
                              size: 16,
                            ),
                            backgroundColor: Colors.blueGrey[200],
                            labelPadding:
                                const EdgeInsets.only(left: 2, right: 8),
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          if (doc.data().function != null &&
                              doc.data().function!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Chip(
                                label: Text(doc.data().function!),
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                // show avatar
                                avatar: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                labelPadding:
                                    const EdgeInsets.only(left: 2, right: 8),
                                backgroundColor:
                                    functionMap[doc.data().function!] ??
                                        Colors.blueGrey[300],
                              ),
                            ),
                        ].toRow(),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                      ),
                    ].toColumn(),
                  )
                  .toList()
                  .toColumn(),
            ]
          : [
              legacyCommissies != null && legacyCommissies!.isNotEmpty
                  ? ChipWidget(title: "Commissies", values: legacyCommissies!)
                  : Container(),
            ],
    );
  }
}
