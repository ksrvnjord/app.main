import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrv_njord_app/providers/heimdall.dart';

const String users = r'''
  query users {
      data {
        identifier,
        name,
        email,
        username
      }
    }
''';

class AlmanakProfile extends HookConsumerWidget {
  const AlmanakProfile({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    throw UnimplementedError();
  }
  // Make a profile page with name and ploeg etc.
}