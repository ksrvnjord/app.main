import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_state.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/init_messaging_info.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/request_messaging_permission.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/save_messaging_token.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/auth_constants.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// ignore: prefer-static-class
final authModelProvider = ChangeNotifierProvider((ref) => AuthModel());

// TODO: make this class immutable.
class AuthModel extends ChangeNotifier {
  String _error = '';

  String _accessToken = '';

  AuthState _authState = AuthState.loading; // Default to loading on startup.

  final _storage = const FlutterSecureStorage();

  final _authConstants = GetIt.I.get<AuthConstants>();

  String get error => _error;

  get accessToken => _accessToken;

  // Oauth2.Client? get client => _client;.
  AuthState get authState => _authState;

  // On Startup, try to login with the stored credentials.
  // If the credentials are not expired, try to login to Firebase as well.
  Future<bool> get _boot async {
    // Get stored credentials.
    String? exp = await _storage.read(key: "access_exp");
    if (exp == null) {
      return false;
    }

    final expiration = int.parse(exp);
    // ignore: no-magic-number
    if ((expiration * 1000) < DateTime.now().millisecondsSinceEpoch) {
      // Token is expired, delete it.
      await _storage.delete(key: 'access_token');

      throw Exception('Token expired.');
    }

    // Change the environment based on the token endpoint.
    _authConstants.environment =
        await _storage.read(key: 'environment') == "${Environment.demo}"
            ? Environment.demo
            : Environment.production;
    _accessToken = await _storage.read(key: 'access_token') ?? '';
    authState = AuthState.authenticated;
    await _firebaseLogin();

    return true;
  }

  set authState(AuthState value) {
    _authState = value;
    notifyListeners();
  }

  AuthModel() {
    // ignore: prefer-async-await
    authState = AuthState.loading;
    // ignore: avoid-async-call-in-sync-function, prefer-async-await
    _boot.then((loggedIn) {
      authState =
          loggedIn ? AuthState.authenticated : AuthState.unauthenticated;
    }).onError((_, __) {
      authState = AuthState.unauthenticated;
    });
  }

  // Login with State and config Management.
  // SHOULD ONLY BE CALLED ON THE LOGIN PAGE.
  Future<void> login(String username, String password) async {
    // ignore: avoid-ignoring-return-values
    _error = ""; // Reset error message.
    authState = AuthState.loading;
    _authConstants.environment =
        username == "demo" ? Environment.demo : Environment.production;
    await _storage.write(
      key: 'environment',
      value: "${_authConstants.environment}",
    );
    final loggedIn = await _heimdallLogin(username, password);
    if (!loggedIn) {
      authState = AuthState.unauthenticated;

      return;
    }
    await _firebaseLogin();
    authState = AuthState.authenticated;
  }

  void logout() async {
    await unsubscribeAllTopics();
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'access_exp');
    await FirebaseAuth.instance.signOut();
    authState = AuthState.unauthenticated;
  }

  Future<void> unsubscribeAllTopics() async {
    final box = await Hive.openBox<bool>('topics');
    if (!kIsWeb) {
      for (String key in box.keys) {
        await FirebaseMessaging.instance.unsubscribeFromTopic(key);
      }
    }
    // ignore: avoid-ignoring-return-values
    await box.clear();
  }

  Future<void> subscribeDefaultTopics(String userId) async {
    try {
      // Required topics to subscribe to.
      if (!kIsWeb) {
        await FirebaseMessaging.instance.subscribeToTopic(userId);
        await FirebaseMessaging.instance.subscribeToTopic("all");
      }

      // Store the subscribed topics in a local cache.
      Box cache = await Hive.openBox<bool>('topics');
      await cache.put(userId, true);
      await cache.put('all', true);
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st);

      return;
    }
  }

  // Tries to login into Heimdall and Firebase.
  Future<bool> _heimdallLogin(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _error = 'Both email and password fields are required.';

      // Throw Exception('Both email and password fields are required.');.
      return false;
    }

    try {
      final result = await Dio().post(_authConstants.oauthEndpoint, data: {
        'email': email,
        'password': password,
      });
      // Write the credentials to the secure storage.
      final String token = result.data['access'];
      _accessToken = token;
      await _storage.write(key: 'access_token', value: token);
      await _storage.write(
        key: "access_exp",
        value: result.data['data']['exp'].toString(),
      );

      return true;
    } catch (e) {
      _error = (e as DioException).response?.data['detail'] ?? 'Unknown error';

      return false;
    }
  }

  // Login to Firebase with the stored credentials.
  // NOTE: The function will not do anything if the environment is set to demo.
  Future<void> _firebaseLogin() async {
    if (_authConstants.environment == Environment.demo) {
      // Don't login to Firebase in demo mode.
      return;
    }

    final String? token = await _storage.read(key: 'access_token');
    // Only fire this if an access token is available.
    if (token == null) {
      throw Exception('No access token found.');
    }

    try {
      // Get the token for the configured (constant) endpoint JWT.
      final response = await Dio().get(
        _authConstants.jwtEndpoint().toString(),
        options: Options(headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      // The token is returned as JSON, decode it.
      final data = json.decode(response.data);

      // If we have data and we have the token in our data, proceed to login.
      // ignore: avoid-missing-interpolation
      if (data != null && data['token'] != null) {
        // ignore: avoid-ignoring-return-values, avoid-missing-interpolation
        await FirebaseAuth.instance.signInWithCustomToken(data['token']);

        String? uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          FirebaseCrashlytics.instance.setUserIdentifier(
            uid,
          ); // Link crashes to users, so we can reach out to them if needed.
          // Subscribe the user to FirebaseMessaging as well.
          if (!kIsWeb) {
            requestMessagingPermission(); // TODO: Only prompt if the user is able to give permission, ie. not when user already gave permissies or denied them.
            subscribeDefaultTopics(uid);
            // Web does not support messaging, also user should be logged in to Firebase for it to work.
            saveMessagingToken(); // TODO: Retry on no internet connection.
            initMessagingInfo();
          }
        }
      }
    } catch (e, st) {
      // If it fails, we don't want to die just yet - but do send
      // the exception to Sentry for further research.
      // ignore: avoid-ignoring-return-values
      Sentry.captureException(_error, stackTrace: st);
    }
  }
}
