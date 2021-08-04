import express from "express";
import helmet from "helmet";
import swaggerJSDoc from "swagger-jsdoc";
import * as swaggerUi from "swagger-ui-express";
import * as validator from "email-validator";
import passwordValidator from "password-validator";
import * as argon2 from "argon2";
import jwt from "jsonwebtoken";
import * as crypto from "crypto";
import morgan from "morgan";
import { UserManager } from "./models/User.js";
import { UserDetailManager } from "./models/UserDetails.js";
import dotenv from "dotenv";
import { AuthMiddleware } from "./middleware/jwt.js";
import { FortuneManager } from "./models/Fortune.js";
import cors from "cors";
dotenv.config();

const app = express();

UserManager.shared();
UserDetailManager.shared();
FortuneManager.shared();
// Create a schema
var schema = new passwordValidator();

// Add properties to it
schema
  .is()
  .min(8) // Minimum length 8
  .is()
  .max(100); // Maximum length 100

const swaggerOptions = {
  swaggerDefinition: {
    openapi: "3.0.0", // YOU NEED THIS
    info: {
      version: "1.0.0",
      title: "Fortune Teller",
      description: "Cookies API Documentation",
      servers: ["http://localhost:3000"],
    },
    basePath: "/",
    components: {
      securitySchemes: {
        bearerAuth: {
          type: "http",
          scheme: "bearer",
          bearerFormat: "JWT",
        },
      },
    },
    security: [
      {
        bearerAuth: [],
      },
    ],
  },
  // ['.routes/*.js']
  apis: ["app.js"],
};

const swaggerDocs = swaggerJSDoc(swaggerOptions);

app.use(cors());

if (process.env.NODE_ENV === "development") {
  morgan.token("body", (req, res) => JSON.stringify(req.body));
  morgan.token("resBody", (_req, res) => {
    if (!res.__custombody__) {
      return "";
    }
    try {
      JSON.parse(res.__custombody__);
    } catch (e) {
      if (
        typeof res.__custombody__ === "string" ||
        res.__custombody__ instanceof String
      ) {
        return res.__custombody__.substring(0, 100);
      }

      return "";
    }
    return "JSON";
  });

  const originalSend = app.response.send;

  app.response.send = function sendOverWrite(body) {
    originalSend.call(this, body);
    this.__custombody__ = body;
  };

  app.use(
    morgan(
      ":method :url :status :response-time ms - :res[content-length] :body - :req[content-length] :resBody"
    )
  );

  app.use("/docs", swaggerUi.serve, swaggerUi.setup(swaggerDocs));
}
if (process.env.NODE_ENV === "production") {
  app.use(morgan("tiny"));
}

app.use(express.json({ limit: "5mb" }));
app.use(helmet());
let auth = AuthMiddleware.shared();

app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Credentials", "true");
  res.header("Access-Control-Allow-Methods", "GET,HEAD,PUT,PATCH,POST,DELETE");
  res.header("Access-Control-Expose-Headers", "Content-Length");
  res.header(
    "Access-Control-Allow-Headers",
    req.header("Access-Control-Request-Headers")
  );
  if (req.method === "OPTIONS") {
    return res.status(200).send();
  } else {
    return next();
  }
});

if (process.env.NODE_ENV === "production") {
  app.use(auth.requireClientKey);
}

/**
 * @swagger
 * /user/admin:
 *  post:
 *    summary: Creates an admin user, SWAGGER ONLY
 *    parameters:
 *        - in: header
 *          name: authorization-client
 *          schema:
 *            type: string
 *          required: false
 *    requestBody:
 *        required: true
 *        description: The user to create.
 *        content:
 *          application/json:
 *            schema:
 *              type: object
 *              required:
 *                - email
 *                - password
 *              properties:
 *                email:
 *                  type: string
 *                password:
 *                  type: string
 *    responses:
 *      '200':
 *        description: Get an ID back with the user..
 */
app.post("/user/admin", [
  auth.validateAuth,
  auth.adminOnly,
  async (req, res) => {
    if (req.body.email === null || req.body.password == null) {
      res.status(400).send("Provide an email and password");
      return;
    }
    if (!validator.validate(req.body.email)) {
      res.status(400).send("Please provide a valid email");
      return;
    }

    if (!schema.validate(req.body.password)) {
      res
        .status(400)
        .send("Please provide a password > 8 characters and < than 100");
      return;
    }

    let existingUser = await UserManager.shared().getUserByFromEmail(
      req.body.email
    );

    if (existingUser) {
      res.status(400).send("User already exists");
      return;
    }

    let hashedPassword = await argon2.hash(req.body.password);
    req.body.password = hashedPassword;

    let id = await UserManager.shared().createUser(req.body, true);
    res.status(200).send({ id: id });
  },
]);

/**
 * @swagger
 * /fortune:
 *  post:
 *    summary: Creates a new fortune
 *    parameters:
 *        - in: header
 *          name: authorization-client
 *          schema:
 *            type: string
 *          required: false
 *    requestBody:
 *        required: true
 *        description: The fortune to create.
 *        content:
 *          application/json:
 *            schema:
 *              type: object
 *              required:
 *                - message
 *              properties:
 *                message:
 *                  type: string
 *                buckets:
 *                  type: object
 *    responses:
 *      '200':
 *        description: Get an ID back with the user..
 */
app.post("/fortune", [
  auth.validateAuth,
  auth.adminOnly,
  async (req, res) => {
    if (req.body.message === null) {
      res.status(400).send("Provide a message");
      return;
    }

    let id = await FortuneManager.shared().addFortune(req.body);
    res.status(200).send({ id: id });
  },
]);

/**
 * @swagger
 * /fortunes:
 *  get:
 *    summary: Gets fortunes
 *    parameters:
 *        - in: header
 *          name: authorization-client
 *          schema:
 *            type: string
 *          required: false
 *    responses:
 *      '200':
 *        description: List of fortunes
 */
app.get("/fortunes", [
  auth.validateAuth,
  auth.adminOnly,
  async (req, res) => {
    let fortunes = await FortuneManager.shared().listFortunes(
      500,
      0,
      req.query.search
    );

    res.status(200).send(fortunes);
  },
]);
/**
 * @swagger
 * /users:
 *  get:
 *    summary: Gets users
 *    parameters:
 *        - in: header
 *          name: authorization-client
 *          schema:
 *            type: string
 *          required: false
 *    responses:
 *      '200':
 *        description: List of users
 */
app.get("/users", [
  auth.validateAuth,
  auth.adminOnly,
  async (req, res) => {
    console.log(req.query.search);
    let users = await UserManager.shared().listUsers(500, 0, req.query.search);

    res.status(200).send(users);
  },
]);

/**
 * @swagger
 * /usersDetails:
 *  get:
 *    summary: Gets UserDetail objects
 *    parameters:
 *        - in: header
 *          name: authorization-client
 *          schema:
 *            type: string
 *          required: false
 *    responses:
 *      '200':
 *        description: List of users detail
 */
app.get("/usersDetails", [
  auth.validateAuth,
  auth.adminOnly,
  async (req, res) => {
    let users = await UserDetailManager.shared().list(25, 0);

    res.status(200).send(users);
  },
]);

/**
 * @swagger
 * /user:
 *  post:
 *    summary: Creates a new user
 *    parameters:
 *        - in: header
 *          name: authorization-client
 *          schema:
 *            type: string
 *          required: false
 *    requestBody:
 *        required: true
 *        description: The user to create.
 *        content:
 *          application/json:
 *            schema:
 *              type: object
 *              required:
 *                - email
 *                - password
 *              properties:
 *                email:
 *                  type: string
 *                password:
 *                  type: string
 *    responses:
 *      '200':
 *        description: Get an ID back with the user..
 */
app.post("/user", async (req, res) => {
  if (req.body.email === null || req.body.password == null) {
    res.status(400).send("Provide an email and password");
    return;
  }
  if (!validator.validate(req.body.email)) {
    res.status(400).send("Please provide a valid email");
    return;
  }

  if (!schema.validate(req.body.password)) {
    res
      .status(400)
      .send("Please provide a password > 8 characters and < than 100");
    return;
  }

  let existingUser = await UserManager.shared().getUserByFromEmail(
    req.body.email
  );

  if (existingUser) {
    res.status(400).send("User already exists");
    return;
  }

  let hashedPassword = await argon2.hash(req.body.password);
  req.body.password = hashedPassword;

  let id = await UserManager.shared().createUser(req.body, false);
  res.status(200).send({ id: id });
});

/**
 * @swagger
 * /user/{userID}:
 *  patch:
 *    summary: Updates User Information
 *    parameters:
 *      - in: header
 *        name: authorization-client
 *        schema:
 *          type: string
 *        required: false
 *      - in: path
 *        name: userID
 *        description: The user id to patch.
 *        schema:
 *          type: string
 *          required: true
 *    requestBody:
 *        required: true
 *        description: The details to add to the user.
 *        content:
 *          application/json:
 *            schema:
 *              type: object
 *              required:
 *                - first_name
 *                - last_name
 *              properties:
 *                first_name:
 *                  type: string
 *                last_name:
 *                  type: string
 *                latitude:
 *                  type: number
 *                longitude:
 *                  type: number
 *                birthday:
 *                  type: string
 *                  format: date
 *                occupation:
 *                  type: string
 *                pineapples_on_pizza:
 *                  type: boolean
 *                wipe_standing_up:
 *                  type: boolean
 *                water_wet:
 *                  type: boolean
 *                dog_person:
 *                  type: boolean
 *                touch_grass_today:
 *                  type: boolean
 *                hulk_flavour_sour_apple:
 *                  type: boolean
 *                early_bird:
 *                  type: boolean
 *                favourite_colour:
 *                  type: string
 *                likes_sushi:
 *                  type: boolean
 *    responses:
 *      '200':
 *        description: Successfully patched user with new info
 */
app.patch("/user/:userID", [
  auth.validateAuth,
  auth.sameUserOrAdmin,
  async (req, res) => {
    try {
      await UserDetailManager.shared().editUserInformation(
        req.params.userID,
        req.body
      );
      res.status(200).send("Successfully patched user details");
    } catch (e) {
      console.log(e);
      res.status(400).send(e);
    }
  },
]);

/**
 * @swagger
 * /user/{userID}:
 *  get:
 *    summary: Gets specific user
 *    parameters:
 *      - in: header
 *        name: authorization-client
 *        schema:
 *          type: string
 *        required: false
 *      - in: path
 *        name: userID
 *        description: The user id to patch.
 *        schema:
 *          type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: Successfully patched user with new info
 */
app.get("/user/:userID", [
  auth.validateAuth,
  auth.sameUserOrAdmin,
  async (req, res) => {
    let user = await UserManager.shared().getUserFromId(req.params.userID);
    if (user) {
      res.status(200).send(user);
    } else {
      res.status(400).send("User not found");
    }
  },
]);

/**
 * @swagger
 * /fortune/{userID}:
 *  get:
 *    summary: Gets specific user
 *    parameters:
 *      - in: header
 *        name: authorization-client
 *        schema:
 *          type: string
 *        required: false
 *      - in: path
 *        name: userID
 *        description: The user id to get a fortune for.
 *        schema:
 *          type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: Successfully patched user with new info
 */
app.get("/fortune/:userID", [
  auth.validateAuth,
  auth.sameUserOrAdmin,
  async (req, res) => {
    try {
      let message = await FortuneManager.shared().getFortune(req.params.userID);
      res.status(200).send(message);
    } catch (err) {
      console.log(err);
      res.status(400).send(err);
    }
  },
]);

/**
 * @swagger
 * /user/{userID}:
 *  delete:
 *    summary: Deletes User
 *    parameters:
 *      - in: header
 *        name: authorization-client
 *        schema:
 *          type: string
 *        required: false
 *      - in: path
 *        name: userID
 *        description: The user id to delete.
 *        schema:
 *          type: string
 *          required: true
 *    responses:
 *      '204':
 *        description: Deleted a user with ID..
 */
app.delete("/user/:userID", [
  auth.validateAuth,
  auth.sameUserOrAdmin,
  async (req, res) => {
    if (req.params === null || req.params.userID == null) {
      res.status(400).send("Provide a user ID");
      return;
    }

    let user = await UserManager.shared().getUserFromId(req.params.userID);

    if (!user) {
      res.status(400).send("User Does Not Exist");
      return;
    }
    await UserManager.shared().deleteUser(req.params.userID);

    res.status(204).send("Deleted User");
  },
]);

/**
 * @swagger
 * /fortune/{fortuneID}:
 *  delete:
 *    summary: Deletes Fortune
 *    parameters:
 *      - in: header
 *        name: authorization-client
 *        schema:
 *          type: string
 *        required: false
 *      - in: path
 *        name: fortuneID
 *        description: The fortune id to delete.
 *        schema:
 *          type: string
 *          required: true
 *    responses:
 *      '204':
 *        description: Deleted a fortune with ID..
 */
app.delete("/fortune/:fortuneID", [
  auth.validateAuth,
  auth.sameUserOrAdmin,
  async (req, res) => {
    if (req.params === null || req.params.fortuneID == null) {
      res.status(400).send("Provide a fortune ID");
      return;
    }

    try {
      await FortuneManager.shared().delete(req.params.fortuneID);
    } catch (e) {
      res.status(400).send(e);
      return;
    }

    res.status(204).send("Deleted Fortune");
  },
]);

/**
 * @swagger
 * /auth:
 *  post:
 *    summary: Gets a JWT for a user
 *    parameters:
 *        - in: header
 *          name: authorization-client
 *          schema:
 *            type: string
 *          required: false
 *    requestBody:
 *        required: true
 *        description: The user to create.
 *        content:
 *          application/json:
 *            schema:
 *              type: object
 *              required:
 *                - email
 *                - password
 *              properties:
 *                email:
 *                  type: string
 *                password:
 *                  type: string
 *    responses:
 *      '200':
 *        description: Get an auth token (JWT) that must be sent in future requests
 */
app.post("/auth", async (req, res) => {
  if (req.body && req.body.email && req.body.password) {
    let user = await UserManager.shared().getUserByFromEmail(req.body.email);
    if (user) {
      let passwordHash = user.password;
      if (await argon2.verify(passwordHash, req.body.password)) {
        req.body = {
          userID: user._id,
          email: user.email,
          provider: "email",
        };
        try {
          let salt = crypto.randomBytes(16).toString("base64");
          req.body.refreshKey = salt;
          if (user.isAdmin === true) {
            req.body.isAdmin = true;
          } else {
            req.body.isAdmin = false;
          }
          if (req.query.isAdmin === "true" && req.body.isAdmin === false) {
            return res.status(403).send("Invalid Permissions");
          }
          let token = jwt.sign(req.body, process.env.JWT_SECRET, {
            expiresIn: 1000000000000000000,
          });
          return res.status(201).send({ accessToken: token, userID: user._id });
        } catch (err) {
          console.log(err);
          return res.status(500).send(err);
        }
      } else {
        res.status(400).send(`Invalid e-mail and/or password`);
      }
    } else {
      res.status(400).send(`User not found`);
    }
  } else {
    res.status(400).send("Missing body fields: email, password");
  }
});

app.listen(process.env.PORT || 3000, () => {
  console.log(`Listening`);
});
