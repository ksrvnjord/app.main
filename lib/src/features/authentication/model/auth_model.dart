import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/constants.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class AuthModel extends ChangeNotifier {
  oauth2.Client? client;
  bool isBusy = false;
  String error = '';

  /// Tries to login
  Future<bool> login(String username, String password) async {
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

    try {
      client = await oauth2.resourceOwnerPasswordGrant(
          Endpoint.oauthEndpoint, username, password,
          identifier: Endpoint.oauthId, secret: Endpoint.oauthSecret);
    } catch (e) {
      error = e.toString();
      isBusy = false;
      notifyListeners();
      return false;
    }

    isBusy = false;
    return true;
  }
}
