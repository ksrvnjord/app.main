import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables$Query$Announcements {
  factory Variables$Query$Announcements({int? page}) =>
      Variables$Query$Announcements._({
        if (page != null) r'page': page,
      });

  Variables$Query$Announcements._(this._$data);

  factory Variables$Query$Announcements.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    return Variables$Query$Announcements._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get page => (_$data['page'] as int?);
  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('page')) {
      final l$page = page;
      result$data['page'] = l$page;
    }
    return result$data;
  }

  CopyWith$Variables$Query$Announcements<Variables$Query$Announcements>
      get copyWith => CopyWith$Variables$Query$Announcements(this, (i) => i);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Variables$Query$Announcements) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$page = page;
    final lOther$page = other.page;
    if (_$data.containsKey('page') != other._$data.containsKey('page')) {
      return false;
    }
    if (l$page != lOther$page) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$page = page;
    return Object.hashAll([_$data.containsKey('page') ? l$page : const {}]);
  }
}

abstract class CopyWith$Variables$Query$Announcements<TRes> {
  factory CopyWith$Variables$Query$Announcements(
          Variables$Query$Announcements instance,
          TRes Function(Variables$Query$Announcements) then) =
      _CopyWithImpl$Variables$Query$Announcements;

  factory CopyWith$Variables$Query$Announcements.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$Announcements;

  TRes call({int? page});
}

class _CopyWithImpl$Variables$Query$Announcements<TRes>
    implements CopyWith$Variables$Query$Announcements<TRes> {
  _CopyWithImpl$Variables$Query$Announcements(this._instance, this._then);

  final Variables$Query$Announcements _instance;

  final TRes Function(Variables$Query$Announcements) _then;

  static const _undefined = {};

  TRes call({Object? page = _undefined}) =>
      _then(Variables$Query$Announcements._({
        ..._instance._$data,
        if (page != _undefined) 'page': (page as int?),
      }));
}

class _CopyWithStubImpl$Variables$Query$Announcements<TRes>
    implements CopyWith$Variables$Query$Announcements<TRes> {
  _CopyWithStubImpl$Variables$Query$Announcements(this._res);

  TRes _res;

  call({int? page}) => _res;
}

class Query$Announcements {
  Query$Announcements({this.announcements, required this.$__typename});

  factory Query$Announcements.fromJson(Map<String, dynamic> json) {
    final l$announcements = json['announcements'];
    final l$$__typename = json['__typename'];
    return Query$Announcements(
        announcements: l$announcements == null
            ? null
            : Query$Announcements$announcements.fromJson(
                (l$announcements as Map<String, dynamic>)),
        $__typename: (l$$__typename as String));
  }

  final Query$Announcements$announcements? announcements;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$announcements = announcements;
    _resultData['announcements'] = l$announcements?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$announcements = announcements;
    final l$$__typename = $__typename;
    return Object.hashAll([l$announcements, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Announcements) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$announcements = announcements;
    final lOther$announcements = other.announcements;
    if (l$announcements != lOther$announcements) {
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

extension UtilityExtension$Query$Announcements on Query$Announcements {
  CopyWith$Query$Announcements<Query$Announcements> get copyWith =>
      CopyWith$Query$Announcements(this, (i) => i);
}

abstract class CopyWith$Query$Announcements<TRes> {
  factory CopyWith$Query$Announcements(Query$Announcements instance,
          TRes Function(Query$Announcements) then) =
      _CopyWithImpl$Query$Announcements;

  factory CopyWith$Query$Announcements.stub(TRes res) =
      _CopyWithStubImpl$Query$Announcements;

  TRes call(
      {Query$Announcements$announcements? announcements, String? $__typename});
  CopyWith$Query$Announcements$announcements<TRes> get announcements;
}

class _CopyWithImpl$Query$Announcements<TRes>
    implements CopyWith$Query$Announcements<TRes> {
  _CopyWithImpl$Query$Announcements(this._instance, this._then);

  final Query$Announcements _instance;

  final TRes Function(Query$Announcements) _then;

  static const _undefined = {};

  TRes call(
          {Object? announcements = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$Announcements(
          announcements: announcements == _undefined
              ? _instance.announcements
              : (announcements as Query$Announcements$announcements?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
  CopyWith$Query$Announcements$announcements<TRes> get announcements {
    final local$announcements = _instance.announcements;
    return local$announcements == null
        ? CopyWith$Query$Announcements$announcements.stub(_then(_instance))
        : CopyWith$Query$Announcements$announcements(
            local$announcements, (e) => call(announcements: e));
  }
}

class _CopyWithStubImpl$Query$Announcements<TRes>
    implements CopyWith$Query$Announcements<TRes> {
  _CopyWithStubImpl$Query$Announcements(this._res);

  TRes _res;

  call(
          {Query$Announcements$announcements? announcements,
          String? $__typename}) =>
      _res;
  CopyWith$Query$Announcements$announcements<TRes> get announcements =>
      CopyWith$Query$Announcements$announcements.stub(_res);
}

const documentNodeQueryAnnouncements = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Announcements'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'page')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'announcements'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'page'),
                  value: VariableNode(name: NameNode(value: 'page')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'data'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'author'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'created_at'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'title'),
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
                  name: NameNode(value: 'paginatorInfo'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'lastPage'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'currentPage'),
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
]);
Query$Announcements _parserFn$Query$Announcements(Map<String, dynamic> data) =>
    Query$Announcements.fromJson(data);

class Options$Query$Announcements
    extends graphql.QueryOptions<Query$Announcements> {
  Options$Query$Announcements(
      {String? operationName,
      Variables$Query$Announcements? variables,
      graphql.FetchPolicy? fetchPolicy,
      graphql.ErrorPolicy? errorPolicy,
      graphql.CacheRereadPolicy? cacheRereadPolicy,
      Object? optimisticResult,
      Duration? pollInterval,
      graphql.Context? context})
      : super(
            variables: variables?.toJson() ?? {},
            operationName: operationName,
            fetchPolicy: fetchPolicy,
            errorPolicy: errorPolicy,
            cacheRereadPolicy: cacheRereadPolicy,
            optimisticResult: optimisticResult,
            pollInterval: pollInterval,
            context: context,
            document: documentNodeQueryAnnouncements,
            parserFn: _parserFn$Query$Announcements);
}

class WatchOptions$Query$Announcements
    extends graphql.WatchQueryOptions<Query$Announcements> {
  WatchOptions$Query$Announcements(
      {String? operationName,
      Variables$Query$Announcements? variables,
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
            variables: variables?.toJson() ?? {},
            operationName: operationName,
            fetchPolicy: fetchPolicy,
            errorPolicy: errorPolicy,
            cacheRereadPolicy: cacheRereadPolicy,
            optimisticResult: optimisticResult,
            context: context,
            document: documentNodeQueryAnnouncements,
            pollInterval: pollInterval,
            eagerlyFetchResults: eagerlyFetchResults,
            carryForwardDataOnException: carryForwardDataOnException,
            fetchResults: fetchResults,
            parserFn: _parserFn$Query$Announcements);
}

class FetchMoreOptions$Query$Announcements extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Announcements(
      {required graphql.UpdateQuery updateQuery,
      Variables$Query$Announcements? variables})
      : super(
            updateQuery: updateQuery,
            variables: variables?.toJson() ?? {},
            document: documentNodeQueryAnnouncements);
}

extension ClientExtension$Query$Announcements on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Announcements>> query$Announcements(
          [Options$Query$Announcements? options]) async =>
      await this.query(options ?? Options$Query$Announcements());
  graphql.ObservableQuery<Query$Announcements> watchQuery$Announcements(
          [WatchOptions$Query$Announcements? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$Announcements());
  void writeQuery$Announcements(
          {required Query$Announcements data,
          Variables$Query$Announcements? variables,
          bool broadcast = true}) =>
      this.writeQuery(
          graphql.Request(
              operation:
                  graphql.Operation(document: documentNodeQueryAnnouncements),
              variables: variables?.toJson() ?? const {}),
          data: data.toJson(),
          broadcast: broadcast);
  Query$Announcements? readQuery$Announcements(
      {Variables$Query$Announcements? variables, bool optimistic = true}) {
    final result = this.readQuery(
        graphql.Request(
            operation:
                graphql.Operation(document: documentNodeQueryAnnouncements),
            variables: variables?.toJson() ?? const {}),
        optimistic: optimistic);
    return result == null ? null : Query$Announcements.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$Announcements> useQuery$Announcements(
        [Options$Query$Announcements? options]) =>
    graphql_flutter.useQuery(options ?? Options$Query$Announcements());
graphql.ObservableQuery<Query$Announcements> useWatchQuery$Announcements(
        [WatchOptions$Query$Announcements? options]) =>
    graphql_flutter
        .useWatchQuery(options ?? WatchOptions$Query$Announcements());

class Query$Announcements$Widget
    extends graphql_flutter.Query<Query$Announcements> {
  Query$Announcements$Widget(
      {widgets.Key? key,
      Options$Query$Announcements? options,
      required graphql_flutter.QueryBuilder<Query$Announcements> builder})
      : super(
            key: key,
            options: options ?? Options$Query$Announcements(),
            builder: builder);
}

class Query$Announcements$announcements {
  Query$Announcements$announcements(
      {required this.data,
      required this.paginatorInfo,
      required this.$__typename});

  factory Query$Announcements$announcements.fromJson(
      Map<String, dynamic> json) {
    final l$data = json['data'];
    final l$paginatorInfo = json['paginatorInfo'];
    final l$$__typename = json['__typename'];
    return Query$Announcements$announcements(
        data: (l$data as List<dynamic>)
            .map((e) => Query$Announcements$announcements$data.fromJson(
                (e as Map<String, dynamic>)))
            .toList(),
        paginatorInfo: Query$Announcements$announcements$paginatorInfo.fromJson(
            (l$paginatorInfo as Map<String, dynamic>)),
        $__typename: (l$$__typename as String));
  }

  final List<Query$Announcements$announcements$data> data;

  final Query$Announcements$announcements$paginatorInfo paginatorInfo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$data = data;
    _resultData['data'] = l$data.map((e) => e.toJson()).toList();
    final l$paginatorInfo = paginatorInfo;
    _resultData['paginatorInfo'] = l$paginatorInfo.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$data = data;
    final l$paginatorInfo = paginatorInfo;
    final l$$__typename = $__typename;
    return Object.hashAll(
        [Object.hashAll(l$data.map((v) => v)), l$paginatorInfo, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Announcements$announcements) ||
        runtimeType != other.runtimeType) {
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
    final l$paginatorInfo = paginatorInfo;
    final lOther$paginatorInfo = other.paginatorInfo;
    if (l$paginatorInfo != lOther$paginatorInfo) {
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

extension UtilityExtension$Query$Announcements$announcements
    on Query$Announcements$announcements {
  CopyWith$Query$Announcements$announcements<Query$Announcements$announcements>
      get copyWith =>
          CopyWith$Query$Announcements$announcements(this, (i) => i);
}

abstract class CopyWith$Query$Announcements$announcements<TRes> {
  factory CopyWith$Query$Announcements$announcements(
          Query$Announcements$announcements instance,
          TRes Function(Query$Announcements$announcements) then) =
      _CopyWithImpl$Query$Announcements$announcements;

  factory CopyWith$Query$Announcements$announcements.stub(TRes res) =
      _CopyWithStubImpl$Query$Announcements$announcements;

  TRes call(
      {List<Query$Announcements$announcements$data>? data,
      Query$Announcements$announcements$paginatorInfo? paginatorInfo,
      String? $__typename});
  TRes data(
      Iterable<Query$Announcements$announcements$data> Function(
              Iterable<
                  CopyWith$Query$Announcements$announcements$data<
                      Query$Announcements$announcements$data>>)
          _fn);
  CopyWith$Query$Announcements$announcements$paginatorInfo<TRes>
      get paginatorInfo;
}

class _CopyWithImpl$Query$Announcements$announcements<TRes>
    implements CopyWith$Query$Announcements$announcements<TRes> {
  _CopyWithImpl$Query$Announcements$announcements(this._instance, this._then);

  final Query$Announcements$announcements _instance;

  final TRes Function(Query$Announcements$announcements) _then;

  static const _undefined = {};

  TRes call(
          {Object? data = _undefined,
          Object? paginatorInfo = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$Announcements$announcements(
          data: data == _undefined || data == null
              ? _instance.data
              : (data as List<Query$Announcements$announcements$data>),
          paginatorInfo: paginatorInfo == _undefined || paginatorInfo == null
              ? _instance.paginatorInfo
              : (paginatorInfo
                  as Query$Announcements$announcements$paginatorInfo),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
  TRes data(
          Iterable<Query$Announcements$announcements$data> Function(
                  Iterable<
                      CopyWith$Query$Announcements$announcements$data<
                          Query$Announcements$announcements$data>>)
              _fn) =>
      call(
          data: _fn(_instance.data.map((e) =>
                  CopyWith$Query$Announcements$announcements$data(e, (i) => i)))
              .toList());
  CopyWith$Query$Announcements$announcements$paginatorInfo<TRes>
      get paginatorInfo {
    final local$paginatorInfo = _instance.paginatorInfo;
    return CopyWith$Query$Announcements$announcements$paginatorInfo(
        local$paginatorInfo, (e) => call(paginatorInfo: e));
  }
}

class _CopyWithStubImpl$Query$Announcements$announcements<TRes>
    implements CopyWith$Query$Announcements$announcements<TRes> {
  _CopyWithStubImpl$Query$Announcements$announcements(this._res);

  TRes _res;

  call(
          {List<Query$Announcements$announcements$data>? data,
          Query$Announcements$announcements$paginatorInfo? paginatorInfo,
          String? $__typename}) =>
      _res;
  data(_fn) => _res;
  CopyWith$Query$Announcements$announcements$paginatorInfo<TRes>
      get paginatorInfo =>
          CopyWith$Query$Announcements$announcements$paginatorInfo.stub(_res);
}

class Query$Announcements$announcements$data {
  Query$Announcements$announcements$data(
      {required this.author,
      required this.created_at,
      required this.id,
      required this.title,
      required this.$__typename});

  factory Query$Announcements$announcements$data.fromJson(
      Map<String, dynamic> json) {
    final l$author = json['author'];
    final l$created_at = json['created_at'];
    final l$id = json['id'];
    final l$title = json['title'];
    final l$$__typename = json['__typename'];
    return Query$Announcements$announcements$data(
        author: (l$author as String),
        created_at: DateTime.parse((l$created_at as String)),
        id: (l$id as String),
        title: (l$title as String),
        $__typename: (l$$__typename as String));
  }

  final String author;

  final DateTime created_at;

  final String id;

  final String title;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$author = author;
    _resultData['author'] = l$author;
    final l$created_at = created_at;
    _resultData['created_at'] = l$created_at.toIso8601String();
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$author = author;
    final l$created_at = created_at;
    final l$id = id;
    final l$title = title;
    final l$$__typename = $__typename;
    return Object.hashAll(
        [l$author, l$created_at, l$id, l$title, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Announcements$announcements$data) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    final l$created_at = created_at;
    final lOther$created_at = other.created_at;
    if (l$created_at != lOther$created_at) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
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

extension UtilityExtension$Query$Announcements$announcements$data
    on Query$Announcements$announcements$data {
  CopyWith$Query$Announcements$announcements$data<
          Query$Announcements$announcements$data>
      get copyWith =>
          CopyWith$Query$Announcements$announcements$data(this, (i) => i);
}

abstract class CopyWith$Query$Announcements$announcements$data<TRes> {
  factory CopyWith$Query$Announcements$announcements$data(
          Query$Announcements$announcements$data instance,
          TRes Function(Query$Announcements$announcements$data) then) =
      _CopyWithImpl$Query$Announcements$announcements$data;

  factory CopyWith$Query$Announcements$announcements$data.stub(TRes res) =
      _CopyWithStubImpl$Query$Announcements$announcements$data;

  TRes call(
      {String? author,
      DateTime? created_at,
      String? id,
      String? title,
      String? $__typename});
}

class _CopyWithImpl$Query$Announcements$announcements$data<TRes>
    implements CopyWith$Query$Announcements$announcements$data<TRes> {
  _CopyWithImpl$Query$Announcements$announcements$data(
      this._instance, this._then);

  final Query$Announcements$announcements$data _instance;

  final TRes Function(Query$Announcements$announcements$data) _then;

  static const _undefined = {};

  TRes call(
          {Object? author = _undefined,
          Object? created_at = _undefined,
          Object? id = _undefined,
          Object? title = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$Announcements$announcements$data(
          author: author == _undefined || author == null
              ? _instance.author
              : (author as String),
          created_at: created_at == _undefined || created_at == null
              ? _instance.created_at
              : (created_at as DateTime),
          id: id == _undefined || id == null ? _instance.id : (id as String),
          title: title == _undefined || title == null
              ? _instance.title
              : (title as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
}

class _CopyWithStubImpl$Query$Announcements$announcements$data<TRes>
    implements CopyWith$Query$Announcements$announcements$data<TRes> {
  _CopyWithStubImpl$Query$Announcements$announcements$data(this._res);

  TRes _res;

  call(
          {String? author,
          DateTime? created_at,
          String? id,
          String? title,
          String? $__typename}) =>
      _res;
}

class Query$Announcements$announcements$paginatorInfo {
  Query$Announcements$announcements$paginatorInfo(
      {required this.lastPage,
      required this.currentPage,
      required this.$__typename});

  factory Query$Announcements$announcements$paginatorInfo.fromJson(
      Map<String, dynamic> json) {
    final l$lastPage = json['lastPage'];
    final l$currentPage = json['currentPage'];
    final l$$__typename = json['__typename'];
    return Query$Announcements$announcements$paginatorInfo(
        lastPage: (l$lastPage as int),
        currentPage: (l$currentPage as int),
        $__typename: (l$$__typename as String));
  }

  final int lastPage;

  final int currentPage;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$lastPage = lastPage;
    _resultData['lastPage'] = l$lastPage;
    final l$currentPage = currentPage;
    _resultData['currentPage'] = l$currentPage;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$lastPage = lastPage;
    final l$currentPage = currentPage;
    final l$$__typename = $__typename;
    return Object.hashAll([l$lastPage, l$currentPage, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Announcements$announcements$paginatorInfo) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$lastPage = lastPage;
    final lOther$lastPage = other.lastPage;
    if (l$lastPage != lOther$lastPage) {
      return false;
    }
    final l$currentPage = currentPage;
    final lOther$currentPage = other.currentPage;
    if (l$currentPage != lOther$currentPage) {
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

extension UtilityExtension$Query$Announcements$announcements$paginatorInfo
    on Query$Announcements$announcements$paginatorInfo {
  CopyWith$Query$Announcements$announcements$paginatorInfo<
          Query$Announcements$announcements$paginatorInfo>
      get copyWith => CopyWith$Query$Announcements$announcements$paginatorInfo(
          this, (i) => i);
}

abstract class CopyWith$Query$Announcements$announcements$paginatorInfo<TRes> {
  factory CopyWith$Query$Announcements$announcements$paginatorInfo(
          Query$Announcements$announcements$paginatorInfo instance,
          TRes Function(Query$Announcements$announcements$paginatorInfo) then) =
      _CopyWithImpl$Query$Announcements$announcements$paginatorInfo;

  factory CopyWith$Query$Announcements$announcements$paginatorInfo.stub(
          TRes res) =
      _CopyWithStubImpl$Query$Announcements$announcements$paginatorInfo;

  TRes call({int? lastPage, int? currentPage, String? $__typename});
}

class _CopyWithImpl$Query$Announcements$announcements$paginatorInfo<TRes>
    implements CopyWith$Query$Announcements$announcements$paginatorInfo<TRes> {
  _CopyWithImpl$Query$Announcements$announcements$paginatorInfo(
      this._instance, this._then);

  final Query$Announcements$announcements$paginatorInfo _instance;

  final TRes Function(Query$Announcements$announcements$paginatorInfo) _then;

  static const _undefined = {};

  TRes call(
          {Object? lastPage = _undefined,
          Object? currentPage = _undefined,
          Object? $__typename = _undefined}) =>
      _then(Query$Announcements$announcements$paginatorInfo(
          lastPage: lastPage == _undefined || lastPage == null
              ? _instance.lastPage
              : (lastPage as int),
          currentPage: currentPage == _undefined || currentPage == null
              ? _instance.currentPage
              : (currentPage as int),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String)));
}

class _CopyWithStubImpl$Query$Announcements$announcements$paginatorInfo<TRes>
    implements CopyWith$Query$Announcements$announcements$paginatorInfo<TRes> {
  _CopyWithStubImpl$Query$Announcements$announcements$paginatorInfo(this._res);

  TRes _res;

  call({int? lastPage, int? currentPage, String? $__typename}) => _res;
}
