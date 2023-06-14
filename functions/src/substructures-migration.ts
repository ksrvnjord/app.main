// In frontend substructures are now saved and displayed under the key 'substructures' instead of 'substructuren'.
// This migration script migrates all substructures from 'substructuren' to 'substructures'.
// This script should be run till 95% of users have migrated to the new version of the app.

import * as functions from "firebase-functions";
import admin from "firebase-admin";
import {onSchedule} from "firebase-functions/v2/scheduler";

const logger = functions.logger;
const db = admin.firestore();

export const substructuresMigration = onSchedule("every day 00:00", async () => {
  const users = await db.collection("people").get();
  for (const doc of users.docs) {
    const data = doc.data();
    if (data.substructuren) {
      await doc.ref.update(
          "substructures", data.substructuren,
      );
    }
  }

  logger.log("User substructures migration finished");
});
