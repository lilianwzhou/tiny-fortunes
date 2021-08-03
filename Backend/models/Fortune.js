import { DatabaseManager } from "../mongo/databaseShared.js";
import { UserManager } from "./User.js";
export class FortuneManager {
  dbManager = DatabaseManager.shared();
  static sharedInstance;

  Schema = this.dbManager.mongoose().Schema;

  fortuneSchema = new this.Schema({
    _id: String,
    message: String,
    buckets: [
      {
        key: String,
        rule: String,
      },
    ],
  });

  Fortune = this.dbManager.mongoose().model("Fortune", this.fortuneSchema);

  constructor() {}

  static shared() {
    if (!this.sharedInstance) {
      this.sharedInstance = new FortuneManager();
    }
    return this.sharedInstance;
  }

  async getFortune(userID) {
    let user = await UserManager.shared().getUserFromId(userID);

    let date = new Date();
    date.setHours(0, 0, 0, 0);
    console.log(user.lastFortuneGiven);
    if (user.lastFortuneGiven && +user.lastFortuneGiven === +date) {
      return Promise.reject("Be patient, asshole wait a day!");
    } else {
      // user.lastFortuneGiven = date;
      await user.save();
      return { message: "Focus Lilian." };
    }
  }
}

/**
 *
 * MADLIB FORTUNES are of the FORM {} whenever you need KEYS
 *
 *
 * message: "{KEY} went down the road to sugandese"
 *
 *
 * buckets: [BUCKET]
 *
 * bucket: {
 *  key: string
 *  rule: Rule
 * }
 *
 *
 *
 *
 * Rule {
 *  keys: [String]
 *  rule: (EQUAL, RANGE, DISTANCE)
 * }
 */
