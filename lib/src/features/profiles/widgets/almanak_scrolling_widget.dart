import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_button_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

class AlmanakScrollingWidget extends StatefulWidget {
  final GraphQLClient client;
  final String search;

  const AlmanakScrollingWidget(
      {Key? key, required this.client, this.search = ''})
      : super(key: key);

  @override
  createState() => _AlmanakScrollingState();
}

class _AlmanakScrollingState extends State<AlmanakScrollingWidget> {
  final _pagingController = PagingController<int, Query$Almanak$users$data>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(
    int pageKey,
  ) async {
    int usersPerPage = 25;
    Query$Almanak$users? result =
        await almanakUsers(usersPerPage, pageKey, widget.search, widget.client);

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
    _pagingController.refresh();

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
          itemBuilder: (context, item, index) => AlmanakUserButtonWidget(item),
          firstPageErrorIndicatorBuilder: (context) => const LoadingWidget(),
          noItemsFoundIndicatorBuilder: (context) => Column(
            children: const [
              Text('Geen Leeden gevonden met deze zoekterm.'),
            ],
          ),
        ),
      ),
    );
  }
}
