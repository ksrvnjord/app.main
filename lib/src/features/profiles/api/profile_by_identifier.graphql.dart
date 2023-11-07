// ignore_for_file: type=lint
import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables$Query$AlmanakProfileByIdentifier {
  factory Variables$Query$AlmanakProfileByIdentifier(
          {required String profileId}) =>
      Variables$Query$AlmanakProfileByIdentifier._({
        r'profileId': profileId,
      });

  Variables$Query$AlmanakProfileByIdentifier._(this._$data);

  factory Variables$Query$AlmanakProfileByIdentifier.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$profileId = data['profileId'];
    result$data['profileId'] = (l$profileId as String);
    return Variables$Query$AlmanakProfileByIdentifier._(result$data);
  }

  Map<String, dynamic> _$data;

  String get profileId => (_$data['profileId'] as String);
  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$profileId = profileId;
    result$data['profileId'] = l$profileId;
    return result$data;
  }

  CopyWith$Variables$Query$AlmanakProfileByIdentifier<
          Variables$Query$AlmanakProfileByIdentifier>
      get copyWith => CopyWith$Variables$Query$AlmanakProfileByIdentifier(
            this,
            (i) => i,
          );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Variables$Query$AlmanakProfileByIdentifier) ||
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

abstract class CopyWith$Variables$Query$AlmanakProfileByIdentifier<TRes> {
  factory CopyWith$Variables$Query$AlmanakProfileByIdentifier(
    Variables$Query$AlmanakProfileByIdentifier instance,
    TRes Function(Variables$Query$AlmanakProfileByIdentifier) then,
  ) = _CopyWithImpl$Variables$Query$AlmanakProfileByIdentifier;

  factory CopyWith$Variables$Query$AlmanakProfileByIdentifier.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$AlmanakProfileByIdentifier;

  TRes call({String? profileId});
}

class _CopyWithImpl$Variables$Query$AlmanakProfileByIdentifier<TRes>
    implements CopyWith$Variables$Query$AlmanakProfileByIdentifier<TRes> {
  _CopyWithImpl$Variables$Query$AlmanakProfileByIdentifier(
    this._instance,
    this._then,
  );

  final Variables$Query$AlmanakProfileByIdentifier _instance;

  final TRes Function(Variables$Query$AlmanakProfileByIdentifier) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? profileId = _undefined}) =>
      _then(Variables$Query$AlmanakProfileByIdentifier._({
        ..._instance._$data,
        if (profileId != _undefined && profileId != null)
          'profileId': (profileId as String),
      }));
}

class _CopyWithStubImpl$Variables$Query$AlmanakProfileByIdentifier<TRes>
    implements CopyWith$Variables$Query$AlmanakProfileByIdentifier<TRes> {
  _CopyWithStubImpl$Variables$Query$AlmanakProfileByIdentifier(this._res);

  TRes _res;

  call({String? profileId}) => _res;
}

class Query$AlmanakProfileByIdentifier {
  Query$AlmanakProfileByIdentifier({
    required this.userByIdentifier,
    this.$__typename = 'Query',
  });

  factory Query$AlmanakProfileByIdentifier.fromJson(Map<String, dynamic> json) {
    final l$userByIdentifier = json['userByIdentifier'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakProfileByIdentifier(
      userByIdentifier:
          Query$AlmanakProfileByIdentifier$userByIdentifier.fromJson(
              (l$userByIdentifier as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$AlmanakProfileByIdentifier$userByIdentifier userByIdentifier;

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
    if (!(other is Query$AlmanakProfileByIdentifier) ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$AlmanakProfileByIdentifier
    on Query$AlmanakProfileByIdentifier {
  CopyWith$Query$AlmanakProfileByIdentifier<Query$AlmanakProfileByIdentifier>
      get copyWith => CopyWith$Query$AlmanakProfileByIdentifier(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$AlmanakProfileByIdentifier<TRes> {
  factory CopyWith$Query$AlmanakProfileByIdentifier(
    Query$AlmanakProfileByIdentifier instance,
    TRes Function(Query$AlmanakProfileByIdentifier) then,
  ) = _CopyWithImpl$Query$AlmanakProfileByIdentifier;

  factory CopyWith$Query$AlmanakProfileByIdentifier.stub(TRes res) =
      _CopyWithStubImpl$Query$AlmanakProfileByIdentifier;

  TRes call({
    Query$AlmanakProfileByIdentifier$userByIdentifier? userByIdentifier,
    String? $__typename,
  });
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier<TRes>
      get userByIdentifier;
}

class _CopyWithImpl$Query$AlmanakProfileByIdentifier<TRes>
    implements CopyWith$Query$AlmanakProfileByIdentifier<TRes> {
  _CopyWithImpl$Query$AlmanakProfileByIdentifier(
    this._instance,
    this._then,
  );

  final Query$AlmanakProfileByIdentifier _instance;

  final TRes Function(Query$AlmanakProfileByIdentifier) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? userByIdentifier = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$AlmanakProfileByIdentifier(
        userByIdentifier:
            userByIdentifier == _undefined || userByIdentifier == null
                ? _instance.userByIdentifier
                : (userByIdentifier
                    as Query$AlmanakProfileByIdentifier$userByIdentifier),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier<TRes>
      get userByIdentifier {
    final local$userByIdentifier = _instance.userByIdentifier;
    return CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier(
        local$userByIdentifier, (e) => call(userByIdentifier: e));
  }
}

class _CopyWithStubImpl$Query$AlmanakProfileByIdentifier<TRes>
    implements CopyWith$Query$AlmanakProfileByIdentifier<TRes> {
  _CopyWithStubImpl$Query$AlmanakProfileByIdentifier(this._res);

  TRes _res;

  call({
    Query$AlmanakProfileByIdentifier$userByIdentifier? userByIdentifier,
    String? $__typename,
  }) =>
      _res;
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier<TRes>
      get userByIdentifier =>
          CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier.stub(_res);
}

const documentNodeQueryAlmanakProfileByIdentifier = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'AlmanakProfileByIdentifier'),
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
            name: NameNode(value: 'id'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
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
Query$AlmanakProfileByIdentifier _parserFn$Query$AlmanakProfileByIdentifier(
        Map<String, dynamic> data) =>
    Query$AlmanakProfileByIdentifier.fromJson(data);
typedef OnQueryComplete$Query$AlmanakProfileByIdentifier = FutureOr<void>
    Function(
  Map<String, dynamic>?,
  Query$AlmanakProfileByIdentifier?,
);

class Options$Query$AlmanakProfileByIdentifier
    extends graphql.QueryOptions<Query$AlmanakProfileByIdentifier> {
  Options$Query$AlmanakProfileByIdentifier({
    String? operationName,
    required Variables$Query$AlmanakProfileByIdentifier variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$AlmanakProfileByIdentifier? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$AlmanakProfileByIdentifier? onComplete,
    graphql.OnQueryError? onError,
  })  : onCompleteWithParsed = onComplete,
        super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          pollInterval: pollInterval,
          context: context,
          onComplete: onComplete == null
              ? null
              : (data) => onComplete(
                    data,
                    data == null
                        ? null
                        : _parserFn$Query$AlmanakProfileByIdentifier(data),
                  ),
          onError: onError,
          document: documentNodeQueryAlmanakProfileByIdentifier,
          parserFn: _parserFn$Query$AlmanakProfileByIdentifier,
        );

  final OnQueryComplete$Query$AlmanakProfileByIdentifier? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$AlmanakProfileByIdentifier
    extends graphql.WatchQueryOptions<Query$AlmanakProfileByIdentifier> {
  WatchOptions$Query$AlmanakProfileByIdentifier({
    String? operationName,
    required Variables$Query$AlmanakProfileByIdentifier variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$AlmanakProfileByIdentifier? typedOptimisticResult,
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
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          document: documentNodeQueryAlmanakProfileByIdentifier,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$AlmanakProfileByIdentifier,
        );
}

class FetchMoreOptions$Query$AlmanakProfileByIdentifier
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$AlmanakProfileByIdentifier({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$AlmanakProfileByIdentifier variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryAlmanakProfileByIdentifier,
        );
}

extension ClientExtension$Query$AlmanakProfileByIdentifier
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$AlmanakProfileByIdentifier>>
      query$AlmanakProfileByIdentifier(
              Options$Query$AlmanakProfileByIdentifier options) async =>
          await this.query(options);
  graphql.ObservableQuery<Query$AlmanakProfileByIdentifier>
      watchQuery$AlmanakProfileByIdentifier(
              WatchOptions$Query$AlmanakProfileByIdentifier options) =>
          this.watchQuery(options);
  void writeQuery$AlmanakProfileByIdentifier({
    required Query$AlmanakProfileByIdentifier data,
    required Variables$Query$AlmanakProfileByIdentifier variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(
              document: documentNodeQueryAlmanakProfileByIdentifier),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$AlmanakProfileByIdentifier? readQuery$AlmanakProfileByIdentifier({
    required Variables$Query$AlmanakProfileByIdentifier variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
            document: documentNodeQueryAlmanakProfileByIdentifier),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query$AlmanakProfileByIdentifier.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$AlmanakProfileByIdentifier>
    useQuery$AlmanakProfileByIdentifier(
            Options$Query$AlmanakProfileByIdentifier options) =>
        graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$AlmanakProfileByIdentifier>
    useWatchQuery$AlmanakProfileByIdentifier(
            WatchOptions$Query$AlmanakProfileByIdentifier options) =>
        graphql_flutter.useWatchQuery(options);

class Query$AlmanakProfileByIdentifier$Widget
    extends graphql_flutter.Query<Query$AlmanakProfileByIdentifier> {
  Query$AlmanakProfileByIdentifier$Widget({
    widgets.Key? key,
    required Options$Query$AlmanakProfileByIdentifier options,
    required graphql_flutter.QueryBuilder<Query$AlmanakProfileByIdentifier>
        builder,
  }) : super(
          key: key,
          options: options,
          builder: builder,
        );
}

class Query$AlmanakProfileByIdentifier$userByIdentifier {
  Query$AlmanakProfileByIdentifier$userByIdentifier({
    required this.id,
    required this.identifier,
    required this.email,
    required this.username,
    required this.fullContact,
    this.$__typename = 'User',
  });

  factory Query$AlmanakProfileByIdentifier$userByIdentifier.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$identifier = json['identifier'];
    final l$email = json['email'];
    final l$username = json['username'];
    final l$fullContact = json['fullContact'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakProfileByIdentifier$userByIdentifier(
      id: (l$id as String),
      identifier: (l$identifier as String),
      email: (l$email as String),
      username: (l$username as String),
      fullContact: Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact
          .fromJson((l$fullContact as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String identifier;

  final String email;

  final String username;

  final Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact
      fullContact;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
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
    final l$id = id;
    final l$identifier = identifier;
    final l$email = email;
    final l$username = username;
    final l$fullContact = fullContact;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
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
    if (!(other is Query$AlmanakProfileByIdentifier$userByIdentifier) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Query$AlmanakProfileByIdentifier$userByIdentifier
    on Query$AlmanakProfileByIdentifier$userByIdentifier {
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier<
          Query$AlmanakProfileByIdentifier$userByIdentifier>
      get copyWith =>
          CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier<
    TRes> {
  factory CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier(
    Query$AlmanakProfileByIdentifier$userByIdentifier instance,
    TRes Function(Query$AlmanakProfileByIdentifier$userByIdentifier) then,
  ) = _CopyWithImpl$Query$AlmanakProfileByIdentifier$userByIdentifier;

  factory CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier.stub(
          TRes res) =
      _CopyWithStubImpl$Query$AlmanakProfileByIdentifier$userByIdentifier;

  TRes call({
    String? id,
    String? identifier,
    String? email,
    String? username,
    Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact? fullContact,
    String? $__typename,
  });
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact<TRes>
      get fullContact;
}

class _CopyWithImpl$Query$AlmanakProfileByIdentifier$userByIdentifier<TRes>
    implements
        CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier<TRes> {
  _CopyWithImpl$Query$AlmanakProfileByIdentifier$userByIdentifier(
    this._instance,
    this._then,
  );

  final Query$AlmanakProfileByIdentifier$userByIdentifier _instance;

  final TRes Function(Query$AlmanakProfileByIdentifier$userByIdentifier) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? identifier = _undefined,
    Object? email = _undefined,
    Object? username = _undefined,
    Object? fullContact = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$AlmanakProfileByIdentifier$userByIdentifier(
        id: id == _undefined || id == null ? _instance.id : (id as String),
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
                as Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact<TRes>
      get fullContact {
    final local$fullContact = _instance.fullContact;
    return CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact(
        local$fullContact, (e) => call(fullContact: e));
  }
}

class _CopyWithStubImpl$Query$AlmanakProfileByIdentifier$userByIdentifier<TRes>
    implements
        CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier<TRes> {
  _CopyWithStubImpl$Query$AlmanakProfileByIdentifier$userByIdentifier(
      this._res);

  TRes _res;

  call({
    String? id,
    String? identifier,
    String? email,
    String? username,
    Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact? fullContact,
    String? $__typename,
  }) =>
      _res;
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact<TRes>
      get fullContact =>
          CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact
              .stub(_res);
}

class Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact {
  Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact({
    required this.public,
    this.$__typename = 'UserContact',
  });

  factory Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact.fromJson(
      Map<String, dynamic> json) {
    final l$public = json['public'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact(
      public:
          Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public
              .fromJson((l$public as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public
      public;

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
    if (!(other
            is Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact) ||
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

extension UtilityExtension$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact
    on Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact {
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact<
          Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact>
      get copyWith =>
          CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact<
    TRes> {
  factory CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact(
    Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact instance,
    TRes Function(Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact)
        then,
  ) = _CopyWithImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact;

  factory CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact.stub(
          TRes res) =
      _CopyWithStubImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact;

  TRes call({
    Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public?
        public,
    String? $__typename,
  });
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public<
      TRes> get public;
}

class _CopyWithImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact<
        TRes>
    implements
        CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact<
            TRes> {
  _CopyWithImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact(
    this._instance,
    this._then,
  );

  final Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact _instance;

  final TRes Function(
      Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? public = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact(
        public: public == _undefined || public == null
            ? _instance.public
            : (public
                as Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public<
      TRes> get public {
    final local$public = _instance.public;
    return CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public(
        local$public, (e) => call(public: e));
  }
}

class _CopyWithStubImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact<
        TRes>
    implements
        CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact<
            TRes> {
  _CopyWithStubImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact(
      this._res);

  TRes _res;

  call({
    Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public?
        public,
    String? $__typename,
  }) =>
      _res;
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public<
          TRes>
      get public =>
          CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public
              .stub(_res);
}

class Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public {
  Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public({
    this.first_name,
    this.last_name,
    this.email,
    this.street,
    this.housenumber,
    this.housenumber_addition,
    this.city,
    this.zipcode,
    this.phone_primary,
    this.$__typename = 'Contact',
  });

  factory Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public.fromJson(
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
    return Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public(
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
    if (!(other
            is Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public) ||
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

extension UtilityExtension$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public
    on Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public {
  CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public<
          Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public>
      get copyWith =>
          CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public<
    TRes> {
  factory CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public(
    Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public
        instance,
    TRes Function(
            Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public)
        then,
  ) = _CopyWithImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public;

  factory CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public.stub(
          TRes res) =
      _CopyWithStubImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public;

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

class _CopyWithImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public<
        TRes>
    implements
        CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public<
            TRes> {
  _CopyWithImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public(
    this._instance,
    this._then,
  );

  final Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public
      _instance;

  final TRes Function(
          Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public)
      _then;

  static const _undefined = <dynamic, dynamic>{};

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
      _then(
          Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public(
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

class _CopyWithStubImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public<
        TRes>
    implements
        CopyWith$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public<
            TRes> {
  _CopyWithStubImpl$Query$AlmanakProfileByIdentifier$userByIdentifier$fullContact$public(
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
