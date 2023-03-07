import functions from 'firebase-functions'
import admin from 'firebase-admin'
import { DateTime } from 'luxon';

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
admin.initializeApp();
const db = admin.firestore();

export const monitorDamages = functions.firestore
    .document('/reservationObjects/{objectId}/damages/{damageId}')
    .onWrite(async (change, context) => {
        // Relevant Document
        let document = change.after.exists ? change.after.data()! : change.before.data()!;

        // Get all the documents that currently exist for the reservation object
        let docs = (await db.collection(`/reservationObjects/${context.params.objectId}/damages`).get()).docs;

        // Remove the document that triggers this function 
        docs = docs.filter((e) => e.id != (change.after.exists ? change.after.id : change.before.id));

        // Create an array with all the damages
        let data = [...docs.map((e) => e.data())];

        // If we're updating or creating, add the document to the list
        if (change.after.exists) {
            data.push(change.after.data()!);
        }

        // Check if for any critical && active, meaning if the object
        // needs to be set to critical
        let critical = data.filter((e) => e.critical && e.active).length > 0

        // Get the relevant object, as we need to decide if we need to update it
        // and which message to send to any users that have reserved it
        let object = await db.doc(`/reservationObjects/${context.params.objectId}`).get();

        // Check if we need to update the value
        if (object.exists && (object.data()!.critical ?? false) != critical) {
            // Update the object
            await object.ref.update({
                critical: critical,
            });

            // Send a push notification of the change to all users
            // that reserved the boat today or tomorrow
            let today = DateTime.now();
            let tomorrow = today.plus({ days: 3 });

            // Get the relevant reservations
            let reservations = (await db.collection('/reservations')
                .where('object', '==', context.params.objectId)
                .where('startTime', '>=', today.toJSDate())
                .where('startTime', '<=', tomorrow.toJSDate())
                .get()).docs;

            // Send out a push notification to those who this is interesting to
            reservations.forEach((e) => {
                if (e.data().creatorId != null) {
                    admin.messaging().send({
                        topic: e.data().creatorId,
                        notification: {
                            title: `Afschrijving ${document.name} ${critical ? 'uit de vaart' : 'terug in de vaart'}`,
                            body: `${document.name} is zojuist ${critical ? 'uit de vaart gehaald' : 'terug in de vaart geplaatst'}`
                        }
                    });
                }
            });
        }

        // Send a push notification to the 'schade' topic
        admin.messaging().send({
            topic: 'schade',
            notification: {
                title: `Schade ${change.after.exists ? 'gemeld' : 'afgemeld'} voor ${document.name}`,
                body: document.description ?? '',
            }
        });
    });
