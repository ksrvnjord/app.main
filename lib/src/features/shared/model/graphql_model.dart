import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/auth_constants.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';

// ignore: prefer-static-class
final graphQLModelProvider = ChangeNotifierProvider<GraphQLModel>((ref) {
  final auth = ref.watch(authModelProvider); // We need auth for the client.

  return GraphQLModel(auth);
});

// @immutable // TODO: Make immutable.
class GraphQLModel extends ChangeNotifier {
  static final GraphQLCache cache = GraphQLCache(store: InMemoryStore());

  GraphQLClient client = GraphQLClient(
    link: HttpLink('https://heimdall.njord.nl/graphql'),
    cache: cache,
  );

  GraphQLModel(AuthModel auth) {
    client = boot(auth);
  }

  GraphQLClient boot(AuthModel auth) {
    final authConstants = GetIt.I.get<AuthConstants>();
    final HttpLink httpLink = HttpLink('${authConstants.baseURL}/graphql/');

    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer ${auth.client?.credentials.accessToken}',
    );

    final Link link = authLink.concat(httpLink);
    final GraphQLClient client = GraphQLClient(
      link: link,
      cache: cache,
    );

    // Fill contact details.
    GetIt.I.get<CurrentUser>().fillContact(client);

    return client;
  }
}
