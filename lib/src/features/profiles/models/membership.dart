import 'package:json_annotation/json_annotation.dart';

part 'membership.g.dart';

@JsonSerializable()
class Membership {
  Membership(
      {required this.id,
      required this.isInterestedMember,
      required this.isLenteMember,
      required this.isAspirantMember,
      required this.startMembership,
      this.endMembership});

  factory Membership.fromJson(Map<String, dynamic> json) =>
      _$MembershipFromJson(json);

  final int id;

  @JsonKey(name: 'interested_member')
  final bool isInterestedMember;

  @JsonKey(name: 'lente_member')
  final bool isLenteMember;

  @JsonKey(name: 'aspirant_member')
  final bool isAspirantMember;

  @JsonKey(name: 'start_membership')
  final DateTime startMembership;

  @JsonKey(name: 'end_membership')
  final DateTime? endMembership;

  Map<String, dynamic> toJson() => _$MembershipToJson(this);
}
