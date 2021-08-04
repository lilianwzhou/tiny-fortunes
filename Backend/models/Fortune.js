import { DatabaseManager } from "../mongo/databaseShared.js";
import { UserManager } from "./User.js";
import shortUUID from "short-uuid";

let numKeys = ["longitude", "latitude"];
let stringKeys = [
  "_id",
  "first_name",
  "last_name",
  "occupation",
  "favourite_colour",
];
let booleanKeys = [
  "pineapples_on_pizza",
  "wipe_standing_up",
  "water_wet",
  "dog_person",
  "touch_grass_today",
  "hulk_flavour_sour_apple",
  "early_bird",
  "likes_sushi",
];
let dateKeys = ["birthday"];
let stringRuleChoices = ["CONTAINS", "EQUALS", "!CONTAINS", "!EQUALS"];
let numberRuleChoices = ["<", "<=", ">=", "!=", "=="];
let boolRuleChoices = ["TRUE", "FALSE"];
let dateRuleChoices = [
  "BEFORE",
  "AFTER",
  "BEFORE IGNORE YEAR",
  "AFTER IGNORE YEAR",
];

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
        operation: String,
        value: this.Schema.Types.Mixed,
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

  shuffleArray(array) {
    for (var i = array.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }
  async getFortune(userID) {
    let date = new Date();
    date.setHours(0, 0, 0, 0);

    let user = await UserManager.shared().getUserFromId(userID);

    if (user.lastFortuneGiven && +user.lastFortuneGiven === +date) {
      return Promise.reject("Be patient, asshole wait a day!");
    }

    user.seenFortunes = user.seenFortunes.filter((val) => {
      if (+val.nextDate < +date) {
        return false;
      }
      return true;
    });

    let ids = user.seenFortunes.map((val) => {
      return val.fortuneID;
    });
    let possibleFortunes = await this.Fortune.find({
      _id: { $nin: ids },
    });

    this.shuffleArray(possibleFortunes);
    for (const fortune of possibleFortunes) {
      //check if we fill the buckets
      console.log(fortune);
      var satisfiesBuckets = true;
      for (const bucket of fortune.buckets) {
        let key = bucket.key;
        let val = false;
        if (
          user.userDetails[key] === undefined ||
          user.userDetails[key] === null
        ) {
          console.log(`Undefined ${key}`);
          satisfiesBuckets = false;
          break;
        }
        if (stringKeys.includes(key)) {
          if (bucket.operation === "CONTAINS") {
            val = user.userDetails[key].includes(bucket.value);
          } else if (bucket.operation === "EQUALS") {
            val = user.userDetails[key] === bucket.value;
          } else if (bucket.operation === "!CONTAINS") {
            val = !user.userDetails[key].includes(bucket.value);
          } else if (bucket.operation === "!EQUALS") {
            val = user.userDetails[key] !== bucket.value;
          }
        } else if (booleanKeys.includes(key)) {
          if (bucket.operation === "TRUE") {
            val = user.userDetails[key] === true;
          } else if (bucket.operation === "FALSE") {
            val = user.userDetails[key] === false;
          }
        } else if (numKeys.includes(key)) {
          if (bucket.operation === "<") {
            val = user.userDetails[key] < bucket.value;
          } else if (bucket.operation === "<=") {
            val = user.userDetails[key] <= bucket.value;
          } else if (bucket.operation === ">=") {
            val = user.userDetails[key] >= bucket.value;
          } else if (bucket.operation === "!=") {
            val = user.userDetails[key] !== bucket.value;
          } else if (bucket.operation === "==") {
            val = user.userDetails[key] === bucket.value;
          }
        } else {
          //birthday
          if (bucket.operation === "BEFORE") {
            val = +user.userDetails[key] < +bucket.value;
          } else if (bucket.operation === "AFTER") {
            val = +user.userDetails[key] > +bucket.value;
          } else if (bucket.operation === "BEFORE IGNORE YEAR") {
            let userDate = new Date(user.userDetails[key]);
            userDate.setFullYear(2000);

            let valDate = new Date(bucket.value);
            valDate.setFullYear(2000);
            val = +userDate < +valDate;
          } else if (bucket.operation === "AFTER IGNORE YEAR") {
            let userDate = new Date(user.userDetails[key]);
            userDate.setFullYear(2000);

            let valDate = new Date(bucket.value);
            valDate.setFullYear(2000);
            val = +userDate > +valDate;
          }
        }
        satisfiesBuckets = satisfiesBuckets && val;
      }
      if (!satisfiesBuckets) {
        continue;
      }
      //Ensure we can get all the fortune madlib data
      try {
        let re = new RegExp(/\{(.*?)\}/, "g");

        let message = fortune.message.replace(re, (match) => {
          match = match.slice(1, -1);
          if (!user.userDetails[match]) {
            throw "No match";
          }
          console.log(match);
          console.log(user.userDetails[match]);
          if (match === "birthday") {
            let d = user.userDetails[match];
            let ye = new Intl.DateTimeFormat("en", { year: "numeric" }).format(
              d
            );
            let mo = new Intl.DateTimeFormat("en", { month: "short" }).format(
              d
            );
            let da = new Intl.DateTimeFormat("en", { day: "2-digit" }).format(
              d
            );
            console.log(`${mo} ${da} ${ye}`);
            return `${mo} ${da} ${ye}`;
          }
          return user.userDetails[match];
        });
        var newDate = new Date(date.setMonth(date.getMonth() + 1));
        user.lastFortuneGiven = date;
        user.seenFortunes.push({
          fortuneID: fortune._id,
          nextDate: newDate,
        });
        await user.save();
        return { message };
      } catch (e) {
        console.log(e);
        continue;
      }
    }

    return {message: "No more fortunes"};
  }

  async addFortune(body) {
    body._id = shortUUID.generate();
    const fortune = new this.Fortune(body);
    await fortune.save();
    return fortune._id;
  }

  async listFortunes(limit = 500, page, searchString) {
    if (searchString) {
      const regex = new RegExp(searchString, "i"); // i for case insensitive
      return this.Fortune.find({ message: { $regex: regex } })
        .limit(limit)
        .skip(limit * page)
        .populate("userDetails")
        .exec();
    }
    return this.Fortune.find()
      .limit(limit)
      .skip(limit * page)
      .exec();
  }

  async delete(fortuneID) {
    let fortune = await this.Fortune.findOne({ _id: fortuneID });
    if (!fortune) {
      throw "Fortune Does not exist!";
    }

    await this.Fortune.deleteOne({ _id: fortuneID });
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
