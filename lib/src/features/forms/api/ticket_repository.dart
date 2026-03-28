import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_ticket.dart';

class TicketRepository {
  /// Creates a new ticket in Firestore, linked to the given form answer.
  static Future<DocumentReference<FormTicket>> createTicket({
    required DocumentReference answerDocRef,
    required FormTicket ticket,
  }) async {
    // Create a reference to the tickets subcollection under the answer
    final ticketsRef = FirebaseFirestore.instance
        .collection(ticketCollectionName)
        .withConverter<FormTicket>(
          fromFirestore: (snap, _) => FormTicket.fromJson(snap.data()!),
          toFirestore: (ticket, _) => ticket.toJson(),
        );

    // Add the ticket to Firestore
    final docRef = await ticketsRef.add(ticket);
    return docRef;
  }
}
