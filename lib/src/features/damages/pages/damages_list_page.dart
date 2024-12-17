import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_tile_widget.dart';

class DamagesListPage extends ConsumerWidget {
  const DamagesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double gapY = 8;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Schademeldingen'),
      ),
      body: FirestorePagination(
        query: FirebaseFirestore.instance
            .collectionGroup("damages")
            .withConverter<Damage>(
              fromFirestore: (snapshot, _) =>
                  Damage.fromJson(snapshot.data() ?? {}),
              toFirestore: (reservation, _) => reservation.toJson(),
            )
            .orderBy('critical', descending: true)
            .orderBy('createdTime', descending: true),
        itemBuilder: (context, snap, index) {
          final pollSnapshot = snap as QueryDocumentSnapshot<Damage>;

          return DamageTileWidget(
            showDamage: () => context.goNamed('Show Damage', queryParameters: {
              'id': pollSnapshot.id,
              'reservationObjectId': pollSnapshot.data().parent.id,
            }),
            editDamage: () => context.goNamed('Edit Damage', queryParameters: {
              'id': pollSnapshot.id,
              'reservationObjectId': pollSnapshot.data().parent.id,
            }),
            damageSnapshot: pollSnapshot,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: gapY),
        isLive: true,
        padding: const EdgeInsets.all(8),
      ),
      floatingActionButton: FirebaseAuth.instance.currentUser !=
              null // Only show button if user is logged in.
          ? FloatingActionButton.extended(
              onPressed: () => context.goNamed('Create Damage'),
              icon: const Icon(Icons.add),
              label: const Text('Nieuwe schade melden'),
            )
          : null,
    );
  }
}
