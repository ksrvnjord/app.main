import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/me/static_user_field.dart';
import 'package:ksrvnjord_main_app/widgets/me/amendable_user_field.dart';
import 'package:ksrvnjord_main_app/widgets/me/amendable_group_field.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_avatar.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';

double betweenFields = 20;
double marginContainer = 5;
double paddingBody = 15;

class MePage extends HookConsumerWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var api = ref.watch(heimdallProvider);
    var user = api.get('api/v1/user', null);

    return Scaffold(
        appBar: AppBar(
            title: const Text('Gebruiker'),
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: true,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
        body: FutureBuilder(
            future: user,
            builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('not started');
                case ConnectionState.waiting:
                  return const Loading();
                default:
                  var user = snapshot.data?.data;
                  return MeWidget(user);
              }
            }));
  }
}

class MeWidget extends StatelessWidget {
  MeWidget(this.user, {Key? key}) : super(key: key);

  final dynamic user;
  final Map groepen = {
    'commissies': [
      'Competitiecomissie',
      'Appcommissie',
      'Buffetcommissie',
      'Rowing blind'
    ],
    'ploegen': ['EJD', 'EJZ', 'TopC4'],
    'verticalen': ['Vanir', 'Heeren XII', 'Dames 6']
  };

  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(paddingBody), children: <Widget>[
      const Center(child: UserAvatar()),
      const SizedBox(height: 10),
      const SizedBox(height: 20),
      StaticUserField('Naam', user['name'] ?? '-'),
      StaticUserField('Lidnummer', user['identifier'] ?? '-'),
      AmendableUserField('E-mailadres', user['email'] ?? '-'),
      AmendableUserField('Telefoonnummer', user['phone_sms'] ?? '-'),
      StaticUserField('Njord-account', user['username'] ?? '-'),
      AmendableGroupField('Ploeg(en)', groepen['ploegen']),
      AmendableGroupField('Commissies', groepen['commissies']),
      AmendableGroupField('Verband/Verticaal/Dispuut', groepen['verticalen'])
    ]);
  }
}
