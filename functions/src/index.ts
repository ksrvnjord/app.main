import * as functions from "firebase-functions";

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
const secureFunction = functions.region("europe-west1").https;

export const alwaysSucces = secureFunction.onCall(() => {
  return {success: true};
});
