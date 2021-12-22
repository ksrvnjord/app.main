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

  Animation<Offset> slideDirection(Animation<double> animation, int delta) {
    if (delta > 0) {
      return animation.drive(Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ));
    } else if (delta < 0) {
      return animation.drive(Tween(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ));
    } else {
      return animation.drive(Tween(begin: Offset.zero, end: Offset.zero));
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
            int delta = routeIndex(s) - _currentIndex;

            Future.delayed(
                Duration.zero,
                () => setState(() {
                      _currentIndex = routeIndex(s);
                    }));

            return PageRouteBuilder(
              pageBuilder: (context, _, __) => Container(
                  child: routeWidgets(s),
                  constraints: const BoxConstraints.expand(),
                  color: Colors.white),
              transitionsBuilder: (_, animation, __, c) => SlideTransition(
                  position: slideDirection(animation, delta), child: c),
              settings: s,
            );
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
