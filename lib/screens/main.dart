import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksrv_njord_app/assets/images.dart';
import 'package:ksrv_njord_app/pages/announcements.dart';
import 'package:ksrv_njord_app/pages/home.dart';
import 'package:ksrv_njord_app/widgets/bar_logo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const BarLogoWidget(image: Images.appLogo),
        ),
        body: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;

            switch (settings.name) {
              case '/':
                builder = (BuildContext context) => const HomePage();
                setState(() {
                  _currentIndex = 0;
                });
                break;
              case '/announcements':
                builder = (BuildContext context) => const AnnouncementsPage();
                setState(() {
                  _currentIndex = 1;
                });
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }

            return MaterialPageRoute(
              builder: builder,
              settings: settings,
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: false,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });

              switch (index) {
                case 0:
                  _navigatorKey.currentState?.popAndPushNamed('/');
                  break;
                case 1:
                  _navigatorKey.currentState?.popAndPushNamed('/announcements');
                  break;
                default:
                  throw Exception('Invalid index called');
              }
            },
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
            ]));
  }
}
