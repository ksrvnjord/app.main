import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/polls_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/model/poll.dart';
import 'package:ksrvnjord_main_app/src/features/polls/widgets/poll_card.dart';

class PollsPage extends StatelessWidget {
  const PollsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
      ),
      body: FirestorePagination(
        query: pollsCollection.orderBy('openUntil', descending: true),
        itemBuilder: (context, snap, index) {
          final pollSnapshot = snap as DocumentSnapshot<Poll>;

          return PollCard(pollDoc: pollSnapshot);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        isLive: true,
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
