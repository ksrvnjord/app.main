import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // TODO: Make this a better value, so it doesn't fall back to 0.
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabState = CupertinoTabPage.of(context);

    return SafeArea(
      child: Scaffold(
        body: tabState.tabBuilder(context, _currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
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
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              tabState.tabBuilder(context, _currentIndex);
            });
          },
        ),
      ),
    );
  }
}
