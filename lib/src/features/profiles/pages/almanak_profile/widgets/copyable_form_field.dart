import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/almanak_profile_bottomsheet_widget.dart';

class CopyableFormField extends StatelessWidget {
  const CopyableFormField({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        initialValue: value,
      ),
      onLongPress: () => vibrateAndshowBottomSheet(context, label, value),
    );
  }

  void vibrateAndshowBottomSheet(context, label, value) {
    HapticFeedback.vibrate();
    showModalBottomSheet(
      context: context,
      builder: (_) => AlmanakProfileBottomsheetWidget(
        label: label,
        value: value,
      ),
    );
  }
}
