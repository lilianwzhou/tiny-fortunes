import shortUUID from "short-uuid";
import { DatabaseManager } from "../mongo/databaseShared.js";
import { UserDetailManager } from "./UserDetails.js";

export class UserManager {
  dbManager = DatabaseManager.shared();
  static sharedInstance;

  Schema = this.dbManager.mongoose().Schema;

  userSchema = new this.Schema({
    _id: String,
    email: String,
    password: String,
    isAdmin: Boolean,
    userDetails: {
      type: this.dbManager.mongoose().Schema.Types.ObjectId,
      ref: "UserDetail",
    },
    lastFortuneGiven: Date,
    seenFortunes: [{ fortuneID: String, nextDate: Date }],
  });

  User = this.dbManager.mongoose().model("User", this.userSchema);

  constructor() {}

  static shared() {
    if (!this.sharedInstance) {
      this.sharedInstance = new UserManager();
    }
    return this.sharedInstance;
  }

  async createUser(userInfo, isAdmin) {
    userInfo._id = shortUUID.generate();
    userInfo.isAdmin = isAdmin;
    const user = new this.User(userInfo);
    let shared = UserDetailManager.shared();
    const userDetails = new shared.UserDetail(userInfo);
    user.userDetails = userDetails;
    await userDetails.save();
    await user.save();
    return userInfo._id;
  }

  async getUserByFromEmail(email) {
    return this.User.findOne({ email: email }).populate("userDetails");
  }

  async deleteUser(userId) {
    await this.User.deleteOne({ _id: userId });
  }

  async getUserFromId(userId) {
    return this.User.findOne({ _id: userId }).populate("userDetails");
  }

  async listUsers(limit = 500, page, searchString) {
    console.log("SEARCH: " + searchString);
    if (searchString) {
      const regex = new RegExp(searchString, "i"); // i for case insensitive
      return this.User.find({ email: { $regex: regex } })
        .limit(limit)
        .skip(limit * page)
        .populate("userDetails")
        .exec();
    }
    return this.User.find()
      .limit(limit)
      .skip(limit * page)
      .populate("userDetails")
      .exec();
  }
}
