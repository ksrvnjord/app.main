import firebaseFunctionsTest from "firebase-functions-test";
import {assert} from "chai";
import {createReservation as createMockReservation} from "../src/index";
import admin from "firebase-admin";
import {DateTime} from "luxon/src/datetime";
import {DocumentReference} from "firebase-admin/lib/firestore";

admin.initializeApp(
    {
      // eslint-disable-next-line max-len
      credential: admin.credential.cert("ksrv-njord-dev-firebase-adminsdk-njigg-cf31ce8c1d.json"),
      projectId: "ksrv-njord-dev",
    }
);

const db = admin.firestore();

const {wrap, cleanup} = firebaseFunctionsTest({
  projectId: "ksrv-njord-dev",
}, "../ksrv-njord-dev-firebase-adminsdk-njigg-cf31ce8c1d.json");

describe("createReservation", () => {
  const wrapped = wrap(createMockReservation);

  before(async () => {
    const reservationObject = {
      name: generateRandomName(),
    };
    // add to object to the reservationObjects collection
    const ref: DocumentReference = await db.collection("reservationObjects")
        .add(reservationObject);
    const startTime = DateTime.local().plus({weeks: 1}).toJSDate();
    const endTime = DateTime.local()
        .plus({weeks: 1, hours: 1}).toJSDate();

    const reservation = {
      startTime: startTime,
      endTime: endTime,
      object: ref,
    };
    // add the reservation to the reservations collection
    await db.collection("reservations").add(reservation);
  });

  // after this test, we need to remove entire reservations collection
  after(async () => {
    cleanup();
    // delete all reservationObjects
    (await db.collection("reservationObjects").get()).forEach((doc) => {
      doc.ref.delete();
    });

    // delete all reservations
    (await db.collection("reservations").get()).forEach((doc) => {
      doc.ref.delete();
    }
    );
  });

  it("should return success", async () => {
    const output = wrapped({});

    return assert.equal(output.success, true);
  });
});


/**
 * Generates a random string.
 * @return {string} A random string.
 */
function generateRandomName() : string {
  return Math.random().toString(36).substring(7);
}
