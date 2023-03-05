// ignore_for_file: type=lint
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables$Query$AlmanakProfile {
  factory Variables$Query$AlmanakProfile({required String profileId}) =>
      Variables$Query$AlmanakProfile._({
        r'profileId': profileId,
      });

  Variables$Query$AlmanakProfile._(this._$data);

  factory Variables$Query$AlmanakProfile.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$profileId = data['profileId'];
    result$data['profileId'] = (l$profileId as String);
    return Variables$Query$AlmanakProfile._(result$data);
  }

  Map<String, dynamic> _$data;

  String get profileId => (_$data['profileId'] as String);
  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$profileId = profileId;
    result$data['profileId'] = l$profileId;
    return result$data;
  }

  CopyWith$Variables$Query$AlmanakProfile<Variables$Query$AlmanakProfile>
      get copyWith => CopyWith$Variables$Query$AlmanakProfile(
            this,
            (i) => i,
          );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Variables$Query$AlmanakProfile) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$profileId = profileId;
    final lOther$profileId = other.profileId;
    if (l$profileId != lOther$profileId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$profileId = profileId;
    return Object.hashAll([l$profileId]);
  }
}

abstract class CopyWith$Variables$Query$AlmanakProfile<TRes> {
  factory CopyWith$Variables$Query$AlmanakProfile(
    Variables$Query$AlmanakProfile instance,
    TRes Function(Variables$Query$AlmanakProfile) then,
  ) = _CopyWithImpl$Variables$Query$AlmanakProfile;

  factory CopyWith$Variables$Query$AlmanakProfile.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$AlmanakProfile;

  TRes call({String? profileId});
}

class _CopyWithImpl$Variables$Query$AlmanakProfile<TRes>
    implements CopyWith$Variables$Query$AlmanakProfile<TRes> {
  _CopyWithImpl$Variables$Query$AlmanakProfile(
    this._instance,
    this._then,
  );

  final Variables$Query$AlmanakProfile _instance;

  final TRes Function(Variables$Query$AlmanakProfile) _then;

  static const _undefined = {};

  TRes call({Object? profileId = _undefined}) =>
      _then(Variables$Query$AlmanakProfile._({
        ..._instance._$data,
        if (profileId != _undefined && profileId != null)
          'profileId': (profileId as String),
      }));
}

class _CopyWithStubImpl$Variables$Query$AlmanakProfile<TRes>
    implements CopyWith$Variables$Query$AlmanakProfile<TRes> {
  _CopyWithStubImpl$Variables$Query$AlmanakProfile(this._res);

  TRes _res;

  call({String? profileId}) => _res;
}

class Query$AlmanakProfile {
  Query$AlmanakProfile({
    required this.userByIdentifier,
    required this.$__typename,
  });

  factory Query$AlmanakProfile.fromJson(Map<String, dynamic> json) {
    final l$userByIdentifier = json['userByIdentifier'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakProfile(
      userByIdentifier: Query$AlmanakProfile$userByIdentifier.fromJson(
          (l$userByIdentifier as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$AlmanakProfile$userByIdentifier userByIdentifier;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$userByIdentifier = userByIdentifier;
    _resultData['userByIdentifier'] = l$userByIdentifier.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$userByIdentifier = userByIdentifier;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$userByIdentifier,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$AlmanakProfile) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$userByIdentifier = userByIdentifier;
    final lOther$userByIdentifier = other.userByIdentifier;
    if (l$userByIdentifier != lOther$userByIdentifier) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$AlmanakProfile on Query$AlmanakProfile {
  CopyWith$Query$AlmanakProfile<Query$AlmanakProfile> get copyWith =>
      CopyWith$Query$AlmanakProfile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$AlmanakProfile<TRes> {
  factory CopyWith$Query$AlmanakProfile(
    Query$AlmanakProfile instance,
    TRes Function(Query$AlmanakProfile) then,
  ) = _CopyWithImpl$Query$AlmanakProfile;

  factory CopyWith$Query$AlmanakProfile.stub(TRes res) =
      _CopyWithStubImpl$Query$AlmanakProfile;

  TRes call({
    Query$AlmanakProfile$userByIdentifier? userByIdentifier,
    String? $__typename,
  });
  CopyWith$Query$AlmanakProfile$userByIdentifier<TRes> get userByIdentifier;
}

class _CopyWithImpl$Query$AlmanakProfile<TRes>
    implements CopyWith$Query$AlmanakProfile<TRes> {
  _CopyWithImpl$Query$AlmanakProfile(
    this._instance,
    this._then,
  );

  final Query$AlmanakProfile _instance;

  final TRes Function(Query$AlmanakProfile) _then;

  static const _undefined = {};

  TRes call({
    Object? userByIdentifier = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$AlmanakProfile(
        userByIdentifier:
            userByIdentifier == _undefined || userByIdentifier == null
                ? _instance.userByIdentifier
                : (userByIdentifier as Query$AlmanakProfile$userByIdentifier),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
  CopyWith$Query$AlmanakProfile$userByIdentifier<TRes> get userByIdentifier {
    final local$userByIdentifier = _instance.userByIdentifier;
    return CopyWith$Query$AlmanakProfile$userByIdentifier(
        local$userByIdentifier, (e) => call(userByIdentifier: e));
  }
}

class _CopyWithStubImpl$Query$AlmanakProfile<TRes>
    implements CopyWith$Query$AlmanakProfile<TRes> {
  _CopyWithStubImpl$Query$AlmanakProfile(this._res);

  TRes _res;

  call({
    Query$AlmanakProfile$userByIdentifier? userByIdentifier,
    String? $__typename,
  }) =>
      _res;
  CopyWith$Query$AlmanakProfile$userByIdentifier<TRes> get userByIdentifier =>
      CopyWith$Query$AlmanakProfile$userByIdentifier.stub(_res);
}

const documentNodeQueryAlmanakProfile = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'AlmanakProfile'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'profileId')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'userByIdentifier'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'identifier'),
            value: VariableNode(name: NameNode(value: 'profileId')),
          )
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'identifier'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'email'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'username'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'fullContact'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'public'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: SelectionSetNode(selections: [
                  FieldNode(
                    name: NameNode(value: 'first_name'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'last_name'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'email'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'street'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'housenumber'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'housenumber_addition'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'city'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'zipcode'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'phone_primary'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ]),
              ),
              FieldNode(
                name: NameNode(value: '__typename'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
            ]),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ]),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
]);
Query$AlmanakProfile _parserFn$Query$AlmanakProfile(
        Map<String, dynamic> data) =>
    Query$AlmanakProfile.fromJson(data);

class Options$Query$AlmanakProfile
    extends graphql.QueryOptions<Query$AlmanakProfile> {
  Options$Query$AlmanakProfile({
    String? operationName,
    required Variables$Query$AlmanakProfile variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
  }) : super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult,
          pollInterval: pollInterval,
          context: context,
          document: documentNodeQueryAlmanakProfile,
          parserFn: _parserFn$Query$AlmanakProfile,
        );
}

class WatchOptions$Query$AlmanakProfile
    extends graphql.WatchQueryOptions<Query$AlmanakProfile> {
  WatchOptions$Query$AlmanakProfile({
    String? operationName,
    required Variables$Query$AlmanakProfile variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult,
          context: context,
          document: documentNodeQueryAlmanakProfile,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$AlmanakProfile,
        );
}

class FetchMoreOptions$Query$AlmanakProfile extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$AlmanakProfile({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$AlmanakProfile variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryAlmanakProfile,
        );
}

extension ClientExtension$Query$AlmanakProfile on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$AlmanakProfile>> query$AlmanakProfile(
          Options$Query$AlmanakProfile options) async =>
      await this.query(options);
  graphql.ObservableQuery<Query$AlmanakProfile> watchQuery$AlmanakProfile(
          WatchOptions$Query$AlmanakProfile options) =>
      this.watchQuery(options);
  void writeQuery$AlmanakProfile({
    required Query$AlmanakProfile data,
    required Variables$Query$AlmanakProfile variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation:
              graphql.Operation(document: documentNodeQueryAlmanakProfile),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$AlmanakProfile? readQuery$AlmanakProfile({
    required Variables$Query$AlmanakProfile variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryAlmanakProfile),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$AlmanakProfile.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$AlmanakProfile> useQuery$AlmanakProfile(
        Options$Query$AlmanakProfile options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$AlmanakProfile> useWatchQuery$AlmanakProfile(
        WatchOptions$Query$AlmanakProfile options) =>
    graphql_flutter.useWatchQuery(options);

class Query$AlmanakProfile$Widget
    extends graphql_flutter.Query<Query$AlmanakProfile> {
  Query$AlmanakProfile$Widget({
    widgets.Key? key,
    required Options$Query$AlmanakProfile options,
    required graphql_flutter.QueryBuilder<Query$AlmanakProfile> builder,
  }) : super(
          key: key,
          options: options,
          builder: builder,
        );
}

class Query$AlmanakProfile$userByIdentifier {
  Query$AlmanakProfile$userByIdentifier({
    required this.identifier,
    required this.email,
    required this.username,
    required this.fullContact,
    required this.$__typename,
  });

  factory Query$AlmanakProfile$userByIdentifier.fromJson(
      Map<String, dynamic> json) {
    final l$identifier = json['identifier'];
    final l$email = json['email'];
    final l$username = json['username'];
    final l$fullContact = json['fullContact'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakProfile$userByIdentifier(
      identifier: (l$identifier as String),
      email: (l$email as String),
      username: (l$username as String),
      fullContact: Query$AlmanakProfile$userByIdentifier$fullContact.fromJson(
          (l$fullContact as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String identifier;

  final String email;

  final String username;

  final Query$AlmanakProfile$userByIdentifier$fullContact fullContact;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$identifier = identifier;
    _resultData['identifier'] = l$identifier;
    final l$email = email;
    _resultData['email'] = l$email;
    final l$username = username;
    _resultData['username'] = l$username;
    final l$fullContact = fullContact;
    _resultData['fullContact'] = l$fullContact.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$identifier = identifier;
    final l$email = email;
    final l$username = username;
    final l$fullContact = fullContact;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$identifier,
      l$email,
      l$username,
      l$fullContact,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$AlmanakProfile$userByIdentifier) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$identifier = identifier;
    final lOther$identifier = other.identifier;
    if (l$identifier != lOther$identifier) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
      return false;
    }
    final l$username = username;
    final lOther$username = other.username;
    if (l$username != lOther$username) {
      return false;
    }
    final l$fullContact = fullContact;
    final lOther$fullContact = other.fullContact;
    if (l$fullContact != lOther$fullContact) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$AlmanakProfile$userByIdentifier
    on Query$AlmanakProfile$userByIdentifier {
  CopyWith$Query$AlmanakProfile$userByIdentifier<
          Query$AlmanakProfile$userByIdentifier>
      get copyWith => CopyWith$Query$AlmanakProfile$userByIdentifier(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$AlmanakProfile$userByIdentifier<TRes> {
  factory CopyWith$Query$AlmanakProfile$userByIdentifier(
    Query$AlmanakProfile$userByIdentifier instance,
    TRes Function(Query$AlmanakProfile$userByIdentifier) then,
  ) = _CopyWithImpl$Query$AlmanakProfile$userByIdentifier;

  factory CopyWith$Query$AlmanakProfile$userByIdentifier.stub(TRes res) =
      _CopyWithStubImpl$Query$AlmanakProfile$userByIdentifier;

  TRes call({
    String? identifier,
    String? email,
    String? username,
    Query$AlmanakProfile$userByIdentifier$fullContact? fullContact,
    String? $__typename,
  });
  CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact<TRes>
      get fullContact;
}

class _CopyWithImpl$Query$AlmanakProfile$userByIdentifier<TRes>
    implements CopyWith$Query$AlmanakProfile$userByIdentifier<TRes> {
  _CopyWithImpl$Query$AlmanakProfile$userByIdentifier(
    this._instance,
    this._then,
  );

  final Query$AlmanakProfile$userByIdentifier _instance;

  final TRes Function(Query$AlmanakProfile$userByIdentifier) _then;

  static const _undefined = {};

  TRes call({
    Object? identifier = _undefined,
    Object? email = _undefined,
    Object? username = _undefined,
    Object? fullContact = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$AlmanakProfile$userByIdentifier(
        identifier: identifier == _undefined || identifier == null
            ? _instance.identifier
            : (identifier as String),
        email: email == _undefined || email == null
            ? _instance.email
            : (email as String),
        username: username == _undefined || username == null
            ? _instance.username
            : (username as String),
        fullContact: fullContact == _undefined || fullContact == null
            ? _instance.fullContact
            : (fullContact
                as Query$AlmanakProfile$userByIdentifier$fullContact),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
  CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact<TRes>
      get fullContact {
    final local$fullContact = _instance.fullContact;
    return CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact(
        local$fullContact, (e) => call(fullContact: e));
  }
}

class _CopyWithStubImpl$Query$AlmanakProfile$userByIdentifier<TRes>
    implements CopyWith$Query$AlmanakProfile$userByIdentifier<TRes> {
  _CopyWithStubImpl$Query$AlmanakProfile$userByIdentifier(this._res);

  TRes _res;

  call({
    String? identifier,
    String? email,
    String? username,
    Query$AlmanakProfile$userByIdentifier$fullContact? fullContact,
    String? $__typename,
  }) =>
      _res;
  CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact<TRes>
      get fullContact =>
          CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact.stub(_res);
}

class Query$AlmanakProfile$userByIdentifier$fullContact {
  Query$AlmanakProfile$userByIdentifier$fullContact({
    required this.public,
    required this.$__typename,
  });

  factory Query$AlmanakProfile$userByIdentifier$fullContact.fromJson(
      Map<String, dynamic> json) {
    final l$public = json['public'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakProfile$userByIdentifier$fullContact(
      public: Query$AlmanakProfile$userByIdentifier$fullContact$public.fromJson(
          (l$public as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$AlmanakProfile$userByIdentifier$fullContact$public public;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$public = public;
    _resultData['public'] = l$public.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$public = public;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$public,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$AlmanakProfile$userByIdentifier$fullContact) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$public = public;
    final lOther$public = other.public;
    if (l$public != lOther$public) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$AlmanakProfile$userByIdentifier$fullContact
    on Query$AlmanakProfile$userByIdentifier$fullContact {
  CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact<
          Query$AlmanakProfile$userByIdentifier$fullContact>
      get copyWith =>
          CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact<
    TRes> {
  factory CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact(
    Query$AlmanakProfile$userByIdentifier$fullContact instance,
    TRes Function(Query$AlmanakProfile$userByIdentifier$fullContact) then,
  ) = _CopyWithImpl$Query$AlmanakProfile$userByIdentifier$fullContact;

  factory CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact.stub(
          TRes res) =
      _CopyWithStubImpl$Query$AlmanakProfile$userByIdentifier$fullContact;

  TRes call({
    Query$AlmanakProfile$userByIdentifier$fullContact$public? public,
    String? $__typename,
  });
  CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public<TRes>
      get public;
}

class _CopyWithImpl$Query$AlmanakProfile$userByIdentifier$fullContact<TRes>
    implements
        CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact<TRes> {
  _CopyWithImpl$Query$AlmanakProfile$userByIdentifier$fullContact(
    this._instance,
    this._then,
  );

  final Query$AlmanakProfile$userByIdentifier$fullContact _instance;

  final TRes Function(Query$AlmanakProfile$userByIdentifier$fullContact) _then;

  static const _undefined = {};

  TRes call({
    Object? public = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$AlmanakProfile$userByIdentifier$fullContact(
        public: public == _undefined || public == null
            ? _instance.public
            : (public
                as Query$AlmanakProfile$userByIdentifier$fullContact$public),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
  CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public<TRes>
      get public {
    final local$public = _instance.public;
    return CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public(
        local$public, (e) => call(public: e));
  }
}

class _CopyWithStubImpl$Query$AlmanakProfile$userByIdentifier$fullContact<TRes>
    implements
        CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact<TRes> {
  _CopyWithStubImpl$Query$AlmanakProfile$userByIdentifier$fullContact(
      this._res);

  TRes _res;

  call({
    Query$AlmanakProfile$userByIdentifier$fullContact$public? public,
    String? $__typename,
  }) =>
      _res;
  CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public<TRes>
      get public =>
          CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public
              .stub(_res);
}

class Query$AlmanakProfile$userByIdentifier$fullContact$public {
  Query$AlmanakProfile$userByIdentifier$fullContact$public({
    this.first_name,
    this.last_name,
    this.email,
    this.street,
    this.housenumber,
    this.housenumber_addition,
    this.city,
    this.zipcode,
    this.phone_primary,
    required this.$__typename,
  });

  factory Query$AlmanakProfile$userByIdentifier$fullContact$public.fromJson(
      Map<String, dynamic> json) {
    final l$first_name = json['first_name'];
    final l$last_name = json['last_name'];
    final l$email = json['email'];
    final l$street = json['street'];
    final l$housenumber = json['housenumber'];
    final l$housenumber_addition = json['housenumber_addition'];
    final l$city = json['city'];
    final l$zipcode = json['zipcode'];
    final l$phone_primary = json['phone_primary'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakProfile$userByIdentifier$fullContact$public(
      first_name: (l$first_name as String?),
      last_name: (l$last_name as String?),
      email: (l$email as String?),
      street: (l$street as String?),
      housenumber: (l$housenumber as String?),
      housenumber_addition: (l$housenumber_addition as String?),
      city: (l$city as String?),
      zipcode: (l$zipcode as String?),
      phone_primary: (l$phone_primary as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? first_name;

  final String? last_name;

  final String? email;

  final String? street;

  final String? housenumber;

  final String? housenumber_addition;

  final String? city;

  final String? zipcode;

  final String? phone_primary;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$first_name = first_name;
    _resultData['first_name'] = l$first_name;
    final l$last_name = last_name;
    _resultData['last_name'] = l$last_name;
    final l$email = email;
    _resultData['email'] = l$email;
    final l$street = street;
    _resultData['street'] = l$street;
    final l$housenumber = housenumber;
    _resultData['housenumber'] = l$housenumber;
    final l$housenumber_addition = housenumber_addition;
    _resultData['housenumber_addition'] = l$housenumber_addition;
    final l$city = city;
    _resultData['city'] = l$city;
    final l$zipcode = zipcode;
    _resultData['zipcode'] = l$zipcode;
    final l$phone_primary = phone_primary;
    _resultData['phone_primary'] = l$phone_primary;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$first_name = first_name;
    final l$last_name = last_name;
    final l$email = email;
    final l$street = street;
    final l$housenumber = housenumber;
    final l$housenumber_addition = housenumber_addition;
    final l$city = city;
    final l$zipcode = zipcode;
    final l$phone_primary = phone_primary;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$first_name,
      l$last_name,
      l$email,
      l$street,
      l$housenumber,
      l$housenumber_addition,
      l$city,
      l$zipcode,
      l$phone_primary,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$AlmanakProfile$userByIdentifier$fullContact$public) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$first_name = first_name;
    final lOther$first_name = other.first_name;
    if (l$first_name != lOther$first_name) {
      return false;
    }
    final l$last_name = last_name;
    final lOther$last_name = other.last_name;
    if (l$last_name != lOther$last_name) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
      return false;
    }
    final l$street = street;
    final lOther$street = other.street;
    if (l$street != lOther$street) {
      return false;
    }
    final l$housenumber = housenumber;
    final lOther$housenumber = other.housenumber;
    if (l$housenumber != lOther$housenumber) {
      return false;
    }
    final l$housenumber_addition = housenumber_addition;
    final lOther$housenumber_addition = other.housenumber_addition;
    if (l$housenumber_addition != lOther$housenumber_addition) {
      return false;
    }
    final l$city = city;
    final lOther$city = other.city;
    if (l$city != lOther$city) {
      return false;
    }
    final l$zipcode = zipcode;
    final lOther$zipcode = other.zipcode;
    if (l$zipcode != lOther$zipcode) {
      return false;
    }
    final l$phone_primary = phone_primary;
    final lOther$phone_primary = other.phone_primary;
    if (l$phone_primary != lOther$phone_primary) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$AlmanakProfile$userByIdentifier$fullContact$public
    on Query$AlmanakProfile$userByIdentifier$fullContact$public {
  CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public<
          Query$AlmanakProfile$userByIdentifier$fullContact$public>
      get copyWith =>
          CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public<
    TRes> {
  factory CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public(
    Query$AlmanakProfile$userByIdentifier$fullContact$public instance,
    TRes Function(Query$AlmanakProfile$userByIdentifier$fullContact$public)
        then,
  ) = _CopyWithImpl$Query$AlmanakProfile$userByIdentifier$fullContact$public;

  factory CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public.stub(
          TRes res) =
      _CopyWithStubImpl$Query$AlmanakProfile$userByIdentifier$fullContact$public;

  TRes call({
    String? first_name,
    String? last_name,
    String? email,
    String? street,
    String? housenumber,
    String? housenumber_addition,
    String? city,
    String? zipcode,
    String? phone_primary,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$AlmanakProfile$userByIdentifier$fullContact$public<
        TRes>
    implements
        CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public<
            TRes> {
  _CopyWithImpl$Query$AlmanakProfile$userByIdentifier$fullContact$public(
    this._instance,
    this._then,
  );

  final Query$AlmanakProfile$userByIdentifier$fullContact$public _instance;

  final TRes Function(Query$AlmanakProfile$userByIdentifier$fullContact$public)
      _then;

  static const _undefined = {};

  TRes call({
    Object? first_name = _undefined,
    Object? last_name = _undefined,
    Object? email = _undefined,
    Object? street = _undefined,
    Object? housenumber = _undefined,
    Object? housenumber_addition = _undefined,
    Object? city = _undefined,
    Object? zipcode = _undefined,
    Object? phone_primary = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$AlmanakProfile$userByIdentifier$fullContact$public(
        first_name: first_name == _undefined
            ? _instance.first_name
            : (first_name as String?),
        last_name: last_name == _undefined
            ? _instance.last_name
            : (last_name as String?),
        email: email == _undefined ? _instance.email : (email as String?),
        street: street == _undefined ? _instance.street : (street as String?),
        housenumber: housenumber == _undefined
            ? _instance.housenumber
            : (housenumber as String?),
        housenumber_addition: housenumber_addition == _undefined
            ? _instance.housenumber_addition
            : (housenumber_addition as String?),
        city: city == _undefined ? _instance.city : (city as String?),
        zipcode:
            zipcode == _undefined ? _instance.zipcode : (zipcode as String?),
        phone_primary: phone_primary == _undefined
            ? _instance.phone_primary
            : (phone_primary as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$AlmanakProfile$userByIdentifier$fullContact$public<
        TRes>
    implements
        CopyWith$Query$AlmanakProfile$userByIdentifier$fullContact$public<
            TRes> {
  _CopyWithStubImpl$Query$AlmanakProfile$userByIdentifier$fullContact$public(
      this._res);

  TRes _res;

  call({
    String? first_name,
    String? last_name,
    String? email,
    String? street,
    String? housenumber,
    String? housenumber_addition,
    String? city,
    String? zipcode,
    String? phone_primary,
    String? $__typename,
  }) =>
      _res;
}
