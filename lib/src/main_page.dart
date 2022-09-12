import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);

    return Scaffold(
      appBar: null,
      body: TabBarView(
        controller: tabPage.controller,
        children: [
          for (final stack in tabPage.stacks) PageStackNavigator(stack: stack),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabPage.controller.index,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign),
              label: 'Ad Valvas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Almanak',
            ),
          ],
          onTap: (value) {
            tabPage.controller.animateTo(value);
          }),
    );
  }
}
