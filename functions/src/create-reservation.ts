import * as functions from "firebase-functions";
import {DateTime} from "luxon";
import admin from "firebase-admin";

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
const clientFunction = functions.region("europe-west1").https;
const logger = functions.logger;
admin.initializeApp();
const db = admin.firestore();

export const createReservation = clientFunction
    .onCall(async (data, context) => {
      const uid = context.auth?.uid;
      logger.debug(`${uid} sent request`, data);

      const reservationObjectRef = db.doc(data.object);

      const snapshot = await reservationObjectRef.get();
      if (!snapshot.exists) {
        logger.error("ReservationObject does not exist");
        return {success: false, error: "ReservationObject does not exist"};
      }

      const reservationObject = snapshot.data();
      logger.log(reservationObject);

      // TODO: check if object is available at set times
      // TODO: check if object has status available
      // TODO: check if user has permission to reserve object

      const reservation = {
        createdTime: DateTime.now().toJSDate(),
        creatorId: uid,
        creatorName: data.creatorName,
        endTime: DateTime.fromISO(data.endTime).toJSDate(),
        object: reservationObjectRef,
        objectName: data.objectName,
        startTime: DateTime.fromISO(data.startTime).toJSDate(),
      };

      try {
        await db.collection("reservations").add(reservation);
      } catch (e) {
        logger.error(e);
        return {success: false, error: e};
      }
      return {success: true};
    });
