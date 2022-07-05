/// This file contains the necessary objects to authenticate against the
/// Heimdall API
///
/// This includes [AuthenticationRepository], which expose methods
/// to log-in to Heimdall and to get the token to perform actions in
/// a type-safe way.
///
/// It also includes all the intermediate objects used to deserialize the
/// response from the API.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/dio.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksrvnjord_main_app/constant.dart' as constant
    show baseURL, demoURL, Endpoint;

final authenticationProvider =
    ChangeNotifierProvider((ref) => AuthenticationService(ref.read));

class AuthenticationService extends ChangeNotifier {
  AuthenticationService(this._read);

  final Reader _read;
  final storage = const FlutterSecureStorage();

  String bearer = '';
  bool loggedIn = false;
  String baseURL = constant.baseURL;

  void updateBaseURL(String _baseURL) {
    baseURL = _baseURL;
    bearer = '';
    loggedIn = false;
    notifyListeners();
  }

  Future<void> logout() async {
    // TODO: add a call to the API to purge the current token
    await storage.delete(key: 'bearerToken');
    bearer = '';
    loggedIn = false;
    notifyListeners();
  }

  Future<bool> loginFromStorage() async {
    String storedBearer = await storage.read(key: 'bearerToken') ?? '-';

    if (storedBearer.length > 1) {
      try {
        var authResponse = await _read(dioProvider).get<Map<String, Object?>>(
            baseURL + constant.Endpoint.user,
            options: Options(headers: {
              'Authorization': 'Bearer $storedBearer',
              'Accept': 'application/json'
            }));

        if (authResponse.statusCode == 200) {
          bearer = storedBearer;
          loggedIn = true;
          notifyListeners();
          return true;
        }
      } catch (e) {
        if (e is DioError) {
          if (e.response != null && e.response!.statusCode == 401) {
            bearer = '';
            loggedIn = false;
            await storage.delete(key: 'bearerToken');
            return false;
          }
        }
      }
    }
    bearer = '';
    loggedIn = false;
    await storage.delete(key: 'bearerToken');
    return false;
  }

  Future<String> attemptLogin(String username, String password) async {
    try {
      if (username == 'demo' && password == 'testing') {
        var demoURL = constant.demoURL;
        _read(heimdallProvider).updateBaseURL(demoURL);
        baseURL = demoURL;
      }
      var csrfResponse = await _read(dioProvider)
          .get<Map<String, Object?>>(baseURL + constant.Endpoint.csrf);

      var tokenResponse = await _read(dioProvider)
          .post<Map<String, Object?>>(baseURL + constant.Endpoint.login, data: {
        'username': username,
        'password': password,
        'csrf_token': csrfResponse.data!['csrf_token']
      });

      if (tokenResponse.statusCode == 200) {
        bearer = tokenResponse.data!['token'].toString();
        storage.write(key: 'bearerToken', value: bearer);
        loggedIn = true;
        notifyListeners();
        return 'OK';
      }
    } catch (e) {
      if (e is DioError) {
        return e.response.toString();
      }

      return 'Unexpected Error Occurred!';
    }

    return 'Login Failed';
  }
}
