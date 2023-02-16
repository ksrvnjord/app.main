import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_button_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/default_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

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

  Widget showMyProfilePictureWidgetIfAuthenticatedByFirebase(
    BuildContext context,
  ) {
    if (FirebaseAuth.instance.currentUser != null) {
      const profileIconSize = 48.0;

      return IconButton(
        iconSize: profileIconSize,
        icon: FutureWrapper(
          future: getMyProfilePicture(),
          success: (data) => data != null
              ? CircleAvatar(
                  backgroundImage: MemoryImage(data),
                )
              : const DefaultProfilePicture(),
          loading: const ShimmerWidget(child: DefaultProfilePicture()),
          error: (_) => const DefaultProfilePicture(),
        ),
        onPressed: () => Routemaster.of(context).push('edit'),
      );
    }

    return Container();
  }
}
