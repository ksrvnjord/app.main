import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: null,
      body: TabBarView(
        // ignore: sort_child_properties_last
        children: [
          for (final stack in tabPage.stacks) PageStackNavigator(stack: stack),
        ],
        controller: tabPage.controller,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined), label: 'Prikbord'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar), label: 'Afschrijven'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Almanak'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Meer'),
        ],
        onTap: (value) => animateTo(value, tabPage),
        currentIndex: tabPage.controller.index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
      ),
    );
  }

  void animateTo(int index, TabPageState tabPage) {
    tabPage.controller.animateTo(index);
    // ignore: avoid-ignoring-return-values
    Routemaster.of(context).push(Routes.mainRoutes[
        index]); // When the user taps on the bottom navigation bar item, we want to push the corresponding route, so that the user can 'reset' the page.
  }
}
