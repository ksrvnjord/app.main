import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

class AlmanakWidget extends StatefulWidget {
  final GraphQLClient client;

  const AlmanakWidget({Key? key, required this.client}) : super(key: key);

  @override
  createState() => _AlmanakState();
}

class _AlmanakState extends State<AlmanakWidget> {
  final _pagingController = PagingController<int, Query$Almanak$users$data>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, widget.client);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey, GraphQLClient client) async {
    int usersPerPage = 10;
    Query$Almanak$users? result =
        await almanakUsers(usersPerPage, pageKey, client);

    if (result != null) {
      List<Query$Almanak$users$data>? page = result.data;
      if (result.paginatorInfo.hasMorePages) {
        _pagingController.appendPage(page, pageKey + 1);
      } else {
        _pagingController.appendLastPage(page);
      }
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, Query$Almanak$users$data>.separated(
        pagingController: _pagingController,
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, index) => const SizedBox(
          height: 0,
        ),
        builderDelegate: PagedChildBuilderDelegate<Query$Almanak$users$data>(
          itemBuilder: (context, item, index) => AlmanakUserWidget(item),
          firstPageErrorIndicatorBuilder: (context) => const LoadingWidget(),
          noItemsFoundIndicatorBuilder: (context) => const Text('The end'),
        ),
      ),
    );
  }
}
