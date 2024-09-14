import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'knrb.g.dart';

@immutable
@JsonSerializable()
class KNRB {
  final bool knrb;
  @JsonKey(name: 'knrb_id')
  final String knrbId;
  @JsonKey(name: 'last_synchronized')
  final DateTime? lastSynchronized;
  @JsonKey(name: 'start_membership')
  final DateTime? startMembership;
  const KNRB({
    required this.knrb,
    required this.knrbId,
    this.lastSynchronized,
    required this.startMembership,
  });

  factory KNRB.fromJson(Map<String, dynamic> json) => _$KNRBFromJson(json);
  Map<String, dynamic> toJson() => _$KNRBToJson(this);
}
