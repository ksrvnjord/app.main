// ignore_for_file: type=lint
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables$Query$Announcement {
  factory Variables$Query$Announcement({String? announcementId}) =>
      Variables$Query$Announcement._({
        if (announcementId != null) r'announcementId': announcementId,
      });

  Variables$Query$Announcement._(this._$data);

  factory Variables$Query$Announcement.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('announcementId')) {
      final l$announcementId = data['announcementId'];
      result$data['announcementId'] = (l$announcementId as String?);
    }
    return Variables$Query$Announcement._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get announcementId => (_$data['announcementId'] as String?);
  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('announcementId')) {
      final l$announcementId = announcementId;
      result$data['announcementId'] = l$announcementId;
    }
    return result$data;
  }

  CopyWith$Variables$Query$Announcement<Variables$Query$Announcement>
      get copyWith => CopyWith$Variables$Query$Announcement(
            this,
            (i) => i,
          );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Variables$Query$Announcement) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$announcementId = announcementId;
    final lOther$announcementId = other.announcementId;
    if (_$data.containsKey('announcementId') !=
        other._$data.containsKey('announcementId')) {
      return false;
    }
    if (l$announcementId != lOther$announcementId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$announcementId = announcementId;
    return Object.hashAll(
        [_$data.containsKey('announcementId') ? l$announcementId : const {}]);
  }
}

abstract class CopyWith$Variables$Query$Announcement<TRes> {
  factory CopyWith$Variables$Query$Announcement(
    Variables$Query$Announcement instance,
    TRes Function(Variables$Query$Announcement) then,
  ) = _CopyWithImpl$Variables$Query$Announcement;

  factory CopyWith$Variables$Query$Announcement.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$Announcement;

  TRes call({String? announcementId});
}

class _CopyWithImpl$Variables$Query$Announcement<TRes>
    implements CopyWith$Variables$Query$Announcement<TRes> {
  _CopyWithImpl$Variables$Query$Announcement(
    this._instance,
    this._then,
  );

  final Variables$Query$Announcement _instance;

  final TRes Function(Variables$Query$Announcement) _then;

  static const _undefined = {};

  TRes call({Object? announcementId = _undefined}) =>
      _then(Variables$Query$Announcement._({
        ..._instance._$data,
        if (announcementId != _undefined)
          'announcementId': (announcementId as String?),
      }));
}

class _CopyWithStubImpl$Variables$Query$Announcement<TRes>
    implements CopyWith$Variables$Query$Announcement<TRes> {
  _CopyWithStubImpl$Variables$Query$Announcement(this._res);

  TRes _res;

  call({String? announcementId}) => _res;
}

class Query$Announcement {
  Query$Announcement({
    required this.announcement,
    required this.$__typename,
  });

  factory Query$Announcement.fromJson(Map<String, dynamic> json) {
    final l$announcement = json['announcement'];
    final l$$__typename = json['__typename'];
    return Query$Announcement(
      announcement: Query$Announcement$announcement.fromJson(
          (l$announcement as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$Announcement$announcement announcement;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$announcement = announcement;
    _resultData['announcement'] = l$announcement.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$announcement = announcement;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$announcement,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Announcement) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$announcement = announcement;
    final lOther$announcement = other.announcement;
    if (l$announcement != lOther$announcement) {
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

extension UtilityExtension$Query$Announcement on Query$Announcement {
  CopyWith$Query$Announcement<Query$Announcement> get copyWith =>
      CopyWith$Query$Announcement(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$Announcement<TRes> {
  factory CopyWith$Query$Announcement(
    Query$Announcement instance,
    TRes Function(Query$Announcement) then,
  ) = _CopyWithImpl$Query$Announcement;

  factory CopyWith$Query$Announcement.stub(TRes res) =
      _CopyWithStubImpl$Query$Announcement;

  TRes call({
    Query$Announcement$announcement? announcement,
    String? $__typename,
  });
  CopyWith$Query$Announcement$announcement<TRes> get announcement;
}

class _CopyWithImpl$Query$Announcement<TRes>
    implements CopyWith$Query$Announcement<TRes> {
  _CopyWithImpl$Query$Announcement(
    this._instance,
    this._then,
  );

  final Query$Announcement _instance;

  final TRes Function(Query$Announcement) _then;

  static const _undefined = {};

  TRes call({
    Object? announcement = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Announcement(
        announcement: announcement == _undefined || announcement == null
            ? _instance.announcement
            : (announcement as Query$Announcement$announcement),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
  CopyWith$Query$Announcement$announcement<TRes> get announcement {
    final local$announcement = _instance.announcement;
    return CopyWith$Query$Announcement$announcement(
        local$announcement, (e) => call(announcement: e));
  }
}

class _CopyWithStubImpl$Query$Announcement<TRes>
    implements CopyWith$Query$Announcement<TRes> {
  _CopyWithStubImpl$Query$Announcement(this._res);

  TRes _res;

  call({
    Query$Announcement$announcement? announcement,
    String? $__typename,
  }) =>
      _res;
  CopyWith$Query$Announcement$announcement<TRes> get announcement =>
      CopyWith$Query$Announcement$announcement.stub(_res);
}

const documentNodeQueryAnnouncement = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'Announcement'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'announcementId')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: false,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'announcement'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'id'),
            value: VariableNode(name: NameNode(value: 'announcementId')),
          )
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'author'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'contents'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'created_at'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
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
            name: NameNode(value: 'updated_at'),
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
Query$Announcement _parserFn$Query$Announcement(Map<String, dynamic> data) =>
    Query$Announcement.fromJson(data);

class Options$Query$Announcement
    extends graphql.QueryOptions<Query$Announcement> {
  Options$Query$Announcement({
    String? operationName,
    Variables$Query$Announcement? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
  }) : super(
          variables: variables?.toJson() ?? {},
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult,
          pollInterval: pollInterval,
          context: context,
          document: documentNodeQueryAnnouncement,
          parserFn: _parserFn$Query$Announcement,
        );
}

class WatchOptions$Query$Announcement
    extends graphql.WatchQueryOptions<Query$Announcement> {
  WatchOptions$Query$Announcement({
    String? operationName,
    Variables$Query$Announcement? variables,
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
          variables: variables?.toJson() ?? {},
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult,
          context: context,
          document: documentNodeQueryAnnouncement,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$Announcement,
        );
}

class FetchMoreOptions$Query$Announcement extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Announcement({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$Announcement? variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables?.toJson() ?? {},
          document: documentNodeQueryAnnouncement,
        );
}

extension ClientExtension$Query$Announcement on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Announcement>> query$Announcement(
          [Options$Query$Announcement? options]) async =>
      await this.query(options ?? Options$Query$Announcement());
  graphql.ObservableQuery<Query$Announcement> watchQuery$Announcement(
          [WatchOptions$Query$Announcement? options]) =>
      this.watchQuery(options ?? WatchOptions$Query$Announcement());
  void writeQuery$Announcement({
    required Query$Announcement data,
    Variables$Query$Announcement? variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryAnnouncement),
          variables: variables?.toJson() ?? const {},
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$Announcement? readQuery$Announcement({
    Variables$Query$Announcement? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryAnnouncement),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$Announcement.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$Announcement> useQuery$Announcement(
        [Options$Query$Announcement? options]) =>
    graphql_flutter.useQuery(options ?? Options$Query$Announcement());
graphql.ObservableQuery<Query$Announcement> useWatchQuery$Announcement(
        [WatchOptions$Query$Announcement? options]) =>
    graphql_flutter.useWatchQuery(options ?? WatchOptions$Query$Announcement());

class Query$Announcement$Widget
    extends graphql_flutter.Query<Query$Announcement> {
  Query$Announcement$Widget({
    widgets.Key? key,
    Options$Query$Announcement? options,
    required graphql_flutter.QueryBuilder<Query$Announcement> builder,
  }) : super(
          key: key,
          options: options ?? Options$Query$Announcement(),
          builder: builder,
        );
}

class Query$Announcement$announcement {
  Query$Announcement$announcement({
    required this.author,
    required this.contents,
    required this.created_at,
    required this.id,
    required this.title,
    required this.updated_at,
    required this.$__typename,
  });

  factory Query$Announcement$announcement.fromJson(Map<String, dynamic> json) {
    final l$author = json['author'];
    final l$contents = json['contents'];
    final l$created_at = json['created_at'];
    final l$id = json['id'];
    final l$title = json['title'];
    final l$updated_at = json['updated_at'];
    final l$$__typename = json['__typename'];
    return Query$Announcement$announcement(
      author: (l$author as String),
      contents: (l$contents as String),
      created_at: DateTime.parse((l$created_at as String)),
      id: (l$id as String),
      title: (l$title as String),
      updated_at: DateTime.parse((l$updated_at as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String author;

  final String contents;

  final DateTime created_at;

  final String id;

  final String title;

  final DateTime updated_at;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$author = author;
    _resultData['author'] = l$author;
    final l$contents = contents;
    _resultData['contents'] = l$contents;
    final l$created_at = created_at;
    _resultData['created_at'] = l$created_at.toIso8601String();
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$updated_at = updated_at;
    _resultData['updated_at'] = l$updated_at.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$author = author;
    final l$contents = contents;
    final l$created_at = created_at;
    final l$id = id;
    final l$title = title;
    final l$updated_at = updated_at;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$author,
      l$contents,
      l$created_at,
      l$id,
      l$title,
      l$updated_at,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Announcement$announcement) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    final l$contents = contents;
    final lOther$contents = other.contents;
    if (l$contents != lOther$contents) {
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
    final l$updated_at = updated_at;
    final lOther$updated_at = other.updated_at;
    if (l$updated_at != lOther$updated_at) {
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

extension UtilityExtension$Query$Announcement$announcement
    on Query$Announcement$announcement {
  CopyWith$Query$Announcement$announcement<Query$Announcement$announcement>
      get copyWith => CopyWith$Query$Announcement$announcement(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Announcement$announcement<TRes> {
  factory CopyWith$Query$Announcement$announcement(
    Query$Announcement$announcement instance,
    TRes Function(Query$Announcement$announcement) then,
  ) = _CopyWithImpl$Query$Announcement$announcement;

  factory CopyWith$Query$Announcement$announcement.stub(TRes res) =
      _CopyWithStubImpl$Query$Announcement$announcement;

  TRes call({
    String? author,
    String? contents,
    DateTime? created_at,
    String? id,
    String? title,
    DateTime? updated_at,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Announcement$announcement<TRes>
    implements CopyWith$Query$Announcement$announcement<TRes> {
  _CopyWithImpl$Query$Announcement$announcement(
    this._instance,
    this._then,
  );

  final Query$Announcement$announcement _instance;

  final TRes Function(Query$Announcement$announcement) _then;

  static const _undefined = {};

  TRes call({
    Object? author = _undefined,
    Object? contents = _undefined,
    Object? created_at = _undefined,
    Object? id = _undefined,
    Object? title = _undefined,
    Object? updated_at = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Announcement$announcement(
        author: author == _undefined || author == null
            ? _instance.author
            : (author as String),
        contents: contents == _undefined || contents == null
            ? _instance.contents
            : (contents as String),
        created_at: created_at == _undefined || created_at == null
            ? _instance.created_at
            : (created_at as DateTime),
        id: id == _undefined || id == null ? _instance.id : (id as String),
        title: title == _undefined || title == null
            ? _instance.title
            : (title as String),
        updated_at: updated_at == _undefined || updated_at == null
            ? _instance.updated_at
            : (updated_at as DateTime),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Announcement$announcement<TRes>
    implements CopyWith$Query$Announcement$announcement<TRes> {
  _CopyWithStubImpl$Query$Announcement$announcement(this._res);

  TRes _res;

  call({
    String? author,
    String? contents,
    DateTime? created_at,
    String? id,
    String? title,
    DateTime? updated_at,
    String? $__typename,
  }) =>
      _res;
}
