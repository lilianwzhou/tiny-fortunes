import { DatabaseManager } from "../mongo/databaseShared.js";
import { UserManager } from "./User.js";

export class UserDetailManager {
  dbManager = DatabaseManager.shared();
  static sharedInstance;

  Schema = this.dbManager.mongoose().Schema;

  userDetailSchema = new this.Schema({
    _id: String,
    first_name: String,
    longitude: Number,
    latitude: Number,
    birthday: Date,
  });

  UserDetail = this.dbManager
    .mongoose()
    .model("UserDetail", this.userDetailSchema);

  constructor() {}

  static shared() {
    if (!this.sharedInstance) {
      this.sharedInstance = new UserDetailManager();
    }
    return this.sharedInstance;
  }

  async editUserInformation(userID, information) {
    let user = await UserManager.shared().User.findById(userID);
    let detailID = user.userDetails;
    let userDetails = await this.UserDetail.findOne({ _id: detailID });

    if (!user) {
      throw "Cannot find User";
    }
    if (!userDetails) {
      throw "Cannot find userDetails for User";
    }

    Object.keys(information).forEach(function (k) {
      userDetails[k] = information[k];
    });

    await userDetails.save();
  }

  async list(limit = 25, page) {
    return this.UserDetail.find()
      .limit(limit)
      .skip(limit * page)
      .exec();
  }
}
