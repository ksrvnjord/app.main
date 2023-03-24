import * as functions from "firebase-functions";
import {DateTime} from "luxon";
import admin from "firebase-admin";
import {DocumentData, DocumentReference, Timestamp} from "firebase-admin/firestore";

const clientFunction = functions.region("europe-west1").https;
const logger = functions.logger;
const db = admin.firestore();

export const createReservation = clientFunction
    .onCall(async (data, context) => {
      // VALIDATION //
      if (!context.auth) {
        return Reporter.fail({message: "Je bent niet ingelogd"});
      }
      const requiredFields = ["creatorName", "endTime", "object", "objectName", "startTime"];
      // check if all required fields are present
      const missingFields = requiredFields.filter((f) => !data[f]);
      if (missingFields.length > 0) {
        return Reporter.fail({message: `Je verzoek heeft missende velden: ${missingFields.join(", ")}`});
      }
      const startTime = DateTime.fromISO(data.startTime);
      const endTime = DateTime.fromISO(data.endTime);
      const uid = context.auth.uid;
      logger.debug(`${uid} sent reservation request`, data);

      const reservationObjectRef = db.doc(data.object);
      const reservationObject = (await reservationObjectRef.get()).data();
      if (!reservationObject) {
        return Reporter.fail({message: `We konden ${data.objectName} niet vinden`});
      }


      const user = (await db.collection("people").doc(uid).get()).data();
      if (!user) {
        return Reporter.fail({message: "We konden je gebruiker niet vinden"});
      }

      const permissionsReport = checkPermissions({reservationObject, user});
      if (!permissionsReport.success) {
        return permissionsReport;
      }

      const availabilityReport = await checkObjectAvailability(
          {ref: reservationObjectRef, object: reservationObject, startTime, endTime});
      if (!availabilityReport.success) {
        return availabilityReport;
      }

      // Request is valid, create reservation
      const reservation = {
        createdTime: DateTime.now().toJSDate(),
        creatorId: uid,
        creatorName: data.creatorName,
        endTime: endTime.toJSDate(),
        object: reservationObjectRef,
        objectName: data.objectName,
        startTime: startTime.toJSDate(),
      };

      try {
        const ref = await db.collection("reservations").add(reservation);
        logger.log("Reservation created", ref.id);
      } catch (e) {
        return Reporter.fail({message: "Het is niet gelukt om een reservering te maken" + e});
      }
      return {success: true};
    });


/**
 * Checks if the user has permission to reserve the reservationObject
 * @return {Report} reports the result
 */
function checkPermissions({reservationObject, user}:
  { reservationObject: DocumentData, user: DocumentData}): Report {
  if (!user.permissions) {
    return Reporter.fail({message: "We konnen je permissies niet vinden"});
  }
  const userPermissions: Array<string> = user.permissions;
  if (userPermissions.includes("admin")) { // admins can always reserve
    return Reporter.success();
  }

  const reservationObjectPermissions: Array<string> = reservationObject?.permissions;
  const objectIsPermissioned = reservationObjectPermissions.length > 0;
  const userHasRequiredPermission = userPermissions
      .some((p) => reservationObjectPermissions.includes(p));

  if (objectIsPermissioned && !userHasRequiredPermission) {
    return Reporter.fail({message: `Je hebt niet de juiste permissies om ${reservationObject.name} te reserveren`});
  }
  return Reporter.success();
}

/**
 * Checks if the reservationObject is available for reservation
 * @return {Promise<boolean>} true if the reservationObject is available, false otherwise
 */
async function checkObjectAvailability({ref, object, startTime, endTime}:
  { ref: DocumentReference, object: DocumentData, startTime: DateTime, endTime: DateTime }):
  Promise<Report> {
  if (!reservationObjectIsAvailable(object)) {
    return Reporter.fail({message: `${object.name} is gemarkeerd als onbeschikbaar`});
  }

  if (await hasOverlappingTimeslots({reservationObjectRef: ref, startTime, endTime})) {
    return Reporter.fail({message: `${object.name} is niet beschikbaar op je gekozen tijden`});
  }
  return Reporter.success();
}

/**
 * Checks if the user has permission to reserve the reservationObject
 */
interface Report {
  success: boolean;
  error?: string;
}

/**
 * Helper class for logging errors and returning a failure response
 */
class Reporter {
  /**
   * Logs the error message and returns a failure response
   * @param {string} message
   * @return {{success: boolean, error: string}} The error message
   */
  static fail({message}: { message: string; }): { success: boolean; error: string; } {
    logger.error(message);
    return {success: false, error: message};
  }

  /**
   * Returns a success response
   * @return {{success: boolean}} A success response
   */
  static success(): { success: boolean; } {
    return {success: true};
  }
}

/**
 * Checks if the reservationObject is available
 * @param {DocumentData} reservationObject The reservation object to check
 * @return {boolean} true if the reservationObject is available, false otherwise
 */
function reservationObjectIsAvailable(reservationObject: DocumentData): boolean {
  return reservationObject.available === true;
}

/**
 * Checks if there is a reservation for the given reservationObjectRef that overlaps with the given timeslot
 *
 * It is assumed that the timeslot is within the same day
 * @return {Promise<boolean>} true if there is an overlapping reservation, false otherwise
 */
async function hasOverlappingTimeslots(
    {reservationObjectRef, startTime, endTime}:
{ reservationObjectRef: DocumentReference; startTime: DateTime; endTime: DateTime; }): Promise<boolean> {
  const startDate = startTime.startOf("day");
  const reservationsSnapshot = await db.collection("reservations")
      .where("object", "==", reservationObjectRef)
      .where("startTime", ">=", startDate.toJSDate())
      .where("startTime", "<=", endTime.toJSDate())
      .get();

  for (const doc of reservationsSnapshot.docs) {
    const r = doc.data();
    const startTimestamp: Timestamp = r.startTime;
    const endTimestamp: Timestamp = r.endTime;
    // convert to Luxon DateTime for easier comparison
    const otherStartTime = DateTime.fromJSDate(startTimestamp.toDate());
    const otherEndTime = DateTime.fromJSDate(endTimestamp.toDate());

    if (startTime < otherEndTime && endTime > otherStartTime) {
      return true;
    }
  }
  return false;
}
