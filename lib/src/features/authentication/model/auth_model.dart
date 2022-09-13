import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksrvnjord_main_app/constants.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

const _storage = FlutterSecureStorage();

class AuthModel extends ChangeNotifier {
  oauth2.Client? client;
  bool isBusy = false;
  String error = '';
  String storedUser = '';

  AuthModel() {
    isBusy = true;
    boot().then((value) {
      client = value;
    }).whenComplete(() {
      isBusy = false;
      notifyListeners();
    });
  }

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
          key: 'oauth2_credentials', value: client?.credentials.toJson());
      notifyListeners();
      return true;
    }

    isBusy = false;
    notifyListeners();
    return false;
  }

  Future<oauth2.Client?> boot() async {
    String? storedCreds = await _storage.read(key: 'oauth2_credentials');
    dynamic credentials = jsonDecode(storedCreds ?? '{}');

    if (credentials['expiration'] != null) {
      DateTime expiration =
          DateTime.fromMillisecondsSinceEpoch(credentials['expiration']);
      if (expiration.isAfter(DateTime.now())) {
        return oauth2.Client(oauth2.Credentials.fromJson(storedCreds!));
      }
    }

    return null;
  }

  void logout() {
    _storage.delete(key: 'oauth2_credentials').then((value) {
      client = null;
      notifyListeners();
    });
  }
}
