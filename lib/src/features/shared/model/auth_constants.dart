// @immutable // TODO: create a provider for this to introduce immutability.

class AuthConstants {
  Environment environment = Environment.demo;

  static const prodBaseURL = 'https://heimdall.njord.nl';
  static const demoBaseURL = 'https://heimdall-test.ksrv.nl';

  get baseURL {
    switch (environment) {
      case Environment.production:
        return prodBaseURL;
      case Environment.demo:
        return demoBaseURL;
      default:
        throw Exception('Environment not set.');
    }
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
