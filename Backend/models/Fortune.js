import { DatabaseManager } from "../mongo/databaseShared.js";
import { UserManager } from "./User.js";

export class FortuneManager {
  dbManager = DatabaseManager.shared();
  static sharedInstance;

  Schema = this.dbManager.mongoose().Schema;

  fortuneSchema = new this.Schema({
    _id: String,
    message: Number,
    isQuestionDependent: Boolean,
    maxDistance: Number,
    details: {
      type: this.dbManager.mongoose().Schema.Types.ObjectId,
      ref: "UserDetail",
    },
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
