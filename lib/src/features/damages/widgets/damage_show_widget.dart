import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageShowWidget extends StatelessWidget {
  final Damage? damage;
  final double borderRadius = 12;
  final double padding = 8;

  const DamageShowWidget({
    Key? key,
    required this.damage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (damage == null) {
      return Container();
    }

    final damageImage = damage?.image != null
        ? FirebaseStorage.instance.ref().child(damage!.image!).getDownloadURL
        : null;

    return Wrap(children: <Widget>[
      DataTextListTile(name: 'Type', value: damage?.type ?? ''),
      DataTextListTile(name: 'Object', value: damage?.name ?? ''),
      DataTextListTile(name: 'Description', value: damage?.description ?? ''),
      DataTextListTile(
        name: 'Kritisch',
        value: (damage?.critical ?? false) ? 'Ja' : 'Nee',
      ),
      DataTextListTile(
        name: 'Aangemaakt',
        value: damage?.createdTime.toString() ?? '',
      ),
      damageImage != null
          ? ListTile(
              title: const Text(
                'Foto',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              subtitle: FutureWrapper(
                future: damageImage(),
                success: (data) => ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Image.network(
                    data,
                  ),
                ),
                error: (_) => Container(),
              ).padding(vertical: padding),
            )
          : Container(),
    ]).scrollable(scrollDirection: Axis.vertical);
  }
}
