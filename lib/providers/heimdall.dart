/// This file contains the necessary objects and methods to
/// request data from the Heimdall API
///
/// This includes [HeimdallRepository], which exposes methods
/// to log-in to Heimdall and to get the token to perform actions in
/// a type-safe way.

import 'package:dio/dio.dart' as dio;
import 'package:graphql/client.dart' as graphql;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/authentication.dart';
import 'package:ksrvnjord_main_app/providers/dio.dart';
import 'package:ksrvnjord_main_app/constant.dart' as constant
    show baseURL, demoURL, Endpoint;

final heimdallProvider = Provider((ref) => HeimdallService(ref.read));

class HeimdallService {
  HeimdallService(this._read)
      : _authLink = graphql.AuthLink(
          getToken: () async =>
              'Bearer ' + _read(authenticationProvider).bearer,
        );

  final Reader _read;
  String baseURL = constant.baseURL;
  final graphql.AuthLink _authLink;

  void updateBaseURL(String _baseURL) {
    baseURL = _baseURL;
  }

  Future<dio.Response<Map<String, Object?>>> get(
      String path, Map<String, dynamic>? params) {
    String bearer = _read(authenticationProvider).bearer;
    return _read(dioProvider).get<Map<String, Object?>>('$baseURL$path',
        queryParameters: params,
        options: dio.Options(headers: {
          'Authorization': 'Bearer $bearer',
          'Accept': 'application/json'
        }));
  }

  Future<dio.Response<Map<String, Object?>>> post(String path, dynamic data) {
    String bearer = _read(authenticationProvider).bearer;
    return _read(dioProvider).post<Map<String, Object?>>('$baseURL$path',
        data: data,
        options: dio.Options(headers: {
          'Authorization': 'Bearer $bearer',
          'Accept': 'application/json'
        }));
  }

  Future<dio.Response<Map<String, Object?>>> put(String path, dynamic data) {
    String bearer = _read(authenticationProvider).bearer;
    return _read(dioProvider).post<Map<String, Object?>>('$baseURL$path',
        data: data,
        options: dio.Options(headers: {
          'Authorization': 'Bearer $bearer',
          'Accept': 'application/json'
        }));
  }

  graphql.GraphQLClient graphQLClient() {
    return graphql.GraphQLClient(
        cache: graphql.GraphQLCache(),
        link: _authLink
            .concat(graphql.HttpLink(baseURL + constant.Endpoint.graphql)));
  }
}
