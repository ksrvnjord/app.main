import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_structure_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/my_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/image_cache_item.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakPage extends StatelessWidget {
  const AlmanakPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double choiceWidgetPadding = 4;

    Hive.openBox<ImageCacheItem>(
      'imageCache',
    ); // open the image cache box, we don't have to do this lazily because it won't contain that much data and everyone has plenty of RAM

    return Scaffold(
      appBar: AppBar(
        title: const Text("Almanak"),
        actions: <Widget>[
          FirebaseAuth.instance.currentUser != null
              ? const MyProfilePicture(profileIconSize: 48.0)
              : Container(),
        ],
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const AlmanakStructureChoiceWidget(
            title: "Leeden",
            pushRoute: "leeden",
            imagePath: 'assets/images/leeden.png',
          ).padding(all: choiceWidgetPadding),
          if (FirebaseAuth.instance.currentUser !=
              null) // this is all Firebase stuff, so demo users can't see it
            [
              const AlmanakStructureChoiceWidget(
                title: "Bestuur",
                pushRoute: "bestuur",
                imagePath: 'assets/images/bestuur.jpeg',
              ).padding(all: choiceWidgetPadding),
              const AlmanakStructureChoiceWidget(
                title: "Commissies",
                pushRoute: "commissies",
                imagePath: 'assets/images/commissies.jpeg',
              ).padding(all: choiceWidgetPadding),
              const AlmanakStructureChoiceWidget(
                pushRoute: "huizen",
                title: "Huizen",
                imagePath: 'assets/images/huizen.jpeg',
              ).padding(all: choiceWidgetPadding),
              // TODO: Add ploegen
              const AlmanakStructureChoiceWidget(
                title: "Substructuren",
                pushRoute: "substructuren",
                imagePath: 'assets/images/substructures.jpeg',
              ).padding(all: choiceWidgetPadding),
            ].toColumn(),
        ],
      ),
    );
  }
}
