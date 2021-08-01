import { DatabaseManager } from "../mongo/databaseShared.js";
import { UserManager } from "./User.js";

export class UserDetailManager {
  dbManager = DatabaseManager.shared();
  static sharedInstance;

  Schema = this.dbManager.mongoose().Schema;

  userDetailSchema = new this.Schema({
    _id: String,
    first_name: String,
    last_name: String,
    longitude: Number,
    latitude: Number,
    birthday: Date,
    occupation: String,
    pineapples_on_pizza: Boolean,
    wipe_standing_up: Boolean,
    water_wet: Boolean,
    dog_person: Boolean,
    touch_grass_today: Boolean,
    hulk_flavour_sour_apple: Boolean,
    early_bird: Boolean,
    favourite_colour: String,
    likes_sushi: Boolean,
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
