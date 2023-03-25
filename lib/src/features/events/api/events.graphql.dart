// ignore_for_file: type=lint
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Query$CalendarItems {
  Query$CalendarItems({
    required this.events,
    required this.$__typename,
  });

  factory Query$CalendarItems.fromJson(Map<String, dynamic> json) {
    final l$events = json['events'];
    final l$$__typename = json['__typename'];
    return Query$CalendarItems(
      events: (l$events as List<dynamic>)
          .map((e) => e == null
              ? null
              : Query$CalendarItems$events.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$CalendarItems$events?> events;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$events = events;
    _resultData['events'] = l$events.map((e) => e?.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$events = events;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$events.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$CalendarItems) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$events = events;
    final lOther$events = other.events;
    if (l$events.length != lOther$events.length) {
      return false;
    }
    for (int i = 0; i < l$events.length; i++) {
      final l$events$entry = l$events[i];
      final lOther$events$entry = lOther$events[i];
      if (l$events$entry != lOther$events$entry) {
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

extension UtilityExtension$Query$CalendarItems on Query$CalendarItems {
  CopyWith$Query$CalendarItems<Query$CalendarItems> get copyWith =>
      CopyWith$Query$CalendarItems(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$CalendarItems<TRes> {
  factory CopyWith$Query$CalendarItems(
    Query$CalendarItems instance,
    TRes Function(Query$CalendarItems) then,
  ) = _CopyWithImpl$Query$CalendarItems;

  factory CopyWith$Query$CalendarItems.stub(TRes res) =
      _CopyWithStubImpl$Query$CalendarItems;

  TRes call({
    List<Query$CalendarItems$events?>? events,
    String? $__typename,
  });
  TRes events(
      Iterable<Query$CalendarItems$events?> Function(
              Iterable<
                  CopyWith$Query$CalendarItems$events<
                      Query$CalendarItems$events>?>)
          _fn);
}

class _CopyWithImpl$Query$CalendarItems<TRes>
    implements CopyWith$Query$CalendarItems<TRes> {
  _CopyWithImpl$Query$CalendarItems(
    this._instance,
    this._then,
  );

  final Query$CalendarItems _instance;

  final TRes Function(Query$CalendarItems) _then;

  static const _undefined = {};

  TRes call({
    Object? events = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$CalendarItems(
        events: events == _undefined || events == null
            ? _instance.events
            : (events as List<Query$CalendarItems$events?>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
  TRes events(
          Iterable<Query$CalendarItems$events?> Function(
                  Iterable<
                      CopyWith$Query$CalendarItems$events<
                          Query$CalendarItems$events>?>)
              _fn) =>
      call(
          events: _fn(_instance.events.map((e) => e == null
              ? null
              : CopyWith$Query$CalendarItems$events(
                  e,
                  (i) => i,
                ))).toList());
}

class _CopyWithStubImpl$Query$CalendarItems<TRes>
    implements CopyWith$Query$CalendarItems<TRes> {
  _CopyWithStubImpl$Query$CalendarItems(this._res);

  TRes _res;

  call({
    List<Query$CalendarItems$events?>? events,
    String? $__typename,
  }) =>
      _res;
  events(_fn) => _res;
}

const documentNodeQueryCalendarItems = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'CalendarItems'),
    variableDefinitions: [],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'events'),
        alias: null,
        arguments: [],
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
            name: NameNode(value: 'title'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'start_time'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'end_time'),
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
]);
Query$CalendarItems _parserFn$Query$CalendarItems(Map<String, dynamic> data) =>
    Query$CalendarItems.fromJson(data);

class Options$Query$CalendarItems
    extends graphql.QueryOptions<Query$CalendarItems> {
  Options$Query$CalendarItems({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
  }) : super(
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult,
          pollInterval: pollInterval,
          context: context,
          document: documentNodeQueryCalendarItems,
          parserFn: _parserFn$Query$CalendarItems,
        );
}

class WatchOptions$Query$CalendarItems
    extends graphql.WatchQueryOptions<Query$CalendarItems> {
  WatchOptions$Query$CalendarItems({
    String? operationName,
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
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult,
          context: context,
          document: documentNodeQueryCalendarItems,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$CalendarItems,
        );
}

class FetchMoreOptions$Query$CalendarItems extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$CalendarItems(
      {required graphql.UpdateQuery updateQuery})
      : super(
          updateQuery: updateQuery,
          document: documentNodeQueryCalendarItems,
        );
}

extension ClientExtension$Query$CalendarItems on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$CalendarItems>> query$CalendarItems(
          [Options$Query$CalendarItems? options]) async =>
      await this.query(options ?? Options$Query$CalendarItems());
  graphql.ObservableQuery<Query$CalendarItems> watchQuery$CalendarItems(
          [WatchOptions$Query$CalendarItems? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$CalendarItems());
  void writeQuery$CalendarItems({
    required Query$CalendarItems data,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
            operation:
                graphql.Operation(document: documentNodeQueryCalendarItems)),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$CalendarItems? readQuery$CalendarItems({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
          operation:
              graphql.Operation(document: documentNodeQueryCalendarItems)),
      optimistic: optimistic,
    );
    return result == null ? null : Query$CalendarItems.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$CalendarItems> useQuery$CalendarItems(
        [Options$Query$CalendarItems? options]) =>
    graphql_flutter.useQuery(options ?? Options$Query$CalendarItems());
graphql.ObservableQuery<Query$CalendarItems> useWatchQuery$CalendarItems(
        [WatchOptions$Query$CalendarItems? options]) =>
    graphql_flutter
        .useWatchQuery(options ?? WatchOptions$Query$CalendarItems());

class Query$CalendarItems$Widget
    extends graphql_flutter.Query<Query$CalendarItems> {
  Query$CalendarItems$Widget({
    widgets.Key? key,
    Options$Query$CalendarItems? options,
    required graphql_flutter.QueryBuilder<Query$CalendarItems> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$CalendarItems(),
          builder: builder,
        );
}

class Query$CalendarItems$events {
  Query$CalendarItems$events({
    required this.id,
    this.title,
    this.start_time,
    this.end_time,
    required this.$__typename,
  });

  factory Query$CalendarItems$events.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$start_time = json['start_time'];
    final l$end_time = json['end_time'];
    final l$$__typename = json['__typename'];
    return Query$CalendarItems$events(
      id: (l$id as String),
      title: (l$title as String?),
      start_time: (l$start_time as String?),
      end_time: (l$end_time as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? title;

  final String? start_time;

  final String? end_time;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$start_time = start_time;
    _resultData['start_time'] = l$start_time;
    final l$end_time = end_time;
    _resultData['end_time'] = l$end_time;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$start_time = start_time;
    final l$end_time = end_time;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$start_time,
      l$end_time,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$CalendarItems$events) ||
        runtimeType != other.runtimeType) {
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
    final l$start_time = start_time;
    final lOther$start_time = other.start_time;
    if (l$start_time != lOther$start_time) {
      return false;
    }
    final l$end_time = end_time;
    final lOther$end_time = other.end_time;
    if (l$end_time != lOther$end_time) {
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

extension UtilityExtension$Query$CalendarItems$events
    on Query$CalendarItems$events {
  CopyWith$Query$CalendarItems$events<Query$CalendarItems$events>
      get copyWith => CopyWith$Query$CalendarItems$events(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$CalendarItems$events<TRes> {
  factory CopyWith$Query$CalendarItems$events(
    Query$CalendarItems$events instance,
    TRes Function(Query$CalendarItems$events) then,
  ) = _CopyWithImpl$Query$CalendarItems$events;

  factory CopyWith$Query$CalendarItems$events.stub(TRes res) =
      _CopyWithStubImpl$Query$CalendarItems$events;

  TRes call({
    String? id,
    String? title,
    String? start_time,
    String? end_time,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$CalendarItems$events<TRes>
    implements CopyWith$Query$CalendarItems$events<TRes> {
  _CopyWithImpl$Query$CalendarItems$events(
    this._instance,
    this._then,
  );

  final Query$CalendarItems$events _instance;

  final TRes Function(Query$CalendarItems$events) _then;

  static const _undefined = {};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? start_time = _undefined,
    Object? end_time = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$CalendarItems$events(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        title: title == _undefined ? _instance.title : (title as String?),
        start_time: start_time == _undefined
            ? _instance.start_time
            : (start_time as String?),
        end_time:
            end_time == _undefined ? _instance.end_time : (end_time as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$CalendarItems$events<TRes>
    implements CopyWith$Query$CalendarItems$events<TRes> {
  _CopyWithStubImpl$Query$CalendarItems$events(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? start_time,
    String? end_time,
    String? $__typename,
  }) =>
      _res;
}
