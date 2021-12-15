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

final dioProvider = Provider((ref) => Dio());

final authenticationProvider =
    ChangeNotifierProvider((ref) => AuthenticationService(ref.read));

class AuthenticationService extends ChangeNotifier {
  AuthenticationService(this._read);

  final Reader _read;

  String bearer = '';
  bool loggedIn = false;

  Future<String> attemptLogin(String username, String password) async {
    try {
      var csrfResponse = await _read(dioProvider).get<Map<String, Object?>>(
          'https://heimdall.njord.nl/api/v1/auth/csrf');

      var tokenResponse = await _read(dioProvider).post<Map<String, Object?>>(
          'https://heimdall.njord.nl/api/v1/auth/login',
          data: {
            'username': username,
            'password': password,
            'csrf_token': csrfResponse.data!['csrf_token']
          });

      if (tokenResponse.statusCode == 200) {
        bearer = tokenResponse.data!['token'].toString();
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
