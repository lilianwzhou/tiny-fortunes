import mongoose from "mongoose";

export class DatabaseManager {
  static sharedInstance;

  constructor() {
    this.connect();
  }

  static shared() {
    if (!this.sharedInstance) {
      this.sharedInstance = new DatabaseManager();
    }
    return this.sharedInstance;
  }

  mongoose() {
    return mongoose;
  }

  connect() {
    console.log("Connecting to mongoDB");
    mongoose
      .connect(process.env.MONGO_URL, {
        useNewUrlParser: true,
        useUnifiedTopology: true,
      })
      .then(() => {
        console.log("MongoDB is connected");
      })
      .catch((err) => {
        console.log(
          "MongoDB connection unsuccessful, retry after 5 seconds. ",
          ++this.count
        );
        setTimeout(this.connectWithRetry, 5000);
      });
  }
}
