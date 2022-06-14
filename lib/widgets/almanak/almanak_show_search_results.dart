import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/almanak/almanak_field.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

const String users = r'''
  query ($search: String!, $first: Int!, $page: Int!){
    users (search: $search, first: $first, page: $page){
      paginatorInfo{
        hasMorePages,
      }
      data {
        id,
        email,
        username,
        contact {
          first_name,
          last_name
        }
      }
    }
  }
''';

class _LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Loading();
  }
}

class ShowSearchResultsAlmanak extends StatefulHookConsumerWidget {
  final Stream<String> stream;

  const ShowSearchResultsAlmanak({Key? key, required this.stream})
      : super(key: key);

  @override
  _ShowSearchResultsAlmanakState createState() =>
      _ShowSearchResultsAlmanakState();
}

class _ShowSearchResultsAlmanakState
    extends ConsumerState<ShowSearchResultsAlmanak> {
  String currentSearch = '';
  final _pagingController = PagingController<int, dynamic>(
    // 2
    firstPageKey: 1,
  );

  @override
  void initState() {
    widget.stream.listen((text) {
      setState(() {
        currentSearch = text;
        _pagingController.refresh();
      });
    });
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, currentSearch);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey, String currentSearch) async {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    int usersPerPage = 10;
    final QueryOptions options = QueryOptions(document: gql(users), variables: {
      'search': currentSearch,
      'first': usersPerPage,
      'page': pageKey
    });
    final QueryResult results = await client.query(options);

    List<dynamic> newPage = results.data?['users']['data'];
    final bool isLastPage =
        !results.data?['users']['paginatorInfo']['hasMorePages'];

    if (isLastPage) {
      _pagingController.appendLastPage(newPage);
    } else {
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(newPage, nextPageKey);
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      // 1
      RefreshIndicator(
        onRefresh: () => Future.sync(
          // 2
          () => _pagingController.refresh(),
        ),
        // 3
        child: PagedListView.separated(
          // 4
          pagingController: _pagingController,
          padding: const EdgeInsets.all(0),
          separatorBuilder: (context, index) => const SizedBox(
            height: 0,
          ),
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, user, index) => AlmanakField(user),
            //firstPageErrorIndicatorBuilder: (context) => const Text('error'),
            //noItemsFoundIndicatorBuilder: (context) => const Text('The end'),
          ),
        ),
      );
}
