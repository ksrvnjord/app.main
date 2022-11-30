import '../../../../schema.graphql.dart';
import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Query$Me {
  Query$Me({this.me, required this.$__typename});

  factory Query$Me.fromJson(Map<String, dynamic> json) {
    final l$me = json['me'];
    final l$$__typename = json['__typename'];
    return Query$Me(
        me: l$me == null
            ? null
            : Query$Me$me.fromJson((l$me as Map<String, dynamic>)),
        $__typename: (l$$__typename as String));
  }

  final Query$Me$me? me;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$me = me;
    _resultData['me'] = l$me?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$me = me;
    final l$$__typename = $__typename;
    return Object.hashAll([l$me, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Me) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$me = me;
    final lOther$me = other.me;
    if (l$me != lOther$me) {
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

extension UtilityExtension$Query$Me on Query$Me {
  CopyWith$Query$Me<Query$Me> get copyWith => CopyWith$Query$Me(this, (i) => i);
}

abstract class CopyWith$Query$Me<TRes> {
  factory CopyWith$Query$Me(Query$Me instance, TRes Function(Query$Me) then) =
      _CopyWithImpl$Query$Me;

  factory CopyWith$Query$Me.stub(TRes res) = _CopyWithStubImpl$Query$Me;

  TRes call({Query$Me$me? me, String? $__typename});
  CopyWith$Query$Me$me<TRes> get me;
}

class _CopyWithImpl$Query$Me<TRes> implements CopyWith$Query$Me<TRes> {
  _CopyWithImpl$Query$Me(this._instance, this._then);

  final Query$Me _instance;

  final TRes Function(Query$Me) _then;

  static const _undefined = {};

  TRes call({Object? me = _undefined, Object? $__typename = _undefined}) =>
      _then(Query$Me(
          me: me == _undefined ? _instance.me : (me as Query$Me$me?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
  CopyWith$Query$Me$me<TRes> get me {
    final local$me = _instance.me;
    return local$me == null
        ? CopyWith$Query$Me$me.stub(_then(_instance))
        : CopyWith$Query$Me$me(local$me, (e) => call(me: e));
  }
}

class _CopyWithStubImpl$Query$Me<TRes> implements CopyWith$Query$Me<TRes> {
  _CopyWithStubImpl$Query$Me(this._res);

  TRes _res;

  call({Query$Me$me? me, String? $__typename}) => _res;
  CopyWith$Query$Me$me<TRes> get me => CopyWith$Query$Me$me.stub(_res);
}

const documentNodeQueryMe = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Me'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'me'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'identifier'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'email'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'username'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'listed'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
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
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'last_name'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'email'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'street'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'housenumber'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'housenumber_addition'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'city'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'zipcode'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'phone_primary'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: '__typename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null)
                        ])),
                    FieldNode(
                        name: NameNode(value: 'private'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                              name: NameNode(value: 'first_name'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'last_name'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'email'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'street'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'housenumber'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'housenumber_addition'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'city'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'zipcode'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'phone_primary'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: '__typename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null)
                        ])),
                    FieldNode(
                        name: NameNode(value: 'update'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                              name: NameNode(value: 'first_name'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'last_name'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'email'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'street'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'housenumber'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'housenumber_addition'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'city'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'zipcode'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'phone_primary'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: '__typename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null)
                        ])),
                    FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null)
            ])),
        FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null)
      ])),
]);
Query$Me _parserFn$Query$Me(Map<String, dynamic> data) =>
    Query$Me.fromJson(data);

class Options$Query$Me extends graphql.QueryOptions<Query$Me> {
  Options$Query$Me(
      {String? operationName,
      graphql.FetchPolicy? fetchPolicy,
      graphql.ErrorPolicy? errorPolicy,
      graphql.CacheRereadPolicy? cacheRereadPolicy,
      Object? optimisticResult,
      Duration? pollInterval,
      graphql.Context? context})
      : super(
            operationName: operationName,
            fetchPolicy: fetchPolicy,
            errorPolicy: errorPolicy,
            cacheRereadPolicy: cacheRereadPolicy,
            optimisticResult: optimisticResult,
            pollInterval: pollInterval,
            context: context,
            document: documentNodeQueryMe,
            parserFn: _parserFn$Query$Me);
}

class WatchOptions$Query$Me extends graphql.WatchQueryOptions<Query$Me> {
  WatchOptions$Query$Me(
      {String? operationName,
      graphql.FetchPolicy? fetchPolicy,
      graphql.ErrorPolicy? errorPolicy,
      graphql.CacheRereadPolicy? cacheRereadPolicy,
      Object? optimisticResult,
      graphql.Context? context,
      Duration? pollInterval,
      bool? eagerlyFetchResults,
      bool carryForwardDataOnException = true,
      bool fetchResults = false})
      : super(
            operationName: operationName,
            fetchPolicy: fetchPolicy,
            errorPolicy: errorPolicy,
            cacheRereadPolicy: cacheRereadPolicy,
            optimisticResult: optimisticResult,
            context: context,
            document: documentNodeQueryMe,
            pollInterval: pollInterval,
            eagerlyFetchResults: eagerlyFetchResults,
            carryForwardDataOnException: carryForwardDataOnException,
            fetchResults: fetchResults,
            parserFn: _parserFn$Query$Me);
}

class FetchMoreOptions$Query$Me extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Me({required graphql.UpdateQuery updateQuery})
      : super(updateQuery: updateQuery, document: documentNodeQueryMe);
}

extension ClientExtension$Query$Me on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Me>> query$Me(
          [Options$Query$Me? options]) async =>
      await this.query(options ?? Options$Query$Me());
  graphql.ObservableQuery<Query$Me> watchQuery$Me(
          [WatchOptions$Query$Me? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$Me());
  void writeQuery$Me({required Query$Me data, bool broadcast = true}) =>
      this.writeQuery(
          graphql.Request(
              operation: graphql.Operation(document: documentNodeQueryMe)),
          data: data.toJson(),
          broadcast: broadcast);
  Query$Me? readQuery$Me({bool optimistic = true}) {
    final result = this.readQuery(
        graphql.Request(
            operation: graphql.Operation(document: documentNodeQueryMe)),
        optimistic: optimistic);
    return result == null ? null : Query$Me.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$Me> useQuery$Me(
        [Options$Query$Me? options]) =>
    graphql_flutter.useQuery(options ?? Options$Query$Me());
graphql.ObservableQuery<Query$Me> useWatchQuery$Me(
        [WatchOptions$Query$Me? options]) =>
    graphql_flutter.useWatchQuery(options ?? WatchOptions$Query$Me());

class Query$Me$Widget extends graphql_flutter.Query<Query$Me> {
  Query$Me$Widget(
      {widgets.Key? key,
      Options$Query$Me? options,
      required graphql_flutter.QueryBuilder<Query$Me> builder})
      : super(
            key: key, options: options ?? Options$Query$Me(), builder: builder);
}

class Query$Me$me {
  Query$Me$me(
      {required this.identifier,
      required this.email,
      required this.username,
      required this.listed,
      required this.fullContact,
      required this.$__typename});

  factory Query$Me$me.fromJson(Map<String, dynamic> json) {
    final l$identifier = json['identifier'];
    final l$email = json['email'];
    final l$username = json['username'];
    final l$listed = json['listed'];
    final l$fullContact = json['fullContact'];
    final l$$__typename = json['__typename'];
    return Query$Me$me(
        identifier: (l$identifier as String),
        email: (l$email as String),
        username: (l$username as String),
        listed: (l$listed as bool),
        fullContact: Query$Me$me$fullContact.fromJson(
            (l$fullContact as Map<String, dynamic>)),
        $__typename: (l$$__typename as String));
  }

  final String identifier;

  final String email;

  final String username;

  final bool listed;

  final Query$Me$me$fullContact fullContact;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$identifier = identifier;
    _resultData['identifier'] = l$identifier;
    final l$email = email;
    _resultData['email'] = l$email;
    final l$username = username;
    _resultData['username'] = l$username;
    final l$listed = listed;
    _resultData['listed'] = l$listed;
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
    final l$listed = listed;
    final l$fullContact = fullContact;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$identifier,
      l$email,
      l$username,
      l$listed,
      l$fullContact,
      l$$__typename
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Me$me) || runtimeType != other.runtimeType) {
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
    final l$listed = listed;
    final lOther$listed = other.listed;
    if (l$listed != lOther$listed) {
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

extension UtilityExtension$Query$Me$me on Query$Me$me {
  CopyWith$Query$Me$me<Query$Me$me> get copyWith =>
      CopyWith$Query$Me$me(this, (i) => i);
}

abstract class CopyWith$Query$Me$me<TRes> {
  factory CopyWith$Query$Me$me(
          Query$Me$me instance, TRes Function(Query$Me$me) then) =
      _CopyWithImpl$Query$Me$me;

  factory CopyWith$Query$Me$me.stub(TRes res) = _CopyWithStubImpl$Query$Me$me;

  TRes call(
      {String? identifier,
      String? email,
      String? username,
      bool? listed,
      Query$Me$me$fullContact? fullContact,
      String? $__typename});
  CopyWith$Query$Me$me$fullContact<TRes> get fullContact;
}

class _CopyWithImpl$Query$Me$me<TRes> implements CopyWith$Query$Me$me<TRes> {
  _CopyWithImpl$Query$Me$me(this._instance, this._then);

  final Query$Me$me _instance;

  final TRes Function(Query$Me$me) _then;

  static const _undefined = {};

  TRes call(
          {Object? identifier = _undefined,
          Object? email = _undefined,
          Object? username = _undefined,
          Object? listed = _undefined,
          Object? fullContact = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$Me$me(
          identifier: identifier == _undefined || identifier == null
              ? _instance.identifier
              : (identifier as String),
          email: email == _undefined || email == null
              ? _instance.email
              : (email as String),
          username: username == _undefined || username == null
              ? _instance.username
              : (username as String),
          listed: listed == _undefined || listed == null
              ? _instance.listed
              : (listed as bool),
          fullContact: fullContact == _undefined || fullContact == null
              ? _instance.fullContact
              : (fullContact as Query$Me$me$fullContact),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
  CopyWith$Query$Me$me$fullContact<TRes> get fullContact {
    final local$fullContact = _instance.fullContact;
    return CopyWith$Query$Me$me$fullContact(
        local$fullContact, (e) => call(fullContact: e));
  }
}

class _CopyWithStubImpl$Query$Me$me<TRes>
    implements CopyWith$Query$Me$me<TRes> {
  _CopyWithStubImpl$Query$Me$me(this._res);

  TRes _res;

  call(
          {String? identifier,
          String? email,
          String? username,
          bool? listed,
          Query$Me$me$fullContact? fullContact,
          String? $__typename}) =>
      _res;
  CopyWith$Query$Me$me$fullContact<TRes> get fullContact =>
      CopyWith$Query$Me$me$fullContact.stub(_res);
}

class Query$Me$me$fullContact {
  Query$Me$me$fullContact(
      {required this.public,
      this.private,
      this.update,
      required this.$__typename});

  factory Query$Me$me$fullContact.fromJson(Map<String, dynamic> json) {
    final l$public = json['public'];
    final l$private = json['private'];
    final l$update = json['update'];
    final l$$__typename = json['__typename'];
    return Query$Me$me$fullContact(
        public: Query$Me$me$fullContact$public.fromJson(
            (l$public as Map<String, dynamic>)),
        private: l$private == null
            ? null
            : Query$Me$me$fullContact$private.fromJson(
                (l$private as Map<String, dynamic>)),
        update: l$update == null
            ? null
            : Query$Me$me$fullContact$update.fromJson(
                (l$update as Map<String, dynamic>)),
        $__typename: (l$$__typename as String));
  }

  final Query$Me$me$fullContact$public public;

  final Query$Me$me$fullContact$private? private;

  final Query$Me$me$fullContact$update? update;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$public = public;
    _resultData['public'] = l$public.toJson();
    final l$private = private;
    _resultData['private'] = l$private?.toJson();
    final l$update = update;
    _resultData['update'] = l$update?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$public = public;
    final l$private = private;
    final l$update = update;
    final l$$__typename = $__typename;
    return Object.hashAll([l$public, l$private, l$update, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Me$me$fullContact) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$public = public;
    final lOther$public = other.public;
    if (l$public != lOther$public) {
      return false;
    }
    final l$private = private;
    final lOther$private = other.private;
    if (l$private != lOther$private) {
      return false;
    }
    final l$update = update;
    final lOther$update = other.update;
    if (l$update != lOther$update) {
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

extension UtilityExtension$Query$Me$me$fullContact on Query$Me$me$fullContact {
  CopyWith$Query$Me$me$fullContact<Query$Me$me$fullContact> get copyWith =>
      CopyWith$Query$Me$me$fullContact(this, (i) => i);
}

abstract class CopyWith$Query$Me$me$fullContact<TRes> {
  factory CopyWith$Query$Me$me$fullContact(Query$Me$me$fullContact instance,
          TRes Function(Query$Me$me$fullContact) then) =
      _CopyWithImpl$Query$Me$me$fullContact;

  factory CopyWith$Query$Me$me$fullContact.stub(TRes res) =
      _CopyWithStubImpl$Query$Me$me$fullContact;

  TRes call(
      {Query$Me$me$fullContact$public? public,
      Query$Me$me$fullContact$private? private,
      Query$Me$me$fullContact$update? update,
      String? $__typename});
  CopyWith$Query$Me$me$fullContact$public<TRes> get public;
  CopyWith$Query$Me$me$fullContact$private<TRes> get private;
  CopyWith$Query$Me$me$fullContact$update<TRes> get update;
}

class _CopyWithImpl$Query$Me$me$fullContact<TRes>
    implements CopyWith$Query$Me$me$fullContact<TRes> {
  _CopyWithImpl$Query$Me$me$fullContact(this._instance, this._then);

  final Query$Me$me$fullContact _instance;

  final TRes Function(Query$Me$me$fullContact) _then;

  static const _undefined = {};

  TRes call(
          {Object? public = _undefined,
          Object? private = _undefined,
          Object? update = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$Me$me$fullContact(
          public: public == _undefined || public == null
              ? _instance.public
              : (public as Query$Me$me$fullContact$public),
          private: private == _undefined
              ? _instance.private
              : (private as Query$Me$me$fullContact$private?),
          update: update == _undefined
              ? _instance.update
              : (update as Query$Me$me$fullContact$update?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
  CopyWith$Query$Me$me$fullContact$public<TRes> get public {
    final local$public = _instance.public;
    return CopyWith$Query$Me$me$fullContact$public(
        local$public, (e) => call(public: e));
  }

  CopyWith$Query$Me$me$fullContact$private<TRes> get private {
    final local$private = _instance.private;
    return local$private == null
        ? CopyWith$Query$Me$me$fullContact$private.stub(_then(_instance))
        : CopyWith$Query$Me$me$fullContact$private(
            local$private, (e) => call(private: e));
  }

  CopyWith$Query$Me$me$fullContact$update<TRes> get update {
    final local$update = _instance.update;
    return local$update == null
        ? CopyWith$Query$Me$me$fullContact$update.stub(_then(_instance))
        : CopyWith$Query$Me$me$fullContact$update(
            local$update, (e) => call(update: e));
  }
}

class _CopyWithStubImpl$Query$Me$me$fullContact<TRes>
    implements CopyWith$Query$Me$me$fullContact<TRes> {
  _CopyWithStubImpl$Query$Me$me$fullContact(this._res);

  TRes _res;

  call(
          {Query$Me$me$fullContact$public? public,
          Query$Me$me$fullContact$private? private,
          Query$Me$me$fullContact$update? update,
          String? $__typename}) =>
      _res;
  CopyWith$Query$Me$me$fullContact$public<TRes> get public =>
      CopyWith$Query$Me$me$fullContact$public.stub(_res);
  CopyWith$Query$Me$me$fullContact$private<TRes> get private =>
      CopyWith$Query$Me$me$fullContact$private.stub(_res);
  CopyWith$Query$Me$me$fullContact$update<TRes> get update =>
      CopyWith$Query$Me$me$fullContact$update.stub(_res);
}

class Query$Me$me$fullContact$public {
  Query$Me$me$fullContact$public(
      {this.first_name,
      this.last_name,
      this.email,
      this.street,
      this.housenumber,
      this.housenumber_addition,
      this.city,
      this.zipcode,
      this.phone_primary,
      required this.$__typename});

  factory Query$Me$me$fullContact$public.fromJson(Map<String, dynamic> json) {
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
    return Query$Me$me$fullContact$public(
        first_name: (l$first_name as String?),
        last_name: (l$last_name as String?),
        email: (l$email as String?),
        street: (l$street as String?),
        housenumber: (l$housenumber as String?),
        housenumber_addition: (l$housenumber_addition as String?),
        city: (l$city as String?),
        zipcode: (l$zipcode as String?),
        phone_primary: (l$phone_primary as String?),
        $__typename: (l$$__typename as String));
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
      l$$__typename
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Me$me$fullContact$public) ||
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

extension UtilityExtension$Query$Me$me$fullContact$public
    on Query$Me$me$fullContact$public {
  CopyWith$Query$Me$me$fullContact$public<Query$Me$me$fullContact$public>
      get copyWith => CopyWith$Query$Me$me$fullContact$public(this, (i) => i);
}

abstract class CopyWith$Query$Me$me$fullContact$public<TRes> {
  factory CopyWith$Query$Me$me$fullContact$public(
          Query$Me$me$fullContact$public instance,
          TRes Function(Query$Me$me$fullContact$public) then) =
      _CopyWithImpl$Query$Me$me$fullContact$public;

  factory CopyWith$Query$Me$me$fullContact$public.stub(TRes res) =
      _CopyWithStubImpl$Query$Me$me$fullContact$public;

  TRes call(
      {String? first_name,
      String? last_name,
      String? email,
      String? street,
      String? housenumber,
      String? housenumber_addition,
      String? city,
      String? zipcode,
      String? phone_primary,
      String? $__typename});
}

class _CopyWithImpl$Query$Me$me$fullContact$public<TRes>
    implements CopyWith$Query$Me$me$fullContact$public<TRes> {
  _CopyWithImpl$Query$Me$me$fullContact$public(this._instance, this._then);

  final Query$Me$me$fullContact$public _instance;

  final TRes Function(Query$Me$me$fullContact$public) _then;

  static const _undefined = {};

  TRes call(
          {Object? first_name = _undefined,
          Object? last_name = _undefined,
          Object? email = _undefined,
          Object? street = _undefined,
          Object? housenumber = _undefined,
          Object? housenumber_addition = _undefined,
          Object? city = _undefined,
          Object? zipcode = _undefined,
          Object? phone_primary = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$Me$me$fullContact$public(
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
              : ($__typename as String)));
}

class _CopyWithStubImpl$Query$Me$me$fullContact$public<TRes>
    implements CopyWith$Query$Me$me$fullContact$public<TRes> {
  _CopyWithStubImpl$Query$Me$me$fullContact$public(this._res);

  TRes _res;

  call(
          {String? first_name,
          String? last_name,
          String? email,
          String? street,
          String? housenumber,
          String? housenumber_addition,
          String? city,
          String? zipcode,
          String? phone_primary,
          String? $__typename}) =>
      _res;
}

class Query$Me$me$fullContact$private {
  Query$Me$me$fullContact$private(
      {this.first_name,
      this.last_name,
      this.email,
      this.street,
      this.housenumber,
      this.housenumber_addition,
      this.city,
      this.zipcode,
      this.phone_primary,
      required this.$__typename});

  factory Query$Me$me$fullContact$private.fromJson(Map<String, dynamic> json) {
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
    return Query$Me$me$fullContact$private(
        first_name: (l$first_name as String?),
        last_name: (l$last_name as String?),
        email: (l$email as String?),
        street: (l$street as String?),
        housenumber: (l$housenumber as String?),
        housenumber_addition: (l$housenumber_addition as String?),
        city: (l$city as String?),
        zipcode: (l$zipcode as String?),
        phone_primary: (l$phone_primary as String?),
        $__typename: (l$$__typename as String));
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
      l$$__typename
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Me$me$fullContact$private) ||
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

extension UtilityExtension$Query$Me$me$fullContact$private
    on Query$Me$me$fullContact$private {
  CopyWith$Query$Me$me$fullContact$private<Query$Me$me$fullContact$private>
      get copyWith => CopyWith$Query$Me$me$fullContact$private(this, (i) => i);
}

abstract class CopyWith$Query$Me$me$fullContact$private<TRes> {
  factory CopyWith$Query$Me$me$fullContact$private(
          Query$Me$me$fullContact$private instance,
          TRes Function(Query$Me$me$fullContact$private) then) =
      _CopyWithImpl$Query$Me$me$fullContact$private;

  factory CopyWith$Query$Me$me$fullContact$private.stub(TRes res) =
      _CopyWithStubImpl$Query$Me$me$fullContact$private;

  TRes call(
      {String? first_name,
      String? last_name,
      String? email,
      String? street,
      String? housenumber,
      String? housenumber_addition,
      String? city,
      String? zipcode,
      String? phone_primary,
      String? $__typename});
}

class _CopyWithImpl$Query$Me$me$fullContact$private<TRes>
    implements CopyWith$Query$Me$me$fullContact$private<TRes> {
  _CopyWithImpl$Query$Me$me$fullContact$private(this._instance, this._then);

  final Query$Me$me$fullContact$private _instance;

  final TRes Function(Query$Me$me$fullContact$private) _then;

  static const _undefined = {};

  TRes call(
          {Object? first_name = _undefined,
          Object? last_name = _undefined,
          Object? email = _undefined,
          Object? street = _undefined,
          Object? housenumber = _undefined,
          Object? housenumber_addition = _undefined,
          Object? city = _undefined,
          Object? zipcode = _undefined,
          Object? phone_primary = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$Me$me$fullContact$private(
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
              : ($__typename as String)));
}

class _CopyWithStubImpl$Query$Me$me$fullContact$private<TRes>
    implements CopyWith$Query$Me$me$fullContact$private<TRes> {
  _CopyWithStubImpl$Query$Me$me$fullContact$private(this._res);

  TRes _res;

  call(
          {String? first_name,
          String? last_name,
          String? email,
          String? street,
          String? housenumber,
          String? housenumber_addition,
          String? city,
          String? zipcode,
          String? phone_primary,
          String? $__typename}) =>
      _res;
}

class Query$Me$me$fullContact$update {
  Query$Me$me$fullContact$update(
      {this.first_name,
      this.last_name,
      this.email,
      this.street,
      this.housenumber,
      this.housenumber_addition,
      this.city,
      this.zipcode,
      this.phone_primary,
      required this.$__typename});

  factory Query$Me$me$fullContact$update.fromJson(Map<String, dynamic> json) {
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
    return Query$Me$me$fullContact$update(
        first_name: (l$first_name as String?),
        last_name: (l$last_name as String?),
        email: (l$email as String?),
        street: (l$street as String?),
        housenumber: (l$housenumber as String?),
        housenumber_addition: (l$housenumber_addition as String?),
        city: (l$city as String?),
        zipcode: (l$zipcode as String?),
        phone_primary: (l$phone_primary as String?),
        $__typename: (l$$__typename as String));
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
      l$$__typename
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Me$me$fullContact$update) ||
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

extension UtilityExtension$Query$Me$me$fullContact$update
    on Query$Me$me$fullContact$update {
  CopyWith$Query$Me$me$fullContact$update<Query$Me$me$fullContact$update>
      get copyWith => CopyWith$Query$Me$me$fullContact$update(this, (i) => i);
}

abstract class CopyWith$Query$Me$me$fullContact$update<TRes> {
  factory CopyWith$Query$Me$me$fullContact$update(
          Query$Me$me$fullContact$update instance,
          TRes Function(Query$Me$me$fullContact$update) then) =
      _CopyWithImpl$Query$Me$me$fullContact$update;

  factory CopyWith$Query$Me$me$fullContact$update.stub(TRes res) =
      _CopyWithStubImpl$Query$Me$me$fullContact$update;

  TRes call(
      {String? first_name,
      String? last_name,
      String? email,
      String? street,
      String? housenumber,
      String? housenumber_addition,
      String? city,
      String? zipcode,
      String? phone_primary,
      String? $__typename});
}

class _CopyWithImpl$Query$Me$me$fullContact$update<TRes>
    implements CopyWith$Query$Me$me$fullContact$update<TRes> {
  _CopyWithImpl$Query$Me$me$fullContact$update(this._instance, this._then);

  final Query$Me$me$fullContact$update _instance;

  final TRes Function(Query$Me$me$fullContact$update) _then;

  static const _undefined = {};

  TRes call(
          {Object? first_name = _undefined,
          Object? last_name = _undefined,
          Object? email = _undefined,
          Object? street = _undefined,
          Object? housenumber = _undefined,
          Object? housenumber_addition = _undefined,
          Object? city = _undefined,
          Object? zipcode = _undefined,
          Object? phone_primary = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$Me$me$fullContact$update(
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
              : ($__typename as String)));
}

class _CopyWithStubImpl$Query$Me$me$fullContact$update<TRes>
    implements CopyWith$Query$Me$me$fullContact$update<TRes> {
  _CopyWithStubImpl$Query$Me$me$fullContact$update(this._res);

  TRes _res;

  call(
          {String? first_name,
          String? last_name,
          String? email,
          String? street,
          String? housenumber,
          String? housenumber_addition,
          String? city,
          String? zipcode,
          String? phone_primary,
          String? $__typename}) =>
      _res;
}

class Variables$Mutation$Me {
  factory Variables$Mutation$Me({required Input$IContact contact}) =>
      Variables$Mutation$Me._({
        r'contact': contact,
      });

  Variables$Mutation$Me._(this._$data);

  factory Variables$Mutation$Me.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$contact = data['contact'];
    result$data['contact'] =
        Input$IContact.fromJson((l$contact as Map<String, dynamic>));
    return Variables$Mutation$Me._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$IContact get contact => (_$data['contact'] as Input$IContact);
  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$contact = contact;
    result$data['contact'] = l$contact.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$Me<Variables$Mutation$Me> get copyWith =>
      CopyWith$Variables$Mutation$Me(this, (i) => i);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Variables$Mutation$Me) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$contact = contact;
    final lOther$contact = other.contact;
    if (l$contact != lOther$contact) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$contact = contact;
    return Object.hashAll([l$contact]);
  }
}

abstract class CopyWith$Variables$Mutation$Me<TRes> {
  factory CopyWith$Variables$Mutation$Me(Variables$Mutation$Me instance,
          TRes Function(Variables$Mutation$Me) then) =
      _CopyWithImpl$Variables$Mutation$Me;

  factory CopyWith$Variables$Mutation$Me.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$Me;

  TRes call({Input$IContact? contact});
}

class _CopyWithImpl$Variables$Mutation$Me<TRes>
    implements CopyWith$Variables$Mutation$Me<TRes> {
  _CopyWithImpl$Variables$Mutation$Me(this._instance, this._then);

  final Variables$Mutation$Me _instance;

  final TRes Function(Variables$Mutation$Me) _then;

  static const _undefined = {};

  TRes call({Object? contact = _undefined}) => _then(Variables$Mutation$Me._({
        ..._instance._$data,
        if (contact != _undefined && contact != null)
          'contact': (contact as Input$IContact),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$Me<TRes>
    implements CopyWith$Variables$Mutation$Me<TRes> {
  _CopyWithStubImpl$Variables$Mutation$Me(this._res);

  TRes _res;

  call({Input$IContact? contact}) => _res;
}

class Mutation$Me {
  Mutation$Me({this.updateContactDetails, required this.$__typename});

  factory Mutation$Me.fromJson(Map<String, dynamic> json) {
    final l$updateContactDetails = json['updateContactDetails'];
    final l$$__typename = json['__typename'];
    return Mutation$Me(
        updateContactDetails: l$updateContactDetails == null
            ? null
            : Mutation$Me$updateContactDetails.fromJson(
                (l$updateContactDetails as Map<String, dynamic>)),
        $__typename: (l$$__typename as String));
  }

  final Mutation$Me$updateContactDetails? updateContactDetails;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateContactDetails = updateContactDetails;
    _resultData['updateContactDetails'] = l$updateContactDetails?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateContactDetails = updateContactDetails;
    final l$$__typename = $__typename;
    return Object.hashAll([l$updateContactDetails, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Mutation$Me) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateContactDetails = updateContactDetails;
    final lOther$updateContactDetails = other.updateContactDetails;
    if (l$updateContactDetails != lOther$updateContactDetails) {
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

extension UtilityExtension$Mutation$Me on Mutation$Me {
  CopyWith$Mutation$Me<Mutation$Me> get copyWith =>
      CopyWith$Mutation$Me(this, (i) => i);
}

abstract class CopyWith$Mutation$Me<TRes> {
  factory CopyWith$Mutation$Me(
          Mutation$Me instance, TRes Function(Mutation$Me) then) =
      _CopyWithImpl$Mutation$Me;

  factory CopyWith$Mutation$Me.stub(TRes res) = _CopyWithStubImpl$Mutation$Me;

  TRes call(
      {Mutation$Me$updateContactDetails? updateContactDetails,
      String? $__typename});
  CopyWith$Mutation$Me$updateContactDetails<TRes> get updateContactDetails;
}

class _CopyWithImpl$Mutation$Me<TRes> implements CopyWith$Mutation$Me<TRes> {
  _CopyWithImpl$Mutation$Me(this._instance, this._then);

  final Mutation$Me _instance;

  final TRes Function(Mutation$Me) _then;

  static const _undefined = {};

  TRes call(
          {Object? updateContactDetails = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Mutation$Me(
          updateContactDetails: updateContactDetails == _undefined
              ? _instance.updateContactDetails
              : (updateContactDetails as Mutation$Me$updateContactDetails?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
  CopyWith$Mutation$Me$updateContactDetails<TRes> get updateContactDetails {
    final local$updateContactDetails = _instance.updateContactDetails;
    return local$updateContactDetails == null
        ? CopyWith$Mutation$Me$updateContactDetails.stub(_then(_instance))
        : CopyWith$Mutation$Me$updateContactDetails(
            local$updateContactDetails, (e) => call(updateContactDetails: e));
  }
}

class _CopyWithStubImpl$Mutation$Me<TRes>
    implements CopyWith$Mutation$Me<TRes> {
  _CopyWithStubImpl$Mutation$Me(this._res);

  TRes _res;

  call(
          {Mutation$Me$updateContactDetails? updateContactDetails,
          String? $__typename}) =>
      _res;
  CopyWith$Mutation$Me$updateContactDetails<TRes> get updateContactDetails =>
      CopyWith$Mutation$Me$updateContactDetails.stub(_res);
}

const documentNodeMutationMe = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'Me'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'contact')),
            type: NamedTypeNode(
                name: NameNode(value: 'IContact'), isNonNull: true),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'updateContactDetails'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'contact'),
                  value: VariableNode(name: NameNode(value: 'contact')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'first_name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'last_name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'email'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'street'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'housenumber'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'housenumber_addition'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'city'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'zipcode'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null)
            ])),
        FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null)
      ])),
]);
Mutation$Me _parserFn$Mutation$Me(Map<String, dynamic> data) =>
    Mutation$Me.fromJson(data);
typedef OnMutationCompleted$Mutation$Me = FutureOr<void> Function(
    dynamic, Mutation$Me?);

class Options$Mutation$Me extends graphql.MutationOptions<Mutation$Me> {
  Options$Mutation$Me(
      {String? operationName,
      required Variables$Mutation$Me variables,
      graphql.FetchPolicy? fetchPolicy,
      graphql.ErrorPolicy? errorPolicy,
      graphql.CacheRereadPolicy? cacheRereadPolicy,
      Object? optimisticResult,
      graphql.Context? context,
      OnMutationCompleted$Mutation$Me? onCompleted,
      graphql.OnMutationUpdate<Mutation$Me>? update,
      graphql.OnError? onError})
      : onCompletedWithParsed = onCompleted,
        super(
            variables: variables.toJson(),
            operationName: operationName,
            fetchPolicy: fetchPolicy,
            errorPolicy: errorPolicy,
            cacheRereadPolicy: cacheRereadPolicy,
            optimisticResult: optimisticResult,
            context: context,
            onCompleted: onCompleted == null
                ? null
                : (data) => onCompleted(
                    data, data == null ? null : _parserFn$Mutation$Me(data)),
            update: update,
            onError: onError,
            document: documentNodeMutationMe,
            parserFn: _parserFn$Mutation$Me);

  final OnMutationCompleted$Mutation$Me? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed
      ];
}

class WatchOptions$Mutation$Me extends graphql.WatchQueryOptions<Mutation$Me> {
  WatchOptions$Mutation$Me(
      {String? operationName,
      required Variables$Mutation$Me variables,
      graphql.FetchPolicy? fetchPolicy,
      graphql.ErrorPolicy? errorPolicy,
      graphql.CacheRereadPolicy? cacheRereadPolicy,
      Object? optimisticResult,
      graphql.Context? context,
      Duration? pollInterval,
      bool? eagerlyFetchResults,
      bool carryForwardDataOnException = true,
      bool fetchResults = false})
      : super(
            variables: variables.toJson(),
            operationName: operationName,
            fetchPolicy: fetchPolicy,
            errorPolicy: errorPolicy,
            cacheRereadPolicy: cacheRereadPolicy,
            optimisticResult: optimisticResult,
            context: context,
            document: documentNodeMutationMe,
            pollInterval: pollInterval,
            eagerlyFetchResults: eagerlyFetchResults,
            carryForwardDataOnException: carryForwardDataOnException,
            fetchResults: fetchResults,
            parserFn: _parserFn$Mutation$Me);
}

extension ClientExtension$Mutation$Me on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$Me>> mutate$Me(
          Options$Mutation$Me options) async =>
      await this.mutate(options);
  graphql.ObservableQuery<Mutation$Me> watchMutation$Me(
          WatchOptions$Mutation$Me options) =>
      this.watchMutation(options);
}

class Mutation$Me$HookResult {
  Mutation$Me$HookResult(this.runMutation, this.result);

  final RunMutation$Mutation$Me runMutation;

  final graphql.QueryResult<Mutation$Me> result;
}

Mutation$Me$HookResult useMutation$Me([WidgetOptions$Mutation$Me? options]) {
  final result =
      graphql_flutter.useMutation(options ?? WidgetOptions$Mutation$Me());
  return Mutation$Me$HookResult(
    (variables, {optimisticResult}) => result.runMutation(
      variables.toJson(),
      optimisticResult: optimisticResult,
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$Me> useWatchMutation$Me(
        WatchOptions$Mutation$Me options) =>
    graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$Me extends graphql.MutationOptions<Mutation$Me> {
  WidgetOptions$Mutation$Me(
      {String? operationName,
      graphql.FetchPolicy? fetchPolicy,
      graphql.ErrorPolicy? errorPolicy,
      graphql.CacheRereadPolicy? cacheRereadPolicy,
      Object? optimisticResult,
      graphql.Context? context,
      OnMutationCompleted$Mutation$Me? onCompleted,
      graphql.OnMutationUpdate<Mutation$Me>? update,
      graphql.OnError? onError})
      : onCompletedWithParsed = onCompleted,
        super(
            operationName: operationName,
            fetchPolicy: fetchPolicy,
            errorPolicy: errorPolicy,
            cacheRereadPolicy: cacheRereadPolicy,
            optimisticResult: optimisticResult,
            context: context,
            onCompleted: onCompleted == null
                ? null
                : (data) => onCompleted(
                    data, data == null ? null : _parserFn$Mutation$Me(data)),
            update: update,
            onError: onError,
            document: documentNodeMutationMe,
            parserFn: _parserFn$Mutation$Me);

  final OnMutationCompleted$Mutation$Me? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed
      ];
}

typedef RunMutation$Mutation$Me = graphql.MultiSourceResult<Mutation$Me>
    Function(Variables$Mutation$Me, {Object? optimisticResult});
typedef Builder$Mutation$Me = widgets.Widget Function(
    RunMutation$Mutation$Me, graphql.QueryResult<Mutation$Me>?);

class Mutation$Me$Widget extends graphql_flutter.Mutation<Mutation$Me> {
  Mutation$Me$Widget(
      {widgets.Key? key,
      WidgetOptions$Mutation$Me? options,
      required Builder$Mutation$Me builder})
      : super(
            key: key,
            options: options ?? WidgetOptions$Mutation$Me(),
            builder: (run, result) => builder(
                (variables, {optimisticResult}) =>
                    run(variables.toJson(), optimisticResult: optimisticResult),
                result));
}

class Mutation$Me$updateContactDetails {
  Mutation$Me$updateContactDetails(
      {this.first_name,
      this.last_name,
      this.email,
      this.street,
      this.housenumber,
      this.housenumber_addition,
      this.city,
      this.zipcode,
      required this.$__typename});

  factory Mutation$Me$updateContactDetails.fromJson(Map<String, dynamic> json) {
    final l$first_name = json['first_name'];
    final l$last_name = json['last_name'];
    final l$email = json['email'];
    final l$street = json['street'];
    final l$housenumber = json['housenumber'];
    final l$housenumber_addition = json['housenumber_addition'];
    final l$city = json['city'];
    final l$zipcode = json['zipcode'];
    final l$$__typename = json['__typename'];
    return Mutation$Me$updateContactDetails(
        first_name: (l$first_name as String?),
        last_name: (l$last_name as String?),
        email: (l$email as String?),
        street: (l$street as String?),
        housenumber: (l$housenumber as String?),
        housenumber_addition: (l$housenumber_addition as String?),
        city: (l$city as String?),
        zipcode: (l$zipcode as String?),
        $__typename: (l$$__typename as String));
  }

  final String? first_name;

  final String? last_name;

  final String? email;

  final String? street;

  final String? housenumber;

  final String? housenumber_addition;

  final String? city;

  final String? zipcode;

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
      l$$__typename
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Mutation$Me$updateContactDetails) ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$Me$updateContactDetails
    on Mutation$Me$updateContactDetails {
  CopyWith$Mutation$Me$updateContactDetails<Mutation$Me$updateContactDetails>
      get copyWith => CopyWith$Mutation$Me$updateContactDetails(this, (i) => i);
}

abstract class CopyWith$Mutation$Me$updateContactDetails<TRes> {
  factory CopyWith$Mutation$Me$updateContactDetails(
          Mutation$Me$updateContactDetails instance,
          TRes Function(Mutation$Me$updateContactDetails) then) =
      _CopyWithImpl$Mutation$Me$updateContactDetails;

  factory CopyWith$Mutation$Me$updateContactDetails.stub(TRes res) =
      _CopyWithStubImpl$Mutation$Me$updateContactDetails;

  TRes call(
      {String? first_name,
      String? last_name,
      String? email,
      String? street,
      String? housenumber,
      String? housenumber_addition,
      String? city,
      String? zipcode,
      String? $__typename});
}

class _CopyWithImpl$Mutation$Me$updateContactDetails<TRes>
    implements CopyWith$Mutation$Me$updateContactDetails<TRes> {
  _CopyWithImpl$Mutation$Me$updateContactDetails(this._instance, this._then);

  final Mutation$Me$updateContactDetails _instance;

  final TRes Function(Mutation$Me$updateContactDetails) _then;

  static const _undefined = {};

  TRes call(
          {Object? first_name = _undefined,
          Object? last_name = _undefined,
          Object? email = _undefined,
          Object? street = _undefined,
          Object? housenumber = _undefined,
          Object? housenumber_addition = _undefined,
          Object? city = _undefined,
          Object? zipcode = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Mutation$Me$updateContactDetails(
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
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
}

class _CopyWithStubImpl$Mutation$Me$updateContactDetails<TRes>
    implements CopyWith$Mutation$Me$updateContactDetails<TRes> {
  _CopyWithStubImpl$Mutation$Me$updateContactDetails(this._res);

  TRes _res;

  call(
          {String? first_name,
          String? last_name,
          String? email,
          String? street,
          String? housenumber,
          String? housenumber_addition,
          String? city,
          String? zipcode,
          String? $__typename}) =>
      _res;
}

class Variables$Mutation$UpdateVisibility {
  factory Variables$Mutation$UpdateVisibility(
          {required bool listed, required Input$IBooleanContact contact}) =>
      Variables$Mutation$UpdateVisibility._({
        r'listed': listed,
        r'contact': contact,
      });

  Variables$Mutation$UpdateVisibility._(this._$data);

  factory Variables$Mutation$UpdateVisibility.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$listed = data['listed'];
    result$data['listed'] = (l$listed as bool);
    final l$contact = data['contact'];
    result$data['contact'] =
        Input$IBooleanContact.fromJson((l$contact as Map<String, dynamic>));
    return Variables$Mutation$UpdateVisibility._(result$data);
  }

  Map<String, dynamic> _$data;

  bool get listed => (_$data['listed'] as bool);
  Input$IBooleanContact get contact =>
      (_$data['contact'] as Input$IBooleanContact);
  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$listed = listed;
    result$data['listed'] = l$listed;
    final l$contact = contact;
    result$data['contact'] = l$contact.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$UpdateVisibility<
          Variables$Mutation$UpdateVisibility>
      get copyWith =>
          CopyWith$Variables$Mutation$UpdateVisibility(this, (i) => i);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Variables$Mutation$UpdateVisibility) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$listed = listed;
    final lOther$listed = other.listed;
    if (l$listed != lOther$listed) {
      return false;
    }
    final l$contact = contact;
    final lOther$contact = other.contact;
    if (l$contact != lOther$contact) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$listed = listed;
    final l$contact = contact;
    return Object.hashAll([l$listed, l$contact]);
  }
}

abstract class CopyWith$Variables$Mutation$UpdateVisibility<TRes> {
  factory CopyWith$Variables$Mutation$UpdateVisibility(
          Variables$Mutation$UpdateVisibility instance,
          TRes Function(Variables$Mutation$UpdateVisibility) then) =
      _CopyWithImpl$Variables$Mutation$UpdateVisibility;

  factory CopyWith$Variables$Mutation$UpdateVisibility.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$UpdateVisibility;

  TRes call({bool? listed, Input$IBooleanContact? contact});
}

class _CopyWithImpl$Variables$Mutation$UpdateVisibility<TRes>
    implements CopyWith$Variables$Mutation$UpdateVisibility<TRes> {
  _CopyWithImpl$Variables$Mutation$UpdateVisibility(this._instance, this._then);

  final Variables$Mutation$UpdateVisibility _instance;

  final TRes Function(Variables$Mutation$UpdateVisibility) _then;

  static const _undefined = {};

  TRes call({Object? listed = _undefined, Object? contact = _undefined}) =>
      _then(Variables$Mutation$UpdateVisibility._({
        ..._instance._$data,
        if (listed != _undefined && listed != null) 'listed': (listed as bool),
        if (contact != _undefined && contact != null)
          'contact': (contact as Input$IBooleanContact),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$UpdateVisibility<TRes>
    implements CopyWith$Variables$Mutation$UpdateVisibility<TRes> {
  _CopyWithStubImpl$Variables$Mutation$UpdateVisibility(this._res);

  TRes _res;

  call({bool? listed, Input$IBooleanContact? contact}) => _res;
}

class Mutation$UpdateVisibility {
  Mutation$UpdateVisibility(
      {this.toggleListed, this.updatePublicContact, required this.$__typename});

  factory Mutation$UpdateVisibility.fromJson(Map<String, dynamic> json) {
    final l$toggleListed = json['toggleListed'];
    final l$updatePublicContact = json['updatePublicContact'];
    final l$$__typename = json['__typename'];
    return Mutation$UpdateVisibility(
        toggleListed: (l$toggleListed as bool?),
        updatePublicContact: l$updatePublicContact == null
            ? null
            : Mutation$UpdateVisibility$updatePublicContact.fromJson(
                (l$updatePublicContact as Map<String, dynamic>)),
        $__typename: (l$$__typename as String));
  }

  final bool? toggleListed;

  final Mutation$UpdateVisibility$updatePublicContact? updatePublicContact;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$toggleListed = toggleListed;
    _resultData['toggleListed'] = l$toggleListed;
    final l$updatePublicContact = updatePublicContact;
    _resultData['updatePublicContact'] = l$updatePublicContact?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$toggleListed = toggleListed;
    final l$updatePublicContact = updatePublicContact;
    final l$$__typename = $__typename;
    return Object.hashAll(
        [l$toggleListed, l$updatePublicContact, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Mutation$UpdateVisibility) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$toggleListed = toggleListed;
    final lOther$toggleListed = other.toggleListed;
    if (l$toggleListed != lOther$toggleListed) {
      return false;
    }
    final l$updatePublicContact = updatePublicContact;
    final lOther$updatePublicContact = other.updatePublicContact;
    if (l$updatePublicContact != lOther$updatePublicContact) {
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

extension UtilityExtension$Mutation$UpdateVisibility
    on Mutation$UpdateVisibility {
  CopyWith$Mutation$UpdateVisibility<Mutation$UpdateVisibility> get copyWith =>
      CopyWith$Mutation$UpdateVisibility(this, (i) => i);
}

abstract class CopyWith$Mutation$UpdateVisibility<TRes> {
  factory CopyWith$Mutation$UpdateVisibility(Mutation$UpdateVisibility instance,
          TRes Function(Mutation$UpdateVisibility) then) =
      _CopyWithImpl$Mutation$UpdateVisibility;

  factory CopyWith$Mutation$UpdateVisibility.stub(TRes res) =
      _CopyWithStubImpl$Mutation$UpdateVisibility;

  TRes call(
      {bool? toggleListed,
      Mutation$UpdateVisibility$updatePublicContact? updatePublicContact,
      String? $__typename});
  CopyWith$Mutation$UpdateVisibility$updatePublicContact<TRes>
      get updatePublicContact;
}

class _CopyWithImpl$Mutation$UpdateVisibility<TRes>
    implements CopyWith$Mutation$UpdateVisibility<TRes> {
  _CopyWithImpl$Mutation$UpdateVisibility(this._instance, this._then);

  final Mutation$UpdateVisibility _instance;

  final TRes Function(Mutation$UpdateVisibility) _then;

  static const _undefined = {};

  TRes call(
          {Object? toggleListed = _undefined,
          Object? updatePublicContact = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Mutation$UpdateVisibility(
          toggleListed: toggleListed == _undefined
              ? _instance.toggleListed
              : (toggleListed as bool?),
          updatePublicContact: updatePublicContact == _undefined
              ? _instance.updatePublicContact
              : (updatePublicContact
                  as Mutation$UpdateVisibility$updatePublicContact?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
  CopyWith$Mutation$UpdateVisibility$updatePublicContact<TRes>
      get updatePublicContact {
    final local$updatePublicContact = _instance.updatePublicContact;
    return local$updatePublicContact == null
        ? CopyWith$Mutation$UpdateVisibility$updatePublicContact.stub(
            _then(_instance))
        : CopyWith$Mutation$UpdateVisibility$updatePublicContact(
            local$updatePublicContact, (e) => call(updatePublicContact: e));
  }
}

class _CopyWithStubImpl$Mutation$UpdateVisibility<TRes>
    implements CopyWith$Mutation$UpdateVisibility<TRes> {
  _CopyWithStubImpl$Mutation$UpdateVisibility(this._res);

  TRes _res;

  call(
          {bool? toggleListed,
          Mutation$UpdateVisibility$updatePublicContact? updatePublicContact,
          String? $__typename}) =>
      _res;
  CopyWith$Mutation$UpdateVisibility$updatePublicContact<TRes>
      get updatePublicContact =>
          CopyWith$Mutation$UpdateVisibility$updatePublicContact.stub(_res);
}

const documentNodeMutationUpdateVisibility = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'UpdateVisibility'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'listed')),
            type: NamedTypeNode(
                name: NameNode(value: 'Boolean'), isNonNull: true),
            defaultValue: DefaultValueNode(value: null),
            directives: []),
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'contact')),
            type: NamedTypeNode(
                name: NameNode(value: 'IBooleanContact'), isNonNull: true),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'toggleListed'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'state'),
                  value: VariableNode(name: NameNode(value: 'listed')))
            ],
            directives: [],
            selectionSet: null),
        FieldNode(
            name: NameNode(value: 'updatePublicContact'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'contact'),
                  value: VariableNode(name: NameNode(value: 'contact')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'first_name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'last_name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'email'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'street'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'housenumber'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'housenumber_addition'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'city'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'zipcode'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'phone_primary'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null)
            ])),
        FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null)
      ])),
]);
Mutation$UpdateVisibility _parserFn$Mutation$UpdateVisibility(
        Map<String, dynamic> data) =>
    Mutation$UpdateVisibility.fromJson(data);
typedef OnMutationCompleted$Mutation$UpdateVisibility = FutureOr<void> Function(
    dynamic, Mutation$UpdateVisibility?);

class Options$Mutation$UpdateVisibility
    extends graphql.MutationOptions<Mutation$UpdateVisibility> {
  Options$Mutation$UpdateVisibility(
      {String? operationName,
      required Variables$Mutation$UpdateVisibility variables,
      graphql.FetchPolicy? fetchPolicy,
      graphql.ErrorPolicy? errorPolicy,
      graphql.CacheRereadPolicy? cacheRereadPolicy,
      Object? optimisticResult,
      graphql.Context? context,
      OnMutationCompleted$Mutation$UpdateVisibility? onCompleted,
      graphql.OnMutationUpdate<Mutation$UpdateVisibility>? update,
      graphql.OnError? onError})
      : onCompletedWithParsed = onCompleted,
        super(
            variables: variables.toJson(),
            operationName: operationName,
            fetchPolicy: fetchPolicy,
            errorPolicy: errorPolicy,
            cacheRereadPolicy: cacheRereadPolicy,
            optimisticResult: optimisticResult,
            context: context,
            onCompleted: onCompleted == null
                ? null
                : (data) => onCompleted(
                    data,
                    data == null
                        ? null
                        : _parserFn$Mutation$UpdateVisibility(data)),
            update: update,
            onError: onError,
            document: documentNodeMutationUpdateVisibility,
            parserFn: _parserFn$Mutation$UpdateVisibility);

  final OnMutationCompleted$Mutation$UpdateVisibility? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed
      ];
}

class WatchOptions$Mutation$UpdateVisibility
    extends graphql.WatchQueryOptions<Mutation$UpdateVisibility> {
  WatchOptions$Mutation$UpdateVisibility(
      {String? operationName,
      required Variables$Mutation$UpdateVisibility variables,
      graphql.FetchPolicy? fetchPolicy,
      graphql.ErrorPolicy? errorPolicy,
      graphql.CacheRereadPolicy? cacheRereadPolicy,
      Object? optimisticResult,
      graphql.Context? context,
      Duration? pollInterval,
      bool? eagerlyFetchResults,
      bool carryForwardDataOnException = true,
      bool fetchResults = false})
      : super(
            variables: variables.toJson(),
            operationName: operationName,
            fetchPolicy: fetchPolicy,
            errorPolicy: errorPolicy,
            cacheRereadPolicy: cacheRereadPolicy,
            optimisticResult: optimisticResult,
            context: context,
            document: documentNodeMutationUpdateVisibility,
            pollInterval: pollInterval,
            eagerlyFetchResults: eagerlyFetchResults,
            carryForwardDataOnException: carryForwardDataOnException,
            fetchResults: fetchResults,
            parserFn: _parserFn$Mutation$UpdateVisibility);
}

extension ClientExtension$Mutation$UpdateVisibility on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$UpdateVisibility>>
      mutate$UpdateVisibility(
              Options$Mutation$UpdateVisibility options) async =>
          await this.mutate(options);
  graphql.ObservableQuery<Mutation$UpdateVisibility>
      watchMutation$UpdateVisibility(
              WatchOptions$Mutation$UpdateVisibility options) =>
          this.watchMutation(options);
}

class Mutation$UpdateVisibility$HookResult {
  Mutation$UpdateVisibility$HookResult(this.runMutation, this.result);

  final RunMutation$Mutation$UpdateVisibility runMutation;

  final graphql.QueryResult<Mutation$UpdateVisibility> result;
}

Mutation$UpdateVisibility$HookResult useMutation$UpdateVisibility(
    [WidgetOptions$Mutation$UpdateVisibility? options]) {
  final result = graphql_flutter
      .useMutation(options ?? WidgetOptions$Mutation$UpdateVisibility());
  return Mutation$UpdateVisibility$HookResult(
    (variables, {optimisticResult}) => result.runMutation(
      variables.toJson(),
      optimisticResult: optimisticResult,
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation$UpdateVisibility>
    useWatchMutation$UpdateVisibility(
            WatchOptions$Mutation$UpdateVisibility options) =>
        graphql_flutter.useWatchMutation(options);

class WidgetOptions$Mutation$UpdateVisibility
    extends graphql.MutationOptions<Mutation$UpdateVisibility> {
  WidgetOptions$Mutation$UpdateVisibility(
      {String? operationName,
      graphql.FetchPolicy? fetchPolicy,
      graphql.ErrorPolicy? errorPolicy,
      graphql.CacheRereadPolicy? cacheRereadPolicy,
      Object? optimisticResult,
      graphql.Context? context,
      OnMutationCompleted$Mutation$UpdateVisibility? onCompleted,
      graphql.OnMutationUpdate<Mutation$UpdateVisibility>? update,
      graphql.OnError? onError})
      : onCompletedWithParsed = onCompleted,
        super(
            operationName: operationName,
            fetchPolicy: fetchPolicy,
            errorPolicy: errorPolicy,
            cacheRereadPolicy: cacheRereadPolicy,
            optimisticResult: optimisticResult,
            context: context,
            onCompleted: onCompleted == null
                ? null
                : (data) => onCompleted(
                    data,
                    data == null
                        ? null
                        : _parserFn$Mutation$UpdateVisibility(data)),
            update: update,
            onError: onError,
            document: documentNodeMutationUpdateVisibility,
            parserFn: _parserFn$Mutation$UpdateVisibility);

  final OnMutationCompleted$Mutation$UpdateVisibility? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onCompleted == null
            ? super.properties
            : super.properties.where((property) => property != onCompleted),
        onCompletedWithParsed
      ];
}

typedef RunMutation$Mutation$UpdateVisibility = graphql
        .MultiSourceResult<Mutation$UpdateVisibility>
    Function(Variables$Mutation$UpdateVisibility, {Object? optimisticResult});
typedef Builder$Mutation$UpdateVisibility = widgets.Widget Function(
    RunMutation$Mutation$UpdateVisibility,
    graphql.QueryResult<Mutation$UpdateVisibility>?);

class Mutation$UpdateVisibility$Widget
    extends graphql_flutter.Mutation<Mutation$UpdateVisibility> {
  Mutation$UpdateVisibility$Widget(
      {widgets.Key? key,
      WidgetOptions$Mutation$UpdateVisibility? options,
      required Builder$Mutation$UpdateVisibility builder})
      : super(
            key: key,
            options: options ?? WidgetOptions$Mutation$UpdateVisibility(),
            builder: (run, result) => builder(
                (variables, {optimisticResult}) =>
                    run(variables.toJson(), optimisticResult: optimisticResult),
                result));
}

class Mutation$UpdateVisibility$updatePublicContact {
  Mutation$UpdateVisibility$updatePublicContact(
      {this.first_name,
      this.last_name,
      this.email,
      this.street,
      this.housenumber,
      this.housenumber_addition,
      this.city,
      this.zipcode,
      this.phone_primary,
      required this.$__typename});

  factory Mutation$UpdateVisibility$updatePublicContact.fromJson(
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
    return Mutation$UpdateVisibility$updatePublicContact(
        first_name: (l$first_name as String?),
        last_name: (l$last_name as String?),
        email: (l$email as String?),
        street: (l$street as String?),
        housenumber: (l$housenumber as String?),
        housenumber_addition: (l$housenumber_addition as String?),
        city: (l$city as String?),
        zipcode: (l$zipcode as String?),
        phone_primary: (l$phone_primary as String?),
        $__typename: (l$$__typename as String));
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
      l$$__typename
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Mutation$UpdateVisibility$updatePublicContact) ||
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

extension UtilityExtension$Mutation$UpdateVisibility$updatePublicContact
    on Mutation$UpdateVisibility$updatePublicContact {
  CopyWith$Mutation$UpdateVisibility$updatePublicContact<
          Mutation$UpdateVisibility$updatePublicContact>
      get copyWith => CopyWith$Mutation$UpdateVisibility$updatePublicContact(
          this, (i) => i);
}

abstract class CopyWith$Mutation$UpdateVisibility$updatePublicContact<TRes> {
  factory CopyWith$Mutation$UpdateVisibility$updatePublicContact(
          Mutation$UpdateVisibility$updatePublicContact instance,
          TRes Function(Mutation$UpdateVisibility$updatePublicContact) then) =
      _CopyWithImpl$Mutation$UpdateVisibility$updatePublicContact;

  factory CopyWith$Mutation$UpdateVisibility$updatePublicContact.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$UpdateVisibility$updatePublicContact;

  TRes call(
      {String? first_name,
      String? last_name,
      String? email,
      String? street,
      String? housenumber,
      String? housenumber_addition,
      String? city,
      String? zipcode,
      String? phone_primary,
      String? $__typename});
}

class _CopyWithImpl$Mutation$UpdateVisibility$updatePublicContact<TRes>
    implements CopyWith$Mutation$UpdateVisibility$updatePublicContact<TRes> {
  _CopyWithImpl$Mutation$UpdateVisibility$updatePublicContact(
      this._instance, this._then);

  final Mutation$UpdateVisibility$updatePublicContact _instance;

  final TRes Function(Mutation$UpdateVisibility$updatePublicContact) _then;

  static const _undefined = {};

  TRes call(
          {Object? first_name = _undefined,
          Object? last_name = _undefined,
          Object? email = _undefined,
          Object? street = _undefined,
          Object? housenumber = _undefined,
          Object? housenumber_addition = _undefined,
          Object? city = _undefined,
          Object? zipcode = _undefined,
          Object? phone_primary = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Mutation$UpdateVisibility$updatePublicContact(
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
              : ($__typename as String)));
}

class _CopyWithStubImpl$Mutation$UpdateVisibility$updatePublicContact<TRes>
    implements CopyWith$Mutation$UpdateVisibility$updatePublicContact<TRes> {
  _CopyWithStubImpl$Mutation$UpdateVisibility$updatePublicContact(this._res);

  TRes _res;

  call(
          {String? first_name,
          String? last_name,
          String? email,
          String? street,
          String? housenumber,
          String? housenumber_addition,
          String? city,
          String? zipcode,
          String? phone_primary,
          String? $__typename}) =>
      _res;
}
