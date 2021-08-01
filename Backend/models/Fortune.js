import { DatabaseManager } from "../mongo/databaseShared.js";

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
