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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authenticationProvider =
    ChangeNotifierProvider((ref) => AuthenticationService(ref.read));

class AuthenticationService extends ChangeNotifier {
  AuthenticationService(this._read);

  final Reader _read;
  final storage = const FlutterSecureStorage();

  String bearer = '';
  bool loggedIn = false;
  final String baseURL = 'https://heimdall.njord.nl/';

  Future<bool> loginFromStorage() async {
    String storedBearer = await storage.read(key: 'bearerToken') ?? '-';

    if (storedBearer.length > 1) {
      var userResponse = await _read(dioProvider).get<Map<String, Object?>>(
          '${baseURL}api/v4/user',
          options: Options(headers: {'Authorization': 'Bearer $storedBearer'}));

      if (userResponse.statusCode == 200) {
        bearer = storedBearer;
        loggedIn = true;
        notifyListeners();
        return true;
      } else {
        bearer = '';
        loggedIn = false;
        await storage.delete(key: 'bearerToken');
      }
    }
    return false;
  }

  Future<String> attemptLogin(String username, String password) async {
    try {
      var csrfResponse = await _read(dioProvider)
          .get<Map<String, Object?>>('${baseURL}api/v1/auth/csrf');

      var tokenResponse = await _read(dioProvider)
          .post<Map<String, Object?>>('${baseURL}api/v1/auth/login', data: {
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
