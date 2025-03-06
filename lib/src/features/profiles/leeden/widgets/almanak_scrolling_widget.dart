import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/birthday_users_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart'
    as njord_user;
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_button_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

class AlmanakScrollingWidget extends ConsumerStatefulWidget {
  const AlmanakScrollingWidget({super.key, this.search = '', this.onTap});

  final String search;
  final void Function(int userId)? onTap;

  @override
  createState() => _AlmanakScrollingState();
}

class _AlmanakScrollingState extends ConsumerState<AlmanakScrollingWidget> {
  final _pagingController = PagingController<int, DjangoUser>(
    firstPageKey: 0,
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
    const amountOfResults = 100;
    final birthdayResult =
        await almanakBirthdayUsersProvider(pageKey, widget.search, ref);
    final result = await almanakUsersProvider(pageKey, widget.search, ref);

    final birthdayUsers = birthdayResult['items'] as List;
    final nonBirthdayUsers = result['items'] as List;
    final users = birthdayUsers +
        nonBirthdayUsers; //list the users with the birthday people first

    List<DjangoUser>? page = users
        .map((user) => DjangoUser.fromJson(user as Map<String, dynamic>))
        .toList();

    if (result['count'] / amountOfResults > pageKey) {
      _pagingController.appendPage(page, pageKey + 1);

      return;
    }
    _pagingController.appendLastPage(page);
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
      child: PagedListView<int, DjangoUser>.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => AlmanakUserButtonWidget(
            njord_user.User(django: item),
            onTap: () => onTap != null
                ? onTap(int.parse(item.identifier.toString()))
                // ignore: avoid-async-call-in-sync-function
                : context.pushNamed(
                    "Lid",
                    pathParameters: {
                      "id": FirebaseAuth.instance.currentUser != null
                          ? item.identifier.toString()
                          : item.id.toString(),
                    },
                  ),
          ),
          firstPageErrorIndicatorBuilder: (context) =>
              const LoadingWidget(), // TODO: Error widget.
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
