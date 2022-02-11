import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/group_container.dart';

class AmendableGroepField extends StatelessWidget {
  const AmendableGroepField(this.label, this.values, {Key? key})
      : super(key: key);

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          const SizedBox(height: 3),
          GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5,
                  childAspectRatio: 7.1),
              scrollDirection: Axis.vertical,
              itemCount: values.length,
              padding: const EdgeInsets.all(5),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, idx) {
                return Container(
                    child: Text(values[idx]),
                    padding: const EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ));
              }),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ]);
  }
}
