import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/substructure_choice_list_tile.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

/// Page that shows a list of choices, and pushes a new page when a choice is chosen
class CommissieChoicePage extends ConsumerWidget {
  const CommissieChoicePage({
    Key? key,
    required this.title,
    required this.choices,
  }) : super(key: key);

  final String title;
  final List<String> choices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => [
          SubstructureChoiceListTile(
            name: choices[index],
            imageProvider: ref.watch(commissieThumbnailProvider(
              Tuple2(choices[index], getNjordYear()),
            )),
          ),
          const Divider(height: 0, thickness: 0.5),
        ].toColumn(),
        itemCount: choices.length,
      ),
    );
  }
}
