import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/global_constants.dart';

final HttpLink httpLink = HttpLink('https://heimdall.njord.nl/graphql');
final GraphQLCache cache = GraphQLCache(store: InMemoryStore());

class GraphQLModel extends ChangeNotifier {
  GraphQLClient client = GraphQLClient(link: httpLink, cache: cache);

  GraphQLModel(AuthModel? auth) {
    if (auth != null) {
      client = boot(auth);
    }
  }

  GraphQLClient boot(AuthModel auth) {
    final globalConstants = GetIt.I.get<GlobalConstants>();
    final HttpLink httpLink = HttpLink('${globalConstants.baseURL}/graphql/');

    final AuthLink authLink = AuthLink(
        getToken: () async => 'Bearer ${auth.client!.credentials.accessToken}');

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: cache,
    );
  }
}
