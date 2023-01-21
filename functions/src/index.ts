import * as functions from "firebase-functions";

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
const secureFunction = functions.region("europe-west1").https;

export const test = secureFunction.onCall((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  return {message: "Hello from Firebase!"};
});
