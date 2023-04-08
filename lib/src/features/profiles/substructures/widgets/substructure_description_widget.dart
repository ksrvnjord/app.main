import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class SubstructureDescriptionWidget extends ConsumerWidget {
  const SubstructureDescriptionWidget({
    Key? key,
    required this.descriptionAsyncVal,
  }) : super(key: key);

  final AsyncValue<String?> descriptionAsyncVal;

  static const double fontSize = 14;
  static const double widgetPadding = 16.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return descriptionAsyncVal.when(
      data: (data) => data == null
          ? const SizedBox.shrink()
          : [
              Text(data).fontSize(fontSize).expanded(flex: 0),
            ].toColumn().padding(
                all: widgetPadding,
              ), // only add padding if there is a description
      loading: () => const CircularProgressIndicator().center(),
      error: (error, stack) => ErrorCardWidget(
        errorMessage: error.toString(),
      ),
    );
  }
}
