import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.gr.dart';
import 'package:auto_route/auto_route.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
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
        });
  }
}
