import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/model/vaarverbod.dart';
import 'package:universal_html/js.dart';
class VaarverbodCardWidget extends ConsumerWidget {
  VaarverbodCardWidget({
    super.key,
    required this.vaarverbod,
    required this.context,
  });

  final BuildContext context;

  final Vaarverbod? vaarverbod;

  final colorScheme = Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String message;
    bool status;
    if (vaarverbod == null) {
      icon = FontAwesomeIcons.circleExclamation;
      message = 'Niet gelukt om te laden';
      status = true;
    } else {
      // ignore_for_file: unchecked_use_of_nullable_value
      message =
          vaarverbod.status ? 'Er is een vaarverbod' : 'Er is geen vaarverbod';
      status = vaarverbod.status;
      icon = vaarverbod.status
          ? FontAwesomeIcons.ban
          : FontAwesomeIcons.shieldHalved;
    }

    final colorScheme = Theme.of(context).colorScheme;
    const containerOpacity = 0.6;
    final Color backgroundColor =
        status ? colorScheme.errorContainer : colorScheme.secondaryContainer;

    const double descriptionPadding = 8;

    final onContainerColor = status
        ? colorScheme.onErrorContainer
        : colorScheme.onSecondaryContainer;

    final textStyle = Theme.of(context).textTheme.bodyLarge;

    final textStyleColored = textStyle?.copyWith(
      color: onContainerColor,
    );

    final vaarverbodInternalMessage = vaarverbod?.message;

    return ExpandablePanel(
      header: [
        Icon(icon, color: onContainerColor),
        Text(
          message,
          style: textStyleColored,
        ),
      ]
          .toRow(separator: const SizedBox(width: descriptionPadding))
          .paddingDirectional(start: descriptionPadding),
      collapsed: const SizedBox.shrink(),
      expanded: [
        if (vaarverbodInternalMessage != null)
          Text(
            vaarverbodInternalMessage,
            style: textStyleColored,
          ),
        const WeatherWidget(),
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            separator: const SizedBox(height: descriptionPadding),
          )
          .paddingDirectional(all: descriptionPadding),
      theme: const ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        tapHeaderToExpand: true,
        hasIcon: true,
      ),
    ).card(
      color: backgroundColor.withOpacity(containerOpacity),
      elevation: 0,
      margin: const EdgeInsets.all(0),
    );
  }
}
