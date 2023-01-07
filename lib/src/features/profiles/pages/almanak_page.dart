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
        title: [
          const Text("Almanak"),
          IconButton(
            padding: const EdgeInsets.all(0),
            iconSize: 40,
            icon: FutureWrapper(
                future: getMyProfilePicture(),
                success: (snapshot) {
                 if (snapshot != null) {
                    return CircleAvatar(
                      backgroundImage: MemoryImage(snapshot),
                    );
                  } else {
                  return showDefaultProfilePicture();
                  }
                },
                loading:  ShimmerWidget(child: showDefaultProfilePicture()),
                error: (_) => showDefaultProfilePicture() 
                ),
            onPressed: () {
              Routemaster.of(context).push('edit');
            },
          )
        ].toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: AlmanakWidget(client: client),
    );
  }
}
