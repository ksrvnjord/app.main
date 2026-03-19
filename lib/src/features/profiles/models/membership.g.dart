// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Membership _$MembershipFromJson(Map<String, dynamic> json) => Membership(
      id: (json['id'] as num).toInt(),
      isInterestedMember: json['interested_member'] as bool,
      isLenteMember: json['lente_member'] as bool,
      isAspirantMember: json['aspirant_member'] as bool,
      startMembership: DateTime.parse(json['start_membership'] as String),
      endMembership: json['end_membership'] == null
          ? null
          : DateTime.parse(json['end_membership'] as String),
    );

Map<String, dynamic> _$MembershipToJson(Membership instance) =>
    <String, dynamic>{
      'id': instance.id,
      'interested_member': instance.isInterestedMember,
      'lente_member': instance.isLenteMember,
      'aspirant_member': instance.isAspirantMember,
      'start_membership': instance.startMembership.toIso8601String(),
      'end_membership': instance.endMembership?.toIso8601String(),
    };
