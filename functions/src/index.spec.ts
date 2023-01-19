import * as firebaseFunctionsTest from "firebase-functions-test";
import {assert} from "chai";
import {alwaysSucces} from "./index";

const {wrap} = firebaseFunctionsTest();

describe("alwaysSucces", () => {
  it("should return success", async () => {
    const wrapped = wrap(alwaysSucces);
    wrapped({});

    return assert.equal(wrapped({}), true);
  });
});
