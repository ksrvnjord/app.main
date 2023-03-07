import * as functions from "firebase-functions";
import admin from "firebase-admin";

admin.initializeApp();

export {createReservation} from "./create-reservation";
export {monitorDamages} from "./monitor-damages";

// Run this function if you want to test the client
export const alwaysSuccesful = functions.region("europe-west1").https
    .onCall(() => {
      return true;
    });
