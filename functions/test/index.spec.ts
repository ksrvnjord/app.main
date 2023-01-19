import * as firebaseFunctionsTest from "firebase-functions-test";
import {assert} from "chai";
import {alwaysSucces} from "../src/index";

const {wrap} = firebaseFunctionsTest();

describe("alwaysSucces", () => {
  it("should return success", async () => {
    const wrapped = wrap(alwaysSucces);
    const output = wrapped({});

    return assert.equal(output.success, true);
  });
});
