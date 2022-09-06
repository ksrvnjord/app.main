import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/constants.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class AuthModel extends ChangeNotifier {
  oauth2.Client? client;
  bool isBusy = false;
  String error = '';

  /// Tries to login
  void login(String username, String password) {
    if (username == '') {
      error = 'Please enter a username';
      notifyListeners();
      return;
    }

    if (password == '') {
      error = 'Please enter a password';
      notifyListeners();
      return;
    }

    isBusy = true;
    notifyListeners();
    error = '';
    oauth2
        .resourceOwnerPasswordGrant(Endpoint.oauthEndpoint, username, password,
            identifier: Endpoint.oauthId, secret: Endpoint.oauthSecret)
        .then((value) {
      client = value;
      isBusy = false;
      notifyListeners();
    }).onError((err, stackTrace) {
      isBusy = false;
      error = "Login failed";
      notifyListeners();
    });
  }
}
