import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';

final HttpLink httpLink = HttpLink('https://heimdall.njord.nl/graphql');
final GraphQLCache cache = GraphQLCache(store: InMemoryStore());

class GraphQLModel extends ChangeNotifier {
  GraphQLClient client = GraphQLClient(link: httpLink, cache: cache);

  void boot(AuthModel auth) {
    final HttpLink httpLink = HttpLink('https://heimdall.njord.nl/graphql');

    final AuthLink authLink = AuthLink(
        getToken: () async => 'Bearer ${auth.client!.credentials.accessToken}');

    final Link link = authLink.concat(httpLink);

    client = GraphQLClient(
      link: link,
      cache: cache,
    );
  }
}
