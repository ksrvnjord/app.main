class GlobalConstants {
  static const String user = 'api/v1/user';
  static const String vaarverbod = 'api/v1/vaarverbod';
  static const String graphql = 'graphql';

  String baseURL = 'https://heimdall.njord.nl';
  String oauthId = '4';
  String oauthSecret = 'J3VLpaahf406OCpMrQzAYKT4kjV03jSAnu3olNPu';

  Uri oauthEndpoint() {
    return Uri.parse('$baseURL/oauth/token');
  }

  Uri jwtEndpoint() {
    return Uri.parse('$baseURL/api/v1/auth/firebase');
  }

  void switchEnvironment(String username) {
    if (username == 'demo') {
      baseURL = 'https://heimdall-test.ksrv.nl';
      oauthId = '2';
      oauthSecret = 'W2rE2hmgGYneR3TRp94JbSBvDcIDTf3KuaLZY39v';
      
      return;
    }

    baseURL = 'https://heimdall.njord.nl';
    oauthId = '4';
    oauthSecret = 'J3VLpaahf406OCpMrQzAYKT4kjV03jSAnu3olNPu';
  }
}
