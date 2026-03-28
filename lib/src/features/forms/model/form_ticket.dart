import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';

part 'form_ticket.g.dart';

// If you're testing set this to 'testforms', for production use 'forms'
const String ticketCollectionName = 'testtickets';

@immutable
@JsonSerializable()
class FormTicket {
  const FormTicket(
      {required this.createdAt,
      required this.name,
      required this.orginalOwner,
      required this.owner,
      required this.validFrom,
      required this.validUntil,
      required this.fromForm,
      required this.fromFormAnswer,
      required this.status});
  factory FormTicket.fromJson(Map<String, dynamic> json) =>
      _$FormTicketFromJson(json);

  @JsonKey(name: 'createdAt')
  @TimestampDateTimeConverter()
  final Timestamp createdAt;

  final String name;
  final String orginalOwner;
  final String owner;

  @JsonKey(name: 'validFrom')
  @TimestampDateTimeConverter()
  final Timestamp validFrom;

  @JsonKey(name: 'validUntil')
  @TimestampDateTimeConverter()
  final Timestamp validUntil;

  final String fromForm;
  final String fromFormAnswer;
  final String status;

  Map<String, dynamic> toJson() => _$FormTicketToJson(this);
}
