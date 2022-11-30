import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:routemaster/routemaster.dart';

class GlobalObserverService extends ChangeNotifier {
  RouteData? routeData;
  Page? page;

  void didChangeRoute(RouteData r, Page p) {
    routeData = r;
    page = p;
    notifyListeners();
  }
}

class GlobalObserver extends RoutemasterObserver {
  @override
  void didChangeRoute(RouteData routeData, Page page) {
    GetIt.I<GlobalObserverService>().didChangeRoute(routeData, page);
  }
}
