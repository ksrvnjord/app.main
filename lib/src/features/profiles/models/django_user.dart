// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as gql;
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

part 'django_user.g.dart';

/// Model representing user data from ONLY Django.
@JsonSerializable()
class DjangoUser {
  // ignore: prefer-correct-identifier-length
  final int id;
  final int lichting;

  // @JsonKey(name: "reserve_permissions")
  // final List<Map<String, String> reservePermissions;

  // TODO: Add groups field.

  @JsonKey(name: "is_superuser")
  final bool isSuperuser;

  final String username;

  @JsonKey(name: "first_name")
  final String firstName;

  @JsonKey(name: "last_name")
  final String lastName;

  final String email;

  @JsonKey(name: "is_staff")
  final bool isStaff;

  final String zipcode;

  final String housenumber;

  @JsonKey(name: "housenumber_addition")
  final String housenumberAddition;

  final String street;

  final String city;

  final String country;

  @JsonKey(name: "phone_primary")
  final String phonePrimary;

  final int identifier;
  DjangoUser({
    required this.id,
    required this.lichting,
    required this.isSuperuser,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isStaff,
    required this.zipcode,
    required this.housenumber,
    required this.housenumberAddition,
    required this.street,
    required this.city,
    required this.country,
    required this.phonePrimary,
    required this.identifier,
  });

  factory DjangoUser.fromHeimdallDemoEnv(
    Query$AlmanakProfile$user? user,
  ) {
    final publicContact = user?.fullContact.public;

    var userId = int.parse(user?.identifier ?? "42069");

    return DjangoUser(
      id: userId,
      // ignore: no-magic-number
      lichting: 2020,
      isSuperuser: false,
      username: user?.username ?? "example",
      firstName: publicContact?.first_name ?? "Onbekend",
      lastName: publicContact?.last_name ?? "Onbekend",
      email: user?.email ?? "example@example.org",
      isStaff: false,
      zipcode: publicContact?.zipcode ?? "1234AB",
      housenumber: publicContact?.housenumber ?? "69",
      housenumberAddition: publicContact?.housenumber_addition ?? "A",
      street: publicContact?.street ?? "Onbekend",
      city: publicContact?.city ?? "Onbekend",
      country: "NL",
      phonePrimary: publicContact?.phone_primary ?? "0612345678",
      // ignore: no-equal-arguments
      identifier: userId,
    );
  }

  factory DjangoUser.fromJson(Map<String, dynamic> json) =>
      _$DjangoUserFromJson(json);

  Map<String, dynamic> toJson() => _$DjangoUserToJson(this);

  static Future<DjangoUser> getByIdentifier(
    String identifier,
    StreamProviderRef<User> ref,
  ) async {
    final dio = ref.watch(dioProvider);

    final res = await dio.get("/api/users/users/", queryParameters: {
      "search": identifier,
    });
    final data = jsonDecode(res.toString()) as Map<String, dynamic>;
    final results = data["results"] as List;
    final user = results.first as Map<String, dynamic>;

    return DjangoUser.fromJson(user);
  }

  static Future<DjangoUser> getById(
    String id,
    AutoDisposeStreamProviderRef<DjangoUser> ref,
  ) async {
    final dio = ref.watch(dioProvider);

    final res = await dio.get("/api/users/user/$id");
    final data = jsonDecode(res.toString()) as Map<String, dynamic>;
    final results = data["results"] as List;
    final user = results.first as Map<String, dynamic>;

    return DjangoUser.fromJson(user);
  }

  static Future<Query$AlmanakProfile$user?> getByIdGraphQL(
    String id,
    StreamProviderRef<User> ref,
  ) async {
    final client = ref.watch(graphQLClientProvider);

    final result = await client.query$AlmanakProfile(
      Options$Query$AlmanakProfile(
        variables: Variables$Query$AlmanakProfile(profileId: id),
        fetchPolicy: gql.FetchPolicy.cacheFirst,
      ),
    );

    return result.parsedData?.user;
  }
}
