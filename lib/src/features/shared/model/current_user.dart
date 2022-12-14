import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/settings/models/me.dart';

class CurrentUser {
  dynamic contact = {};

  void fillContact(GraphQLClient client) {
    contact = me(client);
    print(contact);
  }
}
