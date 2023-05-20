import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/global_constants.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:oauth2/oauth2.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

const _storage = FlutterSecureStorage();

final authModelProvider = ChangeNotifierProvider((ref) => AuthModel());

class AuthModel extends ChangeNotifier {
  oauth2.Client? client;
  bool isBusy = false;
  String error = '';
  String storedUser = '';
  GlobalConstants globalConstants = GetIt.I.get<GlobalConstants>();

  AuthModel() {
    isBusy = true;
    boot().then((value) {
      client = value;
    }).whenComplete(() {
      isBusy = false;
      notifyListeners();
    });
  }

  Future<void> unsubscribeAllTopics() async {
    final box = await Hive.openBox<bool>('topics');
    for (String key in box.keys) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(key);
    }
    // ignore: avoid-ignoring-return-values
    await box.clear();
  }

  Future<void> subscribeDefaultTopics(String userId) async {
    // Required topics to subscribe to
    await FirebaseMessaging.instance.subscribeToTopic(userId);
    await FirebaseMessaging.instance.subscribeToTopic("all");

    // Store the subscribed topics in a local cache
    Box cache = await Hive.openBox<bool>('topics');
    await cache.put(userId, true);
    await cache.put('all', true);
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
    globalConstants.switchEnvironment(username);
    notifyListeners();

    error = '';

    try {
      client = await oauth2.resourceOwnerPasswordGrant(
        globalConstants.oauthEndpoint(),
        username,
        password,
        identifier: globalConstants.oauthId,
        secret: globalConstants.oauthSecret,
      );
    } catch (e) {
      error = e.toString();
      isBusy = false;
      notifyListeners();

      return false;
    }
    Credentials? credentials = client?.credentials;
    if (credentials != null) {
      isBusy = false;
      await _storage.write(
        key: 'oauth2_credentials',
        value: credentials.toJson(),
      );
      notifyListeners();

      return true;
    }

    isBusy = false;
    notifyListeners();

    return false;
  }

  Future<oauth2.Client?> boot() async {
    String? storedCreds = await _storage.read(key: 'oauth2_credentials');
    Map<String, dynamic> credentials = jsonDecode(storedCreds ?? '{}');

    if (credentials['tokenEndpoint'] ==
        'https://heimdall-test.ksrv.nl/oauth/token') {
      globalConstants.switchEnvironment('demo');
    } else {
      globalConstants.switchEnvironment('production.account');
    }

    if (credentials['expiration'] != null) {
      DateTime expiration =
          DateTime.fromMillisecondsSinceEpoch(credentials['expiration']);
      if (expiration.isAfter(DateTime.now())) {
        return oauth2.Client(oauth2.Credentials.fromJson(storedCreds!));
      }
    }

    return null;
  }

  Future<bool> firebase() async {
    final String? accessToken = client?.credentials.accessToken;
    // Only fire this if an access token is available
    if (accessToken == null) {
      return false;
    }

    try {
      // Get the token for the configured (constant) endpoint JWT
      var response = await Dio().get(
        globalConstants.jwtEndpoint().toString(),
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      // The token is returned as JSON, decode it
      var data = json.decode(response.data);

      // If we have data && we have the token in our data, proceed
      // to login
      if (data != null && data['token'] != null) {
        // ignore: avoid-ignoring-return-values
        await FirebaseAuth.instance.signInWithCustomToken(data['token']);
        notifyListeners();

        // Subscribe the user to FirebaseMessaging as well
        String? uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          subscribeDefaultTopics(uid);
        }
      }
    } catch (e, st) {
      // If it fails, we don't want to die just yet - but do send
      // the exception to Sentry for further research.
      // ignore: avoid-ignoring-return-values
      Sentry.captureException(error, stackTrace: st);
    }

    return true;
  }

  void logout() {
    unsubscribeAllTopics().whenComplete(() => null);

    _storage.delete(key: 'oauth2_credentials').then((value) {
      client = null;
      notifyListeners();
    });

    FirebaseAuth.instance.signOut();
  }
}
