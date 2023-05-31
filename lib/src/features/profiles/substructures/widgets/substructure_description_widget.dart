import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class SubstructureDescriptionWidget extends ConsumerWidget {
  const SubstructureDescriptionWidget({
    Key? key,
    required this.descriptionAsyncVal,
  }) : super(key: key);

  final AsyncValue<String?> descriptionAsyncVal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double loadingHeight = 120;

    return descriptionAsyncVal.when(
      data: (data) => data == null
          ? const SizedBox.shrink()
          : [
              Text(
                data,
                style: Theme.of(context).textTheme.bodyMedium,
              ).expanded(flex: 0),
            ].toColumn(),
      loading: () => ShimmerWidget(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          height: loadingHeight,
        ),
      ),
      error: (error, stack) => ErrorCardWidget(
        errorMessage: error.toString(),
      ),
    );
  }
}
