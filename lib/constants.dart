const String baseURL = 'https://heimdall.njord.nl';
const String demoURL = 'https://heimdall-test.ksrv.nl';

class Endpoint {
  static const String oauthId = '11';
  static const String oauthSecret = 'YvbiNaGmgkBBNPbJ5REwtviiPxMb1tCXrdqIhqNQ';
  static final Uri oauthEndpoint = Uri.parse('$baseURL/oauth/token');
  static final Uri jwtEndpoint = Uri.parse('$baseURL/api/v1/auth/firebase');
  static const String user = 'api/v1/user';
  static const String vaarverbod = 'api/v1/vaarverbod';
  static const String graphql = 'graphql';
}
