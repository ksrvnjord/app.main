import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/constants.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class AuthModel extends ChangeNotifier {
  oauth2.Client? client;
  bool isBusy = false;
  String error = '';

  /// Tries to login
  bool login(String username, String password) {
    var loginState = false;

    if (username == '') {
      error = 'Please enter a username';
      notifyListeners();
      return loginState;
    }

    if (password == '') {
      error = 'Please enter a password';
      notifyListeners();
      return loginState;
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
      loginState = true;
      notifyListeners();
    }).onError((err, stackTrace) {
      isBusy = false;
      error = "Login failed";
      notifyListeners();
    });

    return loginState;
  }
}
