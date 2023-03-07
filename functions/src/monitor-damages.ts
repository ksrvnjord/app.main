import {logger} from "firebase-functions";
import * as functions from "firebase-functions";
import admin from "firebase-admin";
import {DateTime} from "luxon";

const db = admin.firestore();

export const monitorDamages = functions
    .region("europe-west1")
    .firestore
    .document("/reservationObjects/{objectId}/damages/{damageId}")
    .onWrite(async (change, context) => {
      // Relevant Document
      const document = change.after.exists ? change.after.data() : change.before.data();

      if (document == null) {
        logger.error(
            "Change document assertion failed, the data() from the document should not be null."
        );
        return;
      }

      logger.debug("Amended damage:", document);
      logger.debug("Action: ", context.eventType);

      // Get all the documents that currently exist for the reservation object
      let docs = (await db.collection(`/reservationObjects/${context.params.objectId}/damages`).get()).docs;

      logger.debug("All damages: ", docs);

      // Remove the document that triggers this function
      docs = docs.filter((e) => e.id != (change.after.exists ? change.after.id : change.before.id));

      // Create an array with all the damages
      const data = [...docs.map((e) => e.data())];

      // If we're updating or creating, add the document to the list
      if (change.after.exists) {
        data.push(document);
      }

      logger.debug("Final damages: ", data);

      // Check if for any critical && active, meaning if the object
      // needs to be set to critical
      const critical = data.filter((e) => e.critical && e.active).length > 0;

      logger.debug("Damage Critical: ", critical);

      // Get the relevant object, as we need to decide if we need to update it
      // and which message to send to any users that have reserved it
      const object = await db.doc(`/reservationObjects/${context.params.objectId}`).get();

      logger.debug("Damaged Object: ", object);

      const shouldSetCritical = object.exists &&
        (object.data()?.critical ?? false) != critical;

      logger.debug("Should set critical: ", shouldSetCritical);

      // Check if we need to update the value
      if (shouldSetCritical) {
        // Update the object
        await object.ref.update({
          critical: critical,
        });

        // Send a push notification of the change to all users
        // that reserved the boat today or tomorrow
        const today = DateTime.now();
        const tomorrow = today.plus({days: 3});

        // Get the relevant reservations
        const reservations = (await db.collection("/reservations")
            .where("object", "==", context.params.objectId)
            .where("startTime", ">=", today.toJSDate())
            .where("endTime", "<=", tomorrow.toJSDate())
            .get()).docs;

        logger.debug("Reservations: ", reservations);

        // Send out a push notification to those who this is interesting to
        reservations.forEach((e) => {
          if (e.data().creatorId != null) {
            admin.messaging().send({
              topic: e.data().creatorId,
              notification: {
                title: `Afschrijving ${
                  document.name
                } ${
                  critical ? "uit de vaart" : "terug in de vaart"
                }`,
                body: `${
                  document.name
                } is zojuist ${
                  critical ? "uit de vaart gehaald" : "terug in de vaart geplaatst"
                }`,
              },
            });
          }
        });
      }

      // Send a push notification to the 'schade' topic
      admin.messaging().send({
        topic: "schade",
        notification: {
          title: `Schade ${change.after.exists ? "gemeld" : "afgemeld"} voor ${document.name}`,
          body: document.description ?? "",
        },
      });
    });
