import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:provider/provider.dart';
// shared preferences
import 'package:shared_preferences/shared_preferences.dart';

// async update shared preferences
Future<void> updateUserMapCacheAsync(
    String heimallId, GraphQLClient client) async {
  Query$AlmanakProfile$user? user = await almanakProfile(heimallId, client);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(heimallId, user!.identifier);
}

// Converts heimdall Id to user identifier
Future<String?> getUserIdentifier(
    GraphQLClient client, String heimallId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? identifier = prefs.getString(heimallId);

  updateUserMapCacheAsync(heimallId, client); // update cache in background

  if (identifier != null) {
    // use cached identifier
    return identifier;
  }

  // identifier not cached, fetch from almanak
  Query$AlmanakProfile$user? user = await almanakProfile(heimallId, client);

  return user!.identifier;
}
