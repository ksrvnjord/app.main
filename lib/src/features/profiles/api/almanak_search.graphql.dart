import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables$Query$AlmanakSearch {
  factory Variables$Query$AlmanakSearch(
          {required String search, required int first, required int page}) =>
      Variables$Query$AlmanakSearch._({
        r'search': search,
        r'first': first,
        r'page': page,
      });

  Variables$Query$AlmanakSearch._(this._$data);

  factory Variables$Query$AlmanakSearch.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$search = data['search'];
    result$data['search'] = (l$search as String);
    final l$first = data['first'];
    result$data['first'] = (l$first as int);
    final l$page = data['page'];
    result$data['page'] = (l$page as int);
    return Variables$Query$AlmanakSearch._(result$data);
  }

  Map<String, dynamic> _$data;

  String get search => (_$data['search'] as String);
  int get first => (_$data['first'] as int);
  int get page => (_$data['page'] as int);
  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$search = search;
    result$data['search'] = l$search;
    final l$first = first;
    result$data['first'] = l$first;
    final l$page = page;
    result$data['page'] = l$page;
    return result$data;
  }

  CopyWith$Variables$Query$AlmanakSearch<Variables$Query$AlmanakSearch>
      get copyWith => CopyWith$Variables$Query$AlmanakSearch(this, (i) => i);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Variables$Query$AlmanakSearch) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$search = search;
    final lOther$search = other.search;
    if (l$search != lOther$search) {
      return false;
    }
    final l$first = first;
    final lOther$first = other.first;
    if (l$first != lOther$first) {
      return false;
    }
    final l$page = page;
    final lOther$page = other.page;
    if (l$page != lOther$page) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$search = search;
    final l$first = first;
    final l$page = page;
    return Object.hashAll([l$search, l$first, l$page]);
  }
}

abstract class CopyWith$Variables$Query$AlmanakSearch<TRes> {
  factory CopyWith$Variables$Query$AlmanakSearch(
          Variables$Query$AlmanakSearch instance,
          TRes Function(Variables$Query$AlmanakSearch) then) =
      _CopyWithImpl$Variables$Query$AlmanakSearch;

  factory CopyWith$Variables$Query$AlmanakSearch.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$AlmanakSearch;

  TRes call({String? search, int? first, int? page});
}

class _CopyWithImpl$Variables$Query$AlmanakSearch<TRes>
    implements CopyWith$Variables$Query$AlmanakSearch<TRes> {
  _CopyWithImpl$Variables$Query$AlmanakSearch(this._instance, this._then);

  final Variables$Query$AlmanakSearch _instance;

  final TRes Function(Variables$Query$AlmanakSearch) _then;

  static const _undefined = {};

  TRes call(
          {Object? search = _undefined,
          Object? first = _undefined,
          Object? page = _undefined}) =>
      _then(Variables$Query$AlmanakSearch._({
        ..._instance._$data,
        if (search != _undefined && search != null)
          'search': (search as String),
        if (first != _undefined && first != null) 'first': (first as int),
        if (page != _undefined && page != null) 'page': (page as int),
      }));
}

class _CopyWithStubImpl$Variables$Query$AlmanakSearch<TRes>
    implements CopyWith$Variables$Query$AlmanakSearch<TRes> {
  _CopyWithStubImpl$Variables$Query$AlmanakSearch(this._res);

  TRes _res;

  call({String? search, int? first, int? page}) => _res;
}

class Query$AlmanakSearch {
  Query$AlmanakSearch({this.users, required this.$__typename});

  factory Query$AlmanakSearch.fromJson(Map<String, dynamic> json) {
    final l$users = json['users'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakSearch(
        users: l$users == null
            ? null
            : Query$AlmanakSearch$users.fromJson(
                (l$users as Map<String, dynamic>)),
        $__typename: (l$$__typename as String));
  }

  final Query$AlmanakSearch$users? users;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$users = users;
    _resultData['users'] = l$users?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$users = users;
    final l$$__typename = $__typename;
    return Object.hashAll([l$users, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$AlmanakSearch) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$users = users;
    final lOther$users = other.users;
    if (l$users != lOther$users) {
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

extension UtilityExtension$Query$AlmanakSearch on Query$AlmanakSearch {
  CopyWith$Query$AlmanakSearch<Query$AlmanakSearch> get copyWith =>
      CopyWith$Query$AlmanakSearch(this, (i) => i);
}

abstract class CopyWith$Query$AlmanakSearch<TRes> {
  factory CopyWith$Query$AlmanakSearch(Query$AlmanakSearch instance,
          TRes Function(Query$AlmanakSearch) then) =
      _CopyWithImpl$Query$AlmanakSearch;

  factory CopyWith$Query$AlmanakSearch.stub(TRes res) =
      _CopyWithStubImpl$Query$AlmanakSearch;

  TRes call({Query$AlmanakSearch$users? users, String? $__typename});
  CopyWith$Query$AlmanakSearch$users<TRes> get users;
}

class _CopyWithImpl$Query$AlmanakSearch<TRes>
    implements CopyWith$Query$AlmanakSearch<TRes> {
  _CopyWithImpl$Query$AlmanakSearch(this._instance, this._then);

  final Query$AlmanakSearch _instance;

  final TRes Function(Query$AlmanakSearch) _then;

  static const _undefined = {};

  TRes call({Object? users = _undefined, Object? $__typename = _undefined}) =>
      _then(Query$AlmanakSearch(
          users: users == _undefined
              ? _instance.users
              : (users as Query$AlmanakSearch$users?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
  CopyWith$Query$AlmanakSearch$users<TRes> get users {
    final local$users = _instance.users;
    return local$users == null
        ? CopyWith$Query$AlmanakSearch$users.stub(_then(_instance))
        : CopyWith$Query$AlmanakSearch$users(
            local$users, (e) => call(users: e));
  }
}

class _CopyWithStubImpl$Query$AlmanakSearch<TRes>
    implements CopyWith$Query$AlmanakSearch<TRes> {
  _CopyWithStubImpl$Query$AlmanakSearch(this._res);

  TRes _res;

  call({Query$AlmanakSearch$users? users, String? $__typename}) => _res;
  CopyWith$Query$AlmanakSearch$users<TRes> get users =>
      CopyWith$Query$AlmanakSearch$users.stub(_res);
}

const documentNodeQueryAlmanakSearch = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'AlmanakSearch'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'search')),
            type:
                NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
            defaultValue: DefaultValueNode(value: null),
            directives: []),
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'first')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
            defaultValue: DefaultValueNode(value: null),
            directives: []),
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'page')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'users'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'search'),
                  value: VariableNode(name: NameNode(value: 'search'))),
              ArgumentNode(
                  name: NameNode(value: 'first'),
                  value: VariableNode(name: NameNode(value: 'first'))),
              ArgumentNode(
                  name: NameNode(value: 'page'),
                  value: VariableNode(name: NameNode(value: 'page')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'paginatorInfo'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'hasMorePages'),
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
                  name: NameNode(value: 'data'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'id'),
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
        FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null)
      ])),
]);
Query$AlmanakSearch _parserFn$Query$AlmanakSearch(Map<String, dynamic> data) =>
    Query$AlmanakSearch.fromJson(data);

class Options$Query$AlmanakSearch
    extends graphql.QueryOptions<Query$AlmanakSearch> {
  Options$Query$AlmanakSearch(
      {String? operationName,
      required Variables$Query$AlmanakSearch variables,
      graphql.FetchPolicy? fetchPolicy,
      graphql.ErrorPolicy? errorPolicy,
      graphql.CacheRereadPolicy? cacheRereadPolicy,
      Object? optimisticResult,
      Duration? pollInterval,
      graphql.Context? context})
      : super(
            variables: variables.toJson(),
            operationName: operationName,
            fetchPolicy: fetchPolicy,
            errorPolicy: errorPolicy,
            cacheRereadPolicy: cacheRereadPolicy,
            optimisticResult: optimisticResult,
            pollInterval: pollInterval,
            context: context,
            document: documentNodeQueryAlmanakSearch,
            parserFn: _parserFn$Query$AlmanakSearch);
}

class WatchOptions$Query$AlmanakSearch
    extends graphql.WatchQueryOptions<Query$AlmanakSearch> {
  WatchOptions$Query$AlmanakSearch(
      {String? operationName,
      required Variables$Query$AlmanakSearch variables,
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
            document: documentNodeQueryAlmanakSearch,
            pollInterval: pollInterval,
            eagerlyFetchResults: eagerlyFetchResults,
            carryForwardDataOnException: carryForwardDataOnException,
            fetchResults: fetchResults,
            parserFn: _parserFn$Query$AlmanakSearch);
}

class FetchMoreOptions$Query$AlmanakSearch extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$AlmanakSearch(
      {required graphql.UpdateQuery updateQuery,
      required Variables$Query$AlmanakSearch variables})
      : super(
            updateQuery: updateQuery,
            variables: variables.toJson(),
            document: documentNodeQueryAlmanakSearch);
}

extension ClientExtension$Query$AlmanakSearch on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$AlmanakSearch>> query$AlmanakSearch(
          Options$Query$AlmanakSearch options) async =>
      await this.query(options);
  graphql.ObservableQuery<Query$AlmanakSearch> watchQuery$AlmanakSearch(
          WatchOptions$Query$AlmanakSearch options) =>
      this.watchQuery(options);
  void writeQuery$AlmanakSearch(
          {required Query$AlmanakSearch data,
          required Variables$Query$AlmanakSearch variables,
          bool broadcast = true}) =>
      this.writeQuery(
          graphql.Request(
              operation:
                  graphql.Operation(document: documentNodeQueryAlmanakSearch),
              variables: variables.toJson()),
          data: data.toJson(),
          broadcast: broadcast);
  Query$AlmanakSearch? readQuery$AlmanakSearch(
      {required Variables$Query$AlmanakSearch variables,
      bool optimistic = true}) {
    final result = this.readQuery(
        graphql.Request(
            operation:
                graphql.Operation(document: documentNodeQueryAlmanakSearch),
            variables: variables.toJson()),
        optimistic: optimistic);
    return result == null ? null : Query$AlmanakSearch.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$AlmanakSearch> useQuery$AlmanakSearch(
        Options$Query$AlmanakSearch options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$AlmanakSearch> useWatchQuery$AlmanakSearch(
        WatchOptions$Query$AlmanakSearch options) =>
    graphql_flutter.useWatchQuery(options);

class Query$AlmanakSearch$Widget
    extends graphql_flutter.Query<Query$AlmanakSearch> {
  Query$AlmanakSearch$Widget(
      {widgets.Key? key,
      required Options$Query$AlmanakSearch options,
      required graphql_flutter.QueryBuilder<Query$AlmanakSearch> builder})
      : super(key: key, options: options, builder: builder);
}

class Query$AlmanakSearch$users {
  Query$AlmanakSearch$users(
      {required this.paginatorInfo,
      required this.data,
      required this.$__typename});

  factory Query$AlmanakSearch$users.fromJson(Map<String, dynamic> json) {
    final l$paginatorInfo = json['paginatorInfo'];
    final l$data = json['data'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakSearch$users(
        paginatorInfo: Query$AlmanakSearch$users$paginatorInfo.fromJson(
            (l$paginatorInfo as Map<String, dynamic>)),
        data: (l$data as List<dynamic>)
            .map((e) => Query$AlmanakSearch$users$data.fromJson(
                (e as Map<String, dynamic>)))
            .toList(),
        $__typename: (l$$__typename as String));
  }

  final Query$AlmanakSearch$users$paginatorInfo paginatorInfo;

  final List<Query$AlmanakSearch$users$data> data;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$paginatorInfo = paginatorInfo;
    _resultData['paginatorInfo'] = l$paginatorInfo.toJson();
    final l$data = data;
    _resultData['data'] = l$data.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$paginatorInfo = paginatorInfo;
    final l$data = data;
    final l$$__typename = $__typename;
    return Object.hashAll(
        [l$paginatorInfo, Object.hashAll(l$data.map((v) => v)), l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$AlmanakSearch$users) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$paginatorInfo = paginatorInfo;
    final lOther$paginatorInfo = other.paginatorInfo;
    if (l$paginatorInfo != lOther$paginatorInfo) {
      return false;
    }
    final l$data = data;
    final lOther$data = other.data;
    if (l$data.length != lOther$data.length) {
      return false;
    }
    for (int i = 0; i < l$data.length; i++) {
      final l$data$entry = l$data[i];
      final lOther$data$entry = lOther$data[i];
      if (l$data$entry != lOther$data$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$AlmanakSearch$users
    on Query$AlmanakSearch$users {
  CopyWith$Query$AlmanakSearch$users<Query$AlmanakSearch$users> get copyWith =>
      CopyWith$Query$AlmanakSearch$users(this, (i) => i);
}

abstract class CopyWith$Query$AlmanakSearch$users<TRes> {
  factory CopyWith$Query$AlmanakSearch$users(Query$AlmanakSearch$users instance,
          TRes Function(Query$AlmanakSearch$users) then) =
      _CopyWithImpl$Query$AlmanakSearch$users;

  factory CopyWith$Query$AlmanakSearch$users.stub(TRes res) =
      _CopyWithStubImpl$Query$AlmanakSearch$users;

  TRes call(
      {Query$AlmanakSearch$users$paginatorInfo? paginatorInfo,
      List<Query$AlmanakSearch$users$data>? data,
      String? $__typename});
  CopyWith$Query$AlmanakSearch$users$paginatorInfo<TRes> get paginatorInfo;
  TRes data(
      Iterable<Query$AlmanakSearch$users$data> Function(
              Iterable<
                  CopyWith$Query$AlmanakSearch$users$data<
                      Query$AlmanakSearch$users$data>>)
          _fn);
}

class _CopyWithImpl$Query$AlmanakSearch$users<TRes>
    implements CopyWith$Query$AlmanakSearch$users<TRes> {
  _CopyWithImpl$Query$AlmanakSearch$users(this._instance, this._then);

  final Query$AlmanakSearch$users _instance;

  final TRes Function(Query$AlmanakSearch$users) _then;

  static const _undefined = {};

  TRes call(
          {Object? paginatorInfo = _undefined,
          Object? data = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$AlmanakSearch$users(
          paginatorInfo: paginatorInfo == _undefined || paginatorInfo == null
              ? _instance.paginatorInfo
              : (paginatorInfo as Query$AlmanakSearch$users$paginatorInfo),
          data: data == _undefined || data == null
              ? _instance.data
              : (data as List<Query$AlmanakSearch$users$data>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
  CopyWith$Query$AlmanakSearch$users$paginatorInfo<TRes> get paginatorInfo {
    final local$paginatorInfo = _instance.paginatorInfo;
    return CopyWith$Query$AlmanakSearch$users$paginatorInfo(
        local$paginatorInfo, (e) => call(paginatorInfo: e));
  }

  TRes data(
          Iterable<Query$AlmanakSearch$users$data> Function(
                  Iterable<
                      CopyWith$Query$AlmanakSearch$users$data<
                          Query$AlmanakSearch$users$data>>)
              _fn) =>
      call(
          data: _fn(_instance.data.map(
                  (e) => CopyWith$Query$AlmanakSearch$users$data(e, (i) => i)))
              .toList());
}

class _CopyWithStubImpl$Query$AlmanakSearch$users<TRes>
    implements CopyWith$Query$AlmanakSearch$users<TRes> {
  _CopyWithStubImpl$Query$AlmanakSearch$users(this._res);

  TRes _res;

  call(
          {Query$AlmanakSearch$users$paginatorInfo? paginatorInfo,
          List<Query$AlmanakSearch$users$data>? data,
          String? $__typename}) =>
      _res;
  CopyWith$Query$AlmanakSearch$users$paginatorInfo<TRes> get paginatorInfo =>
      CopyWith$Query$AlmanakSearch$users$paginatorInfo.stub(_res);
  data(_fn) => _res;
}

class Query$AlmanakSearch$users$paginatorInfo {
  Query$AlmanakSearch$users$paginatorInfo(
      {required this.hasMorePages, required this.$__typename});

  factory Query$AlmanakSearch$users$paginatorInfo.fromJson(
      Map<String, dynamic> json) {
    final l$hasMorePages = json['hasMorePages'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakSearch$users$paginatorInfo(
        hasMorePages: (l$hasMorePages as bool),
        $__typename: (l$$__typename as String));
  }

  final bool hasMorePages;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$hasMorePages = hasMorePages;
    _resultData['hasMorePages'] = l$hasMorePages;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$hasMorePages = hasMorePages;
    final l$$__typename = $__typename;
    return Object.hashAll([l$hasMorePages, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$AlmanakSearch$users$paginatorInfo) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$hasMorePages = hasMorePages;
    final lOther$hasMorePages = other.hasMorePages;
    if (l$hasMorePages != lOther$hasMorePages) {
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

extension UtilityExtension$Query$AlmanakSearch$users$paginatorInfo
    on Query$AlmanakSearch$users$paginatorInfo {
  CopyWith$Query$AlmanakSearch$users$paginatorInfo<
          Query$AlmanakSearch$users$paginatorInfo>
      get copyWith =>
          CopyWith$Query$AlmanakSearch$users$paginatorInfo(this, (i) => i);
}

abstract class CopyWith$Query$AlmanakSearch$users$paginatorInfo<TRes> {
  factory CopyWith$Query$AlmanakSearch$users$paginatorInfo(
          Query$AlmanakSearch$users$paginatorInfo instance,
          TRes Function(Query$AlmanakSearch$users$paginatorInfo) then) =
      _CopyWithImpl$Query$AlmanakSearch$users$paginatorInfo;

  factory CopyWith$Query$AlmanakSearch$users$paginatorInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$AlmanakSearch$users$paginatorInfo;

  TRes call({bool? hasMorePages, String? $__typename});
}

class _CopyWithImpl$Query$AlmanakSearch$users$paginatorInfo<TRes>
    implements CopyWith$Query$AlmanakSearch$users$paginatorInfo<TRes> {
  _CopyWithImpl$Query$AlmanakSearch$users$paginatorInfo(
      this._instance, this._then);

  final Query$AlmanakSearch$users$paginatorInfo _instance;

  final TRes Function(Query$AlmanakSearch$users$paginatorInfo) _then;

  static const _undefined = {};

  TRes call(
          {Object? hasMorePages = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$AlmanakSearch$users$paginatorInfo(
          hasMorePages: hasMorePages == _undefined || hasMorePages == null
              ? _instance.hasMorePages
              : (hasMorePages as bool),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
}

class _CopyWithStubImpl$Query$AlmanakSearch$users$paginatorInfo<TRes>
    implements CopyWith$Query$AlmanakSearch$users$paginatorInfo<TRes> {
  _CopyWithStubImpl$Query$AlmanakSearch$users$paginatorInfo(this._res);

  TRes _res;

  call({bool? hasMorePages, String? $__typename}) => _res;
}

class Query$AlmanakSearch$users$data {
  Query$AlmanakSearch$users$data(
      {required this.id,
      required this.email,
      required this.username,
      required this.fullContact,
      required this.$__typename});

  factory Query$AlmanakSearch$users$data.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$email = json['email'];
    final l$username = json['username'];
    final l$fullContact = json['fullContact'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakSearch$users$data(
        id: (l$id as String),
        email: (l$email as String),
        username: (l$username as String),
        fullContact: Query$AlmanakSearch$users$data$fullContact.fromJson(
            (l$fullContact as Map<String, dynamic>)),
        $__typename: (l$$__typename as String));
  }

  final String id;

  final String email;

  final String username;

  final Query$AlmanakSearch$users$data$fullContact fullContact;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
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
    final l$email = email;
    final l$username = username;
    final l$fullContact = fullContact;
    final l$$__typename = $__typename;
    return Object.hashAll(
        [l$id, l$email, l$username, l$fullContact, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$AlmanakSearch$users$data) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Query$AlmanakSearch$users$data
    on Query$AlmanakSearch$users$data {
  CopyWith$Query$AlmanakSearch$users$data<Query$AlmanakSearch$users$data>
      get copyWith => CopyWith$Query$AlmanakSearch$users$data(this, (i) => i);
}

abstract class CopyWith$Query$AlmanakSearch$users$data<TRes> {
  factory CopyWith$Query$AlmanakSearch$users$data(
          Query$AlmanakSearch$users$data instance,
          TRes Function(Query$AlmanakSearch$users$data) then) =
      _CopyWithImpl$Query$AlmanakSearch$users$data;

  factory CopyWith$Query$AlmanakSearch$users$data.stub(TRes res) =
      _CopyWithStubImpl$Query$AlmanakSearch$users$data;

  TRes call(
      {String? id,
      String? email,
      String? username,
      Query$AlmanakSearch$users$data$fullContact? fullContact,
      String? $__typename});
  CopyWith$Query$AlmanakSearch$users$data$fullContact<TRes> get fullContact;
}

class _CopyWithImpl$Query$AlmanakSearch$users$data<TRes>
    implements CopyWith$Query$AlmanakSearch$users$data<TRes> {
  _CopyWithImpl$Query$AlmanakSearch$users$data(this._instance, this._then);

  final Query$AlmanakSearch$users$data _instance;

  final TRes Function(Query$AlmanakSearch$users$data) _then;

  static const _undefined = {};

  TRes call(
          {Object? id = _undefined,
          Object? email = _undefined,
          Object? username = _undefined,
          Object? fullContact = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$AlmanakSearch$users$data(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          email: email == _undefined || email == null
              ? _instance.email
              : (email as String),
          username: username == _undefined || username == null
              ? _instance.username
              : (username as String),
          fullContact: fullContact == _undefined || fullContact == null
              ? _instance.fullContact
              : (fullContact as Query$AlmanakSearch$users$data$fullContact),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
  CopyWith$Query$AlmanakSearch$users$data$fullContact<TRes> get fullContact {
    final local$fullContact = _instance.fullContact;
    return CopyWith$Query$AlmanakSearch$users$data$fullContact(
        local$fullContact, (e) => call(fullContact: e));
  }
}

class _CopyWithStubImpl$Query$AlmanakSearch$users$data<TRes>
    implements CopyWith$Query$AlmanakSearch$users$data<TRes> {
  _CopyWithStubImpl$Query$AlmanakSearch$users$data(this._res);

  TRes _res;

  call(
          {String? id,
          String? email,
          String? username,
          Query$AlmanakSearch$users$data$fullContact? fullContact,
          String? $__typename}) =>
      _res;
  CopyWith$Query$AlmanakSearch$users$data$fullContact<TRes> get fullContact =>
      CopyWith$Query$AlmanakSearch$users$data$fullContact.stub(_res);
}

class Query$AlmanakSearch$users$data$fullContact {
  Query$AlmanakSearch$users$data$fullContact(
      {required this.public, required this.$__typename});

  factory Query$AlmanakSearch$users$data$fullContact.fromJson(
      Map<String, dynamic> json) {
    final l$public = json['public'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakSearch$users$data$fullContact(
        public: Query$AlmanakSearch$users$data$fullContact$public.fromJson(
            (l$public as Map<String, dynamic>)),
        $__typename: (l$$__typename as String));
  }

  final Query$AlmanakSearch$users$data$fullContact$public public;

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
    return Object.hashAll([l$public, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$AlmanakSearch$users$data$fullContact) ||
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

extension UtilityExtension$Query$AlmanakSearch$users$data$fullContact
    on Query$AlmanakSearch$users$data$fullContact {
  CopyWith$Query$AlmanakSearch$users$data$fullContact<
          Query$AlmanakSearch$users$data$fullContact>
      get copyWith =>
          CopyWith$Query$AlmanakSearch$users$data$fullContact(this, (i) => i);
}

abstract class CopyWith$Query$AlmanakSearch$users$data$fullContact<TRes> {
  factory CopyWith$Query$AlmanakSearch$users$data$fullContact(
          Query$AlmanakSearch$users$data$fullContact instance,
          TRes Function(Query$AlmanakSearch$users$data$fullContact) then) =
      _CopyWithImpl$Query$AlmanakSearch$users$data$fullContact;

  factory CopyWith$Query$AlmanakSearch$users$data$fullContact.stub(TRes res) =
      _CopyWithStubImpl$Query$AlmanakSearch$users$data$fullContact;

  TRes call(
      {Query$AlmanakSearch$users$data$fullContact$public? public,
      String? $__typename});
  CopyWith$Query$AlmanakSearch$users$data$fullContact$public<TRes> get public;
}

class _CopyWithImpl$Query$AlmanakSearch$users$data$fullContact<TRes>
    implements CopyWith$Query$AlmanakSearch$users$data$fullContact<TRes> {
  _CopyWithImpl$Query$AlmanakSearch$users$data$fullContact(
      this._instance, this._then);

  final Query$AlmanakSearch$users$data$fullContact _instance;

  final TRes Function(Query$AlmanakSearch$users$data$fullContact) _then;

  static const _undefined = {};

  TRes call({Object? public = _undefined, Object? $__typename = _undefined}) =>
      _then(Query$AlmanakSearch$users$data$fullContact(
          public: public == _undefined || public == null
              ? _instance.public
              : (public as Query$AlmanakSearch$users$data$fullContact$public),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
  CopyWith$Query$AlmanakSearch$users$data$fullContact$public<TRes> get public {
    final local$public = _instance.public;
    return CopyWith$Query$AlmanakSearch$users$data$fullContact$public(
        local$public, (e) => call(public: e));
  }
}

class _CopyWithStubImpl$Query$AlmanakSearch$users$data$fullContact<TRes>
    implements CopyWith$Query$AlmanakSearch$users$data$fullContact<TRes> {
  _CopyWithStubImpl$Query$AlmanakSearch$users$data$fullContact(this._res);

  TRes _res;

  call(
          {Query$AlmanakSearch$users$data$fullContact$public? public,
          String? $__typename}) =>
      _res;
  CopyWith$Query$AlmanakSearch$users$data$fullContact$public<TRes> get public =>
      CopyWith$Query$AlmanakSearch$users$data$fullContact$public.stub(_res);
}

class Query$AlmanakSearch$users$data$fullContact$public {
  Query$AlmanakSearch$users$data$fullContact$public(
      {this.first_name, this.last_name, required this.$__typename});

  factory Query$AlmanakSearch$users$data$fullContact$public.fromJson(
      Map<String, dynamic> json) {
    final l$first_name = json['first_name'];
    final l$last_name = json['last_name'];
    final l$$__typename = json['__typename'];
    return Query$AlmanakSearch$users$data$fullContact$public(
        first_name: (l$first_name as String?),
        last_name: (l$last_name as String?),
        $__typename: (l$$__typename as String));
  }

  final String? first_name;

  final String? last_name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$first_name = first_name;
    _resultData['first_name'] = l$first_name;
    final l$last_name = last_name;
    _resultData['last_name'] = l$last_name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$first_name = first_name;
    final l$last_name = last_name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$first_name, l$last_name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$AlmanakSearch$users$data$fullContact$public) ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$AlmanakSearch$users$data$fullContact$public
    on Query$AlmanakSearch$users$data$fullContact$public {
  CopyWith$Query$AlmanakSearch$users$data$fullContact$public<
          Query$AlmanakSearch$users$data$fullContact$public>
      get copyWith =>
          CopyWith$Query$AlmanakSearch$users$data$fullContact$public(
              this, (i) => i);
}

abstract class CopyWith$Query$AlmanakSearch$users$data$fullContact$public<
    TRes> {
  factory CopyWith$Query$AlmanakSearch$users$data$fullContact$public(
          Query$AlmanakSearch$users$data$fullContact$public instance,
          TRes Function(Query$AlmanakSearch$users$data$fullContact$public)
              then) =
      _CopyWithImpl$Query$AlmanakSearch$users$data$fullContact$public;

  factory CopyWith$Query$AlmanakSearch$users$data$fullContact$public.stub(
          TRes res) =
      _CopyWithStubImpl$Query$AlmanakSearch$users$data$fullContact$public;

  TRes call({String? first_name, String? last_name, String? $__typename});
}

class _CopyWithImpl$Query$AlmanakSearch$users$data$fullContact$public<TRes>
    implements
        CopyWith$Query$AlmanakSearch$users$data$fullContact$public<TRes> {
  _CopyWithImpl$Query$AlmanakSearch$users$data$fullContact$public(
      this._instance, this._then);

  final Query$AlmanakSearch$users$data$fullContact$public _instance;

  final TRes Function(Query$AlmanakSearch$users$data$fullContact$public) _then;

  static const _undefined = {};

  TRes call(
          {Object? first_name = _undefined,
          Object? last_name = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$AlmanakSearch$users$data$fullContact$public(
          first_name: first_name == _undefined
              ? _instance.first_name
              : (first_name as String?),
          last_name: last_name == _undefined
              ? _instance.last_name
              : (last_name as String?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
}

class _CopyWithStubImpl$Query$AlmanakSearch$users$data$fullContact$public<TRes>
    implements
        CopyWith$Query$AlmanakSearch$users$data$fullContact$public<TRes> {
  _CopyWithStubImpl$Query$AlmanakSearch$users$data$fullContact$public(
      this._res);

  TRes _res;

  call({String? first_name, String? last_name, String? $__typename}) => _res;
}
