import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksrvnjord_main_app/constants.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

const _storage = FlutterSecureStorage();

class AuthModel extends ChangeNotifier {
  oauth2.Client? client;
  bool isBusy = false;
  String error = '';

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

    if (client != null && client?.credentials != null) {
      isBusy = false;
      await _storage.write(
          key: 'oauth2_credentails', value: client?.credentials.toJson());
      notifyListeners();
      return true;
    }

    isBusy = false;
    notifyListeners();
    return false;
  }

  void boot() {
    var creds = _storage.read(key: 'oauth2_credentails');
  }
}
