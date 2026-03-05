import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
//import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/almanak_substructure_cover_picture.dart';

class AlmanakVerticalenPage extends ConsumerWidget {
  const AlmanakVerticalenPage({
    super.key,
    required this.name,
  });
  final String name;
  static const double titleHPadding = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double pageHPadding = 12;
    const double descriptionHPadding = pageHPadding + 4;
    /*final verticalLeeden = ref.watch(
      getPloegenForVertical(dio: dio, verticaal_id: verticaal_id)
    );
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ListView(
        children: [
          /*ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: AlmanakSubstructureCoverPicture(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: AlmanakSubstructureCoverPicture(
                      imageProvider: ref.watch(verticalsPictureProvider(name))))
              .padding(horizontal: pageHPadding),*/
          SubstructureDescriptionWidget(
              descriptionAsyncVal: ref.watch(
            verticalDescriptionProvider(name),
          )).padding(all: descriptionHPadding),
          [
            Text("Leden", style: Theme.of(context).textTheme.titleLarge)
                .alignment(Alignment.centerLeft)
                .padding(horizontal: titleHPadding),
          ].toColumn(),
          verticalLeeden.when(
            data: (snapshot) => buildVerticalList(snapshot),
            error: (error, stk) =>
                ErrorCardWidget(errorMessage: error.toString()),
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        ],
      ),
    );
  }

  Widget buildVerticalList(List<GroupDjangoRelation> entries) {
    const double notFoundPadding = 16;
    return <Widget>[
      if (entries.isEmpty)
        const Text("Geen leden gevonden voor dit verticaal")
            .center()
            .padding(all: notFoundPadding)
    ].toColumn();
  }*/
    return SizedBox();
  }
}
