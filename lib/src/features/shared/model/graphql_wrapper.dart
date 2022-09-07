import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';

class GraphQLWrapper extends StatelessWidget {
  GraphQLWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;
  final auth = GetIt.I<AuthModel>();

  @override
  Widget build(BuildContext context) {
    if (auth.client != null && auth.client?.credentials != null) {
      final HttpLink httpLink = HttpLink('https://heimdall.njord.nl/graphql');
      final AuthLink authLink = AuthLink(
          getToken: () async =>
              'Bearer ${auth.client!.credentials.accessToken}');
      final Link link = authLink.concat(httpLink);
      ValueNotifier<GraphQLClient> client = ValueNotifier(
        GraphQLClient(
          link: link,
          // The default store is the InMemoryStore, which does NOT persist to disk
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );
      return GraphQLProvider(client: client, child: child);
    }

    return Container();
  }
}
