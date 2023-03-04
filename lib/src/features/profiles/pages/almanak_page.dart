import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/my_profile_picture.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakPage extends StatelessWidget {
  const AlmanakPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double cardTitleFontSize = 24;

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
          InkWell(
            onTap: () => Routemaster.of(context).push('leeden'),
            child: [
              // load image from assets
              const Image(
                image: AssetImage('assets/images/leeden.png'),
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
              const Text("Leeden")
                  .fontSize(cardTitleFontSize)
                  .alignment(Alignment.center),
            ].toColumn().card(),
          ),
        ],
      ),
    );
  }
}
