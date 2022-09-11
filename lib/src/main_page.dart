import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);

    return SafeArea(
      child: Scaffold(
        body: TabBarView(
          controller: tabPage.controller,
          children: [
            for (final stack in tabPage.stacks)
              PageStackNavigator(stack: stack),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabPage.controller.index,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
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
            onTap: (value) {
              tabPage.controller.index = value;
            }),
      ),
    );
  }
}
