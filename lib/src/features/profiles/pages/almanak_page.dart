import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_button_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakPage extends StatelessWidget {
  const AlmanakPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Almanak"),
        actions: <Widget>[
          showMyProfilePictureWidgetIfAuthenticatedByFirebase(context),
        ],
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: AlmanakWidget(client: client),
    );
  }
}

Widget showMyProfilePictureWidgetIfAuthenticatedByFirebase(
    BuildContext context) {
  if (FirebaseAuth.instance.currentUser != null) {
    return IconButton(
      iconSize: 40,
      icon: FutureWrapper(
          future: getMyProfilePicture(),
          success: (data) {
            return data != null
                ? CircleAvatar(
                    backgroundImage: MemoryImage(data),
                  )
                : showDefaultProfilePicture();
          },
          loading: ShimmerWidget(child: showDefaultProfilePicture()),
          error: (_) => showDefaultProfilePicture()),
      onPressed: () {
        Routemaster.of(context).push('edit');
      },
    );
  }

  return Container();
}
