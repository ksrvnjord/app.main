import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_button_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

class AlmanakScrollingWidget extends StatefulWidget {
  final GraphQLClient client;
  final String search;
  final void Function(int userId)? onTap;

  const AlmanakScrollingWidget({
    Key? key,
    required this.client,
    this.search = '',
    this.onTap,
  }) : super(key: key);

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

    final onTap = widget.onTap;

    return RefreshIndicator(
      child: PagedListView<int, Query$Almanak$users$data>.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Query$Almanak$users$data>(
          itemBuilder: (context, item, index) => AlmanakUserButtonWidget(
            item,
            onTap: () => onTap != null
                ? onTap(int.parse(item.identifier))
                : context.pushNamed(
                    "Lid",
                    pathParameters: {
                      "id": FirebaseAuth.instance.currentUser != null
                          ? item.identifier
                          : item.id,
                    },
                  ),
          ),
          firstPageErrorIndicatorBuilder: (context) => const LoadingWidget(),
          noItemsFoundIndicatorBuilder: (context) => const Column(
            children: [
              Text('Geen Leeden gevonden met deze zoekterm.'),
            ],
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 0),
        padding: const EdgeInsets.all(0),
      ),
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
    );
  }
}
