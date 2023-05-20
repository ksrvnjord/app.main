import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/init_messaging_info.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/request_messaging_permission.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/save_messaging_token.dart';
import 'package:routemaster/routemaster.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    requestMessagingPermission();
    saveMessagingToken();
    initMessagingInfo();
  }

  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);

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
            icon: Icon(Icons.chat_outlined),
            label: 'Prikbord',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_calendar),
            label: 'Afschrijven',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Almanak'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Meer'),
        ],
        onTap: (value) => animateTo(value, tabPage),
        currentIndex: tabPage.controller.index,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void animateTo(int index, TabPageState tabPage) {
    tabPage.controller.animateTo(index);
  }
}
