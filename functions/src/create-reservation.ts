import * as functions from "firebase-functions";

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
const clientFunction = functions.region("europe-west1").https;

// Run this function if you want to test the client
export const createReservation = clientFunction.onCall((data, context) => {
  const uid = context.auth?.uid;
  return {success: true, uid: uid};
});
