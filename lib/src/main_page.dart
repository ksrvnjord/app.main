import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabState = CupertinoTabPage.of(context);

    return CupertinoTabScaffold(
      controller: tabState.controller,
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
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
      ),
      tabBuilder: (BuildContext context, int index) {
        return HeroControllerScope(
          controller: MaterialApp.createMaterialHeroController(),
          child: PageStackNavigator(
            key: ValueKey(tabState.page.paths[index]),
            stack: tabState.stacks[index],
          ),
        );
      },
    );
  }
}
