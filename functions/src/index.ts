import * as functions from "firebase-functions";
export {createReservation} from "./create-reservation";


// Run this function if you want to test the client
export const alwaysSuccesful = functions.region("europe-west1").https
    .onCall(() => {
      return true;
    });


