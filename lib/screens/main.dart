import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrv_njord_app/assets/images.dart';
import 'package:ksrv_njord_app/pages/announcements.dart';
import 'package:ksrv_njord_app/pages/home.dart';
import 'package:ksrv_njord_app/widgets/images/bar_logo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'NavigatorState');
  int _currentIndex = 0;

  int routeIndex(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return 0;
      case '/announcements':
        return 1;
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }

  Widget routeWidgets(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return const HomePage();
      case '/announcements':
        return const AnnouncementsPage();
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const BarLogoWidget(image: Images.appLogo),
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
        body: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings s) {
            Future.delayed(
                Duration.zero,
                () => setState(() {
                      _currentIndex = routeIndex(s);
                    }));

            return MaterialPageRoute(
                builder: (BuildContext context) => Container(
                      child: routeWidgets(s),
                      constraints: const BoxConstraints.expand(),
                      color: Colors.white,
                    ),
                settings: s);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: _currentIndex,
            onTap: (int index) {
              switch (index) {
                case 0:
                  _navigatorKey.currentState?.pushNamed('/');
                  break;
                case 1:
                  _navigatorKey.currentState?.pushNamed('/announcements');
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
