import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/graphql_wrapper.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.gr.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';

class RouterProviders extends StatelessWidget {
  const RouterProviders({
    Key? key,
    required this.router,
  }) : super(key: key);

  final Widget router;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: ((_, value, __) {
      if (value.client != null) {
        return GraphQLWrapper(child: router);
      }

      return const LoginPage();
    }));
  }
}

class ApplicationRouter extends StatelessWidget {
  const ApplicationRouter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RouterProviders(
        router: AutoTabsScaffold(
            routes: const [
          HomeRoute(),
          AnnouncementsRoute(),
          AlmanakRoute(),
        ],
            bottomNavigationBuilder: (_, tabsRouter) {
              return BottomNavigationBar(
                currentIndex: tabsRouter.activeIndex,
                onTap: tabsRouter.setActiveIndex,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled),
                    label: 'Home',
                    backgroundColor: Colors.blue,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.all_inbox_rounded),
                    label: 'Aankondigingen',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    label: 'Almanak',
                  ),
                ],
              );
            }));
  }
}
