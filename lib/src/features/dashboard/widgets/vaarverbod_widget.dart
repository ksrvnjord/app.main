import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/vaarverbod_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/model/vaarverbod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class VaarverbodWidget extends ConsumerWidget {
  const VaarverbodWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(vaarverbodProvider).when(
          data: (data) => _buildVaarverbodCard(vaarverbod: data),
          loading: () => ShimmerWidget(
            child: _buildVaarverbodCard(),
          ),
          error: (error, stack) => _buildVaarverbodCard(),
        );
  }

  Widget _buildVaarverbodCard({
    Vaarverbod? vaarverbod,
  }) {
    IconData icon;
    String message;
    bool status;
    if (vaarverbod == null) {
      icon = FontAwesomeIcons.circleExclamation;
      message = 'Niet gelukt om te laden';
      status = true;
    } else {
      message =
          vaarverbod.status ? 'Er is een vaarverbod' : 'Er is geen vaarverbod';
      status = vaarverbod.status;
      if (vaarverbod.status) {
        icon = FontAwesomeIcons.ban;
      } else {
        icon = FontAwesomeIcons.shieldHalved;
      }
    }

    final Color backgroundColor =
        status ? Colors.red[300]! : Colors.green[300]!;

    const double descriptionPadding = 8;

    return ExpansionTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(message),
      collapsedTextColor: Colors.white,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      // ignore: no-equal-arguments
      collapsedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      // ignore: no-equal-arguments
      collapsedBackgroundColor: backgroundColor,
      // ignore: no-equal-arguments
      collapsedIconColor: Colors.white,
      // ignore: no-equal-arguments
      iconColor: Colors.white,
      children: [
        Text(vaarverbod?.message ?? 'Laden...')
            .textColor(Colors.white)
            .paddingDirectional(
              horizontal: descriptionPadding,
              // ignore: no-equal-arguments
              bottom: descriptionPadding,
            ),
      ],
    );
  }
}
