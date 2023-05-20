import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/vaarverbod_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/model/vaarverbod.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/weather_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class VaarverbodWidget extends ConsumerWidget {
  const VaarverbodWidget({
    super.key,
  });

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
      icon = vaarverbod.status
          ? FontAwesomeIcons.ban
          : FontAwesomeIcons.shieldHalved;
    }
    final Color backgroundColor =
        status ? Colors.red[300]! : Colors.green[300]!;

    const double descriptionPadding = 8;
    const double headerFontSize = 16;

    return ExpandablePanel(
      header: [
        Icon(icon, color: Colors.white),
        Text(message).fontSize(headerFontSize).textColor(Colors.white),
      ]
          .toRow(separator: const SizedBox(width: descriptionPadding))
          .paddingDirectional(start: descriptionPadding),
      collapsed: const SizedBox.shrink(),
      expanded: [
        Text(vaarverbod?.message ?? 'Laden...').textColor(Colors.white),
        const WeatherWidget(),
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            separator: const SizedBox(height: descriptionPadding),
          )
          .paddingDirectional(all: descriptionPadding),
      theme: const ExpandableThemeData(
        iconColor: Colors.white,
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        tapHeaderToExpand: true,
        hasIcon: true,
      ),
    ).card(
      color: backgroundColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: const EdgeInsets.all(0),
    );
  }

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
}
