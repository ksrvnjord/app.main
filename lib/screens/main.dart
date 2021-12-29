import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrv_njord_app/assets/images.dart';
import 'package:ksrv_njord_app/pages/announcements.dart';
import 'package:ksrv_njord_app/pages/almanak.dart';
import 'package:ksrv_njord_app/pages/home.dart';
import 'package:ksrv_njord_app/widgets/images/bar_logo.dart';

class RoutedWidget {
  RoutedWidget(this.index, this.label, this.widget);

  final int index;
  final String label;
  final Widget widget;
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'NavigatorState');
  int _currentIndex = 0;

  final Map<String, RoutedWidget> widgets = {
    '/': RoutedWidget(0, 'Home', const HomePage()),
    '/announcements':
        RoutedWidget(1, 'Announcements', const AnnouncementsPage()),
    '/almanak':
        RoutedWidget(2, 'Almanak', const AlmanakPage()),
  };

  RoutedWidget generateRoute(RouteSettings s) {
    if (s.name != null) {
      RoutedWidget? widget = widgets[s.name];
      if (widget != null) {
        return widget;
      }
      throw Exception('MainScreen Navigator: Unknown route!');
    } else {
      throw Exception('MainScreen Navigator: No route path given!');
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
            RoutedWidget widget = generateRoute(s);

            Future.delayed(
                Duration.zero,
                () => setState(() {
                      _currentIndex = widget.index;
                    }));

            return PageRouteBuilder(
                pageBuilder: (BuildContext context, _, __) => Container(
                      child: widget.widget,
                      constraints: const BoxConstraints.expand(),
                      color: Colors.white,
                    ),
                transitionDuration: Duration.zero,
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
                case 2:
                  _navigatorKey.currentState?.pushNamed('/almanak');
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
