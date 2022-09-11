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
                  name: NameNode(value: 'fullContact'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
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
      required this.fullContact,
      required this.$__typename});

  factory Query$Me$me.fromJson(Map<String, dynamic> json) {
    final l$identifier = json['identifier'];
    final l$email = json['email'];
    final l$username = json['username'];
    final l$fullContact = json['fullContact'];
    final l$$__typename = json['__typename'];
    return Query$Me$me(
        identifier: (l$identifier as String),
        email: (l$email as String),
        username: (l$username as String),
        fullContact: Query$Me$me$fullContact.fromJson(
            (l$fullContact as Map<String, dynamic>)),
        $__typename: (l$$__typename as String));
  }

  final String identifier;

  final String email;

  final String username;

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
    return Object.hashAll(
        [l$identifier, l$email, l$username, l$fullContact, l$$__typename]);
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
          Query$Me$me$fullContact? fullContact,
          String? $__typename}) =>
      _res;
  CopyWith$Query$Me$me$fullContact<TRes> get fullContact =>
      CopyWith$Query$Me$me$fullContact.stub(_res);
}

class Query$Me$me$fullContact {
  Query$Me$me$fullContact(
      {this.private, this.update, required this.$__typename});

  factory Query$Me$me$fullContact.fromJson(Map<String, dynamic> json) {
    final l$private = json['private'];
    final l$update = json['update'];
    final l$$__typename = json['__typename'];
    return Query$Me$me$fullContact(
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

  final Query$Me$me$fullContact$private? private;

  final Query$Me$me$fullContact$update? update;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
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
    final l$private = private;
    final l$update = update;
    final l$$__typename = $__typename;
    return Object.hashAll([l$private, l$update, l$$__typename]);
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
      {Query$Me$me$fullContact$private? private,
      Query$Me$me$fullContact$update? update,
      String? $__typename});
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
          {Object? private = _undefined,
          Object? update = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$Me$me$fullContact(
          private: private == _undefined
              ? _instance.private
              : (private as Query$Me$me$fullContact$private?),
          update: update == _undefined
              ? _instance.update
              : (update as Query$Me$me$fullContact$update?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
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
          {Query$Me$me$fullContact$private? private,
          Query$Me$me$fullContact$update? update,
          String? $__typename}) =>
      _res;
  CopyWith$Query$Me$me$fullContact$private<TRes> get private =>
      CopyWith$Query$Me$me$fullContact$private.stub(_res);
  CopyWith$Query$Me$me$fullContact$update<TRes> get update =>
      CopyWith$Query$Me$me$fullContact$update.stub(_res);
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
