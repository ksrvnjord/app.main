import * as functions from "firebase-functions";

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
const clientFunction = functions.region("europe-west1").https;
const logger = functions.logger;

// Run this function if you want to test the client
export const createReservation = clientFunction.onCall((data, context) => {
  logger.debug(`${context.auth?.uid} sent request`, data);
  const uid = context.auth?.uid;

  const validationResult = hasRequiredFields(data);
  if (!validationResult.success) {
    return validationResult.toObject();
  }

  return {success: true, uid: uid};
});

/**
 * Class for validation results
 * @param {boolean} success - True if validation was successful
 * @param {string} error - The error message
 */
class ValidationResult {
  success: boolean;
  error: string;

  /**
   * Constructor for ValidationResult
   * @param {boolean} success
   * @param {string} error
   */
  constructor(success: boolean, error?: string) {
    this.success = success;
    this.error = error ?? "";
  }

  /**
   * Returns a positive validation result
   * @return {ValidationResult} - A positive validation result
   */
  static positive(): ValidationResult {
    return new ValidationResult(true);
  }

  /**
   * Returns a negative validation result
   * @param {string} error - The error message
   * @return {ValidationResult} - A negative validation result
   */
  static negative(error: string): ValidationResult {
    return new ValidationResult(false, error);
  }

  /**
   * Returns the object representation of the validation result
   * @return {object} - The object representation of the validation result
   */
  toObject(): object {
    return {
      success: this.success,
      error: this.error,
    };
  }
}

/**
 * Checks if reservation has all required fields
 *
 * @param {object} reservation - The reservation to check
 * @return {boolean} - True if all required fields are present
 */
function hasRequiredFields(reservation: object): ValidationResult {
  const requiredFields = ["startTime", "endTime", "object"];
  for (const field of requiredFields) {
    if (!Object.prototype.hasOwnProperty.call(reservation, field)) {
      return ValidationResult.negative("Missing field: " + field);
    }
  }
  return ValidationResult.positive();
}
