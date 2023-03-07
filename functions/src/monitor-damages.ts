import functions from 'firebase-functions'
import admin from 'firebase-admin'
import { DateTime } from 'luxon';

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
admin.initializeApp();
const db = admin.firestore();

exports.monitorDamages = functions.firestore
    .document('/reservationObjects/{objectId}/damages/{damageId}')
    .onWrite(async (change, context) => {
        // Relevant Document
        let document = change.after.exists ? change.after.data()! : change.before.data()!;

        // Get all the documents that currently exist for the reservation object
        let docs = (await db.collection(`/reservationObjects/${context.params.objectId}/damages`).get()).docs;

        // Remove the document that we're modifying from the array
        docs = docs.filter((e) => e.id != (change.after.exists ? change.after.id : change.before.id));

        // Create an array with all the data
        let data = [...docs.map((e) => e.data())];

        // Add back the document after update
        if (change.after.exists) {
            data.push(change.after.data()!);
        }

        // Check if there's any critical && active damage, if so
        // set the object to critical
        let critical = data.filter((e) => e.critical && e.active).length

        // Update the object
        await db.doc(`/reservationObjects/${context.params.objectId}`).update({
            critical: critical,
        })

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
            // Send a mess
            if (e.data().creatorId != null) {
                admin.messaging().send({
                    topic: e.data().creatorId,
                    notification: {
                        title: `Afschrijving ${document.name} ${critical ? 'uit de vaart' : 'terug in de vaart'}`,
                        body: `${document.name} is zojuist ${critical ? 'uit de vaart gehaald' : 'terug in de vaart geplaatst'}`
                    }
                });
            }

            // Future function, also to people who are invited to the
            // training / afschrijving
            if (e.data().invitees != null) {
                e.data().invitees.forEach((i: string) => {
                    admin.messaging().send({
                        topic: i,
                        notification: {
                            title: `Afschrijving ${document.name} ${critical ? 'uit de vaart' : 'terug in de vaart'}`,
                            body: `${document.name} is zojuist ${critical ? 'uit de vaart gehaald' : 'terug in de vaart geplaatst'}`
                        }
                    });
                });
            }
        });
    });