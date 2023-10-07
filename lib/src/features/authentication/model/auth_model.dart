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
import 'package:ksrvnjord_main_app/src/features/shared/model/auth_constants.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:oauth2/oauth2.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// ignore: prefer-static-class
final authModelProvider = ChangeNotifierProvider((ref) => AuthModel());

// TODO: make this class immutable.
class AuthModel extends ChangeNotifier {
  oauth2.Client? client;

  String error = '';
  String storedUser = '';

  final _storage = const FlutterSecureStorage();
  bool _isBusy = false;
  bool get isBusy => _isBusy;
  get _authConstants => GetIt.I.get<AuthConstants>();

  set isBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  AuthModel() {
    isBusy = true;
    // ignore: prefer-async-await
    _boot().whenComplete(() {
      isBusy = false;
    });
  }

  // Login with State and config Management.
  // SHOULD ONLY BE CALLED ON THE LOGIN PAGE.
  Future<void> login(String username, String password) async {
    // ignore: avoid-ignoring-return-values
    error = ""; // Reset error message.
    isBusy = true;
    _authConstants.environment =
        username == "demo" ? Environment.demo : Environment.production;

    await _heimdallLogin(username, password);
    await _firebaseLogin();
    isBusy = false;
  }

  void logout() async {
    unsubscribeAllTopics().whenComplete(() => null);

    await _storage.delete(key: 'oauth2_credentials');
    client = null;
    FirebaseAuth.instance.signOut();
    notifyListeners();
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
    // Required topics to subscribe to.
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic(userId);
      await FirebaseMessaging.instance.subscribeToTopic("all");
    }

    // Store the subscribed topics in a local cache.
    Box cache = await Hive.openBox<bool>('topics');
    await cache.put(userId, true);
    await cache.put('all', true);
  }

  // Tries to login into Heimdall and Firebase.
  Future<void> _heimdallLogin(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      error = 'Both username and password fields are required.';

      return;
    }

    try {
      client = await oauth2.resourceOwnerPasswordGrant(
        _authConstants.oauthEndpoint(),
        username,
        password,
        identifier: _authConstants.oauthId,
        secret: _authConstants.oauthSecret,
      );
    } catch (e) {
      error = e.toString();

      return;
    }
    Credentials? credentials = client?.credentials;
    if (credentials == null) {
      error = 'Credentials are null.';

      return;
    }

    // Write the credentials to the secure storage.
    await _storage.write(
      key: 'oauth2_credentials',
      value: credentials.toJson(),
    );
  }

  // On Startup, try to login with the stored credentials.
  // If the credentials are not expired, try to login to Firebase as well.
  Future<void> _boot() async {
    // Get stored credentials.
    String? storedCreds = await _storage.read(key: 'oauth2_credentials');
    Map<String, dynamic> credentials = jsonDecode(storedCreds ?? '{}');
    // Change the environment based on the token endpoint.
    _authConstants.environment = credentials['tokenEndpoint'] ==
            AuthConstants.oauthEndpointFor(Environment.demo).path
        ? Environment.demo
        : Environment.production;

    // If token doesn't exist or is expired, let user login again.
    if (credentials['expiration'] == null ||
        DateTime.fromMillisecondsSinceEpoch(credentials['expiration'])
            .isBefore(DateTime.now())) {
      return;
    }
    // Credentials not expired, try to login to Firebase.
    client = oauth2.Client(oauth2.Credentials.fromJson(storedCreds ?? ""));
    await _firebaseLogin();
  }

  // Login to Firebase with the stored credentials.
  // NOTE: The function will not do anything if the environment is set to demo.
  Future<void> _firebaseLogin() async {
    if (_authConstants.environment == Environment.demo) {
      // Don't login to Firebase in demo mode.
      return;
    }

    final String? accessToken = client?.credentials.accessToken;
    // Only fire this if an access token is available.
    if (accessToken == null) {
      return;
    }

    try {
      // Get the token for the configured (constant) endpoint JWT.
      final response = await Dio().get(
        _authConstants.jwtEndpoint().toString(),
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      // The token is returned as JSON, decode it.
      final data = json.decode(response.data);

      // If we have data and we have the token in our data, proceed to login.
      if (data != null && data['token'] != null) {
        // ignore: avoid-ignoring-return-values
        await FirebaseAuth.instance.signInWithCustomToken(data['token']);

        String? uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          FirebaseCrashlytics.instance.setUserIdentifier(
            uid,
          ); // Link crashes to users, so we can reach out to them if needed.
          // Subscribe the user to FirebaseMessaging as well.
          subscribeDefaultTopics(uid);
        }
      }
    } catch (e, st) {
      // If it fails, we don't want to die just yet - but do send
      // the exception to Sentry for further research.
      // ignore: avoid-ignoring-return-values
      Sentry.captureException(error, stackTrace: st);
    }
  }
}
