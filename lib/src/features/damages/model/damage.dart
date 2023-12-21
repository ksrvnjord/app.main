import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/get_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/object_by_type_and_name.dart';

@immutable
class Damage {
  final DocumentReference? reference;
  final DocumentReference parent;
  final String? image;
  final String name;
  final String type;
  final String creatorId;
  final String cause;
  final DateTime createdTime;
  final String description;
  final bool critical;
  final bool active;

  Damage.fromJson(Map<String, Object?> json)
      : reference = json['reference'] as DocumentReference?,
        parent = json['parent']! as DocumentReference,
        image = json['image'] as String?,
        name = (json['name'] ?? '') as String,
        type = (json['type'] ?? '') as String,
        creatorId = json['creatorId']! as String,
        createdTime = (json['createdTime'] as Timestamp).toDate(),
        description = json['description']! as String,
        cause = (json['cause'] ?? '') as String,
        critical = (json['critical'] ?? false) as bool,
        active = (json['active'] ?? false) as bool;

  Map<String, Object?> toJson() {
    return {
      'reference': reference,
      'image': image,
      'critical': critical,
      'active': active,
      'parent': parent,
      'description': description,
      'cause': cause,
      'createdTime': createdTime,
      'creatorId': creatorId,
      'name': name,
      'type': type,
    };
  }

  static Future<void> deleteById(
    String id,
    String reservationObjectId,
  ) async {
    // Get the current user ID.
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('DamageForm was submitted by unauthenticated user.');
    }

    // Get the damage using the identifiers.
    final damage = await getDamage(reservationObjectId, id);

    // Check if there's an image, if so, delete it.
    if (damage.data()?.image != null) {
      final String path =
          '/$uid/public/objects/$reservationObjectId/damages/$id.jpg';
      await FirebaseStorage.instance.ref(path).delete();
    }

    // First create the damages item, so we have an ID.
    return await damage.reference.delete();
  }

  static Future<void> edit(
    String id,
    String reservationObjectId,
    DamageForm damageForm,
  ) async {
    // Get the current user ID.
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('DamageForm was submitted by unauthenticated user.');
    }

    // Check if the form is complete.
    if (!damageForm.complete) {
      throw Exception('DamageForm was submitted, but not complete.');
    }

    // Get the objects with the given type and name.
    final damage = await getDamage(reservationObjectId, id);

    // Update the damage item, using the Damage object / class.
    await damage.reference.update({
      'description': damageForm.description,
      'cause': damageForm.cause,
      'critical': damageForm.critical,
      'active': true,
      'type': damageForm.type,
      'name': damageForm.name,
    });

    // Check if there's an image, if so, upload it.
    File? image = damageForm.image;
    if (image != null) {
      final String path =
          '/$uid/public/objects/$reservationObjectId/damages/$id.jpg';
      // ignore: avoid-ignoring-return-values
      FirebaseStorage.instance.ref(path).putFile(
            image,
          );

      // Then, store it in the addedDamage.
      damage.reference.update({'image': path});
    }
  }

  static Future<void> create(DamageForm damageForm) async {
    // Get the current user ID.
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('DamageForm was submitted by unauthenticated user.');
    }

    // Check if the form is complete.
    if (!damageForm.complete) {
      throw Exception('DamageForm was submitted, but not complete.');
    }

    // Get the objects with the given type and name.
    final objects =
        await objectByTypeAndName(damageForm.type ?? "", damageForm.name ?? "");

    // Check if we received any objects.
    if (objects.isEmpty) {
      throw Exception(
        'Submitted DamageForm could not find Reservation Object.',
      );
    }

    // Get the first object from the list and receive the subcollections.
    final object = objects.first.reference;

    // First create the damages item, so we have an ID.
    final addedDamage = await object.collection('damages').add(Damage.fromJson({
          'parent': object,
          'description': damageForm.description,
          'cause': damageForm.cause,
          'critical': damageForm.critical,
          'active': true,
          'createdTime': Timestamp.now(),
          'creatorId': uid,
          'type': damageForm.type,
          'name': damageForm.name,
        }).toJson());

    // Check if there's an image, if so, upload it.
    File? image = damageForm.image;
    if (image != null) {
      final String path =
          '/$uid/public/objects/${object.id}/damages/${addedDamage.id}.jpg';
      // ignore: avoid-ignoring-return-values
      FirebaseStorage.instance.ref(path).putFile(
            image,
          );

      // Then, store it in the addedDamage.
      addedDamage.update({'image': path});
    }
  }
}
