// @immutable // TODO: create a provider for this to introduce immutability.

class AuthConstants {
  Environment environment = Environment.demo;

  static const prodBaseURL = 'https://heimdall.njord.nl';
  static const demoBaseURL = 'https://heimdall-test.ksrv.nl';

  static const tokenSuffix = 'api/v2/token/';

  get baseURL {
    switch (environment) {
      case Environment.production:
        return prodBaseURL;
      case Environment.demo:
        return demoBaseURL;
      // ignore: unreachable_switch_default
      default:
        throw Exception('Environment not set.');
    }
  }

  String get oauthEndpoint => '$baseURL/$tokenSuffix';

  Uri jwtEndpoint() {
    return Uri.parse('$baseURL/api/v1/auth/firebase');
  }
}

enum Environment {
  demo,
  production,
}
