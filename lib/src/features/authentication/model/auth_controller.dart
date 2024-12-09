import 'dart:convert';

import 'package:autologin/autologin.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/init_messaging_info.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/request_messaging_permission.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/save_messaging_token.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/auth_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_controller.g.dart';
part 'auth_controller.freezed.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  final _storage = const FlutterSecureStorage();

  @override
  Future<Auth> build() async {
    final constants = AuthConstants();

    // Get stored credentials.
    String? exp = await _storage.read(key: "access_exp");
    if (exp == null) {
      return Auth(authenticated: false, constants: constants);
    }

    final expiration =
        DateTime.fromMillisecondsSinceEpoch(int.parse(exp) * 1000);

    if (expiration.isBefore(DateTime.now())) {
      // Token is expired, delete it.
      await _storage.delete(key: 'access_token');

      return Auth(authenticated: false, constants: constants);
    }

    // Change the environment based on the token endpoint.
    constants.environment =
        await _storage.read(key: 'environment') == "${Environment.demo}"
            ? Environment.demo
            : Environment.production;
    final accessToken = await _storage.read(key: 'access_token') ?? '';
    await _firebaseLogin(constants);

    return Auth(
      accessToken: accessToken,
      expiration: expiration,
      authenticated: true,
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final constants = AuthConstants();
    constants.environment =
        email == "demo" ? Environment.demo : Environment.production;

    await _storage.write(key: 'environment', value: "${constants.environment}");

    final (loggedIn, _) = await _heimdallLogin(email, password, constants);

    if (!loggedIn) {
      state = AsyncValue.data(Auth(authenticated: false, constants: constants));

      return;
    }

    if (constants.environment == Environment.demo) {
      state = AsyncValue.data(Auth(
          accessToken: await _storage.read(key: 'access_token') ?? '',
          authenticated: true,
          constants: constants));

      return;
    }

    try {
      // ignore: avoid-ignoring-return-values
      await AutologinPlugin.saveCredentials(
        Credential(
          username: email,
          password: password,
          domain: "app.njord.nl",
        ),
      );
    } on PlatformException catch (error) {
      FirebaseCrashlytics.instance
          .recordError(error, StackTrace.current, reason: "PLATFORM EXCEPTION");
    } catch (error) {
      FirebaseCrashlytics.instance.recordError(error, StackTrace.current);
    }
    await _firebaseLogin(constants);
    state = AsyncValue.data(Auth(
      accessToken: await _storage.read(key: 'access_token') ?? '',
      authenticated: true,
      constants: constants,
    ));
  }

  void logout() async {
    state = const AsyncValue.loading();
    await unsubscribeAllTopics();
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'access_exp');
    await FirebaseAuth.instance.signOut();
    state = AsyncValue.data(Auth(authenticated: false));
  }

  Future<void> unsubscribeAllTopics() async {
    final box = await Hive.openBox<bool>('topics');
    if (!kIsWeb) {
      for (String key in box.keys) {
        try {
          await FirebaseMessaging.instance.unsubscribeFromTopic(key);
        } catch (error, stk) {
          FirebaseCrashlytics.instance.recordError(error, stk);
        }
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
    } catch (error, st) {
      FirebaseCrashlytics.instance.recordError(error, st);
    }
  }

  // Tries to login into Heimdall and Firebase.
  Future<(bool, String?)> _heimdallLogin(
      String email, String password, AuthConstants constants) async {
    if (email.isEmpty || password.isEmpty) {
      return (false, 'Both email and password fields are required.');
    }

    try {
      final result = await Dio().post(constants.oauthEndpoint, data: {
        'password': password,
        if (constants.environment == Environment.demo)
          'username': email, // Only send username in demo mode.
        if (constants.environment == Environment.production) 'email': email,
      });
      // Write the credentials to the secure storage.
      final String token = result.data['access'];
      await _storage.write(key: 'access_token', value: token);
      await _storage.write(
        key: "access_exp",
        value: result.data['data']['exp'].toString(),
      );

      return (true, '');
    } catch (error) {
      return (
        false,
        ((error as DioException).response?.data['detail'] ?? 'Unknown error')
            .toString(),
      );
    }
  }

  // Login to Firebase with the stored credentials.
  // NOTE: The function will not do anything if the environment is set to demo.
  Future<void> _firebaseLogin(AuthConstants constants) async {
    if (constants.environment == Environment.demo) {
      // Don't login to Firebase in demo mode.
      return;
    }

    final token = await _storage.read(key: 'access_token');
    // Only fire this if an access token is available.
    if (token == null) {
      throw Exception('No access token found.');
    }

    // Get the token for the configured (constant) endpoint JWT.
    final response = await Dio().get(
      constants.jwtEndpoint().toString(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    // The token is returned as JSON, decode it.
    final data = json.decode(response.data);

    // If we have data and we have the token in our data, proceed to login.
    // ignore: avoid-missing-interpolation
    if (data != null && data['token'] != null) {
      // ignore: avoid-ignoring-return-values, avoid-missing-interpolation
      await FirebaseAuth.instance.signInWithCustomToken(data['token']);

      String? uid = FirebaseAuth.instance.currentUser?.uid;
      // Subscribe the user to FirebaseMessaging as well.
      if (uid != null && !kIsWeb) {
        try {
          FirebaseCrashlytics.instance.setUserIdentifier(uid);
          await requestMessagingPermission(); // TODO: Only prompt if the user is able to give permission, ie. not when user already gave permissies or denied them.
          await subscribeDefaultTopics(uid);
          // Web does not support messaging, also user should be logged in to Firebase for it to work.
          await saveMessagingToken(); // TODO: Retry on no internet connection.
          await initMessagingInfo();
        } catch (error) {
          FirebaseCrashlytics.instance.recordError(error, StackTrace.current);
        }
      }
    }
  }
}

@freezed
class Auth with _$Auth {
  factory Auth({
    String? accessToken,
    DateTime? expiration,
    @Default('') String error,
    required bool authenticated,
    AuthConstants? constants,
  }) = _Auth;
}
