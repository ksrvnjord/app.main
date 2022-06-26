import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_info/amendable_user_field.dart';

double fieldSeperation = 8;

class AmendableUserRow extends StatelessWidget {
  const AmendableUserRow(this.user, this.contactChanges, this.labels,
      this.widths, this.rowWidth, this.callBack,
      {Key? key})
      : super(key: key);

  final dynamic user;
  final Map<String, dynamic> contactChanges;
  final List<Map<String, dynamic>> labels;
  final List<double> widths;
  final double rowWidth;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return (SizedBox(
        height: 31,
        width: rowWidth,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: labels.length,
            separatorBuilder: (BuildContext context, int index) => SizedBox(
                  width: fieldSeperation,
                ),
            itemBuilder: (BuildContext context, int index) {
              return (AmendableUserField(
                  labels[index],
                  {
                    'private': user['fullContact']['private']
                        [labels[index]['backend']],
                    'update': user['fullContact']['update']
                        [labels[index]['backend']],
                    'change': contactChanges[labels[index]['backend']]
                  },
                  rowWidth * widths[index] - fieldSeperation,
                  callBack));
            })));
  }
}
