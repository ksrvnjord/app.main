import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.dart';

class CurrentUser {
  Query$Me$me? user;

  void fillContact(GraphQLClient client) async {
    user = await me(client);
  }
}
