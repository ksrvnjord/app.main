import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:provider/provider.dart';

class GraphQLWrapper extends StatelessWidget {
  const GraphQLWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: ((context, value, chl) {
      if (value.client != null && value.client?.credentials != null) {
        final HttpLink httpLink = HttpLink('https://heimdall.njord.nl/graphql');
        final AuthLink authLink = AuthLink(
            getToken: () async =>
                'Bearer ${value.client!.credentials.accessToken}');
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
    }));
  }
}
