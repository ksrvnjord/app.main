// @immutable // TODO: create a provider for this to introduce immutability.

import 'package:get_it/get_it.dart';

class AuthConstants {
  Environment environment = Environment.demo;

  static const prodBaseURL = 'https://heimdall.njord.nl';
  static const demoBaseURL = 'https://heimdall-test.ksrv.nl';

  get baseURL {
    switch (GetIt.I.get<AuthConstants>().environment) {
      case Environment.production:
        return prodBaseURL;
      case Environment.demo:
        return demoBaseURL;
      default:
        throw Exception('Environment not set.');
    }
  }

  get oauthId {
    switch (GetIt.I.get<AuthConstants>().environment) {
      case Environment.production:
        return '4';
      case Environment.demo:
        return '2';
      default:
        throw Exception('Environment not set.');
    }
  }

  get oauthSecret {
    switch (GetIt.I.get<AuthConstants>().environment) {
      case Environment.production:
        return 'J3VLpaahf406OCpMrQzAYKT4kjV03jSAnu3olNPu';
      case Environment.demo:
        return 'W2rE2hmgGYneR3TRp94JbSBvDcIDTf3KuaLZY39v';
      default:
        throw Exception('Environment not set.');
    }
  }

  Uri oauthEndpoint() {
    return Uri.parse('$baseURL/oauth/token');
  }

  Uri jwtEndpoint() {
    return Uri.parse('$baseURL/api/v1/auth/firebase');
  }

  static Uri oauthEndpointFor(Environment environment) {
    switch (environment) {
      case Environment.production:
        return Uri.parse('$prodBaseURL/oauth/token');
      case Environment.demo:
        return Uri.parse('$demoBaseURL/oauth/token');
      default:
        throw Exception('Environment not set.');
    }
  }
}

enum Environment {
  demo,
  production,
}
