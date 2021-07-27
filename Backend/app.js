
const express = require('express')
const helmet = require('helmet');
const swaggerJsDoc = require("swagger-jsdoc");
const swaggerUi = require("swagger-ui-express");
const app = express()
const port = 3000
const validator = require("email-validator");
const passwordValidator = require('password-validator');
const argon2 = require('argon2');
const shortUUID = require('short-uuid');
// Create a schema
var schema = new passwordValidator();
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const jwtSecret = 'My!@!Se3cr8tH4sh';

// Add properties to it
schema
.is().min(8)                                    // Minimum length 8
.is().max(100)                                  // Maximum length 100
// .has().uppercase()                              // Must have uppercase letters
// .has().lowercase()                              // Must have lowercase letters
// .has().digits(2)                                // Must have at least 2 digits
// .has().not().spaces()                           // Should not have spaces
// .is().not().oneOf(['Passw0rd', 'Password123']); // Blacklist these values
 
var testUser = {
  email: "blurp89@gmail.com",
  password: "123456789"
}

argon2.hash("123456789").then((val) =>  {
  testUser.password = val
})

var users = [testUser]

const swaggerOptions = {
    swaggerDefinition: {
      info: {
        version: "1.0.0",
        title: "Fortune Teller",
        description: "Cookies API Documentation",
        servers: ["http://localhost:5000"]
      }
    },
    // ['.routes/*.js']
    apis: ["app.js"]
};
  
const swaggerDocs = swaggerJsDoc(swaggerOptions);

app.use(express.json({limit: '5mb'}));
app.use(helmet());
app.use("/docs", swaggerUi.serve, swaggerUi.setup(swaggerDocs));

// app.use(function (req, res, next) {
//   res.header('Access-Control-Allow-Origin', '*');
//   res.header('Access-Control-Allow-Credentials', 'true');
//   res.header('Access-Control-Allow-Methods', 'GET,HEAD,PUT,PATCH,POST,DELETE');
//   res.header('Access-Control-Expose-Headers', 'Content-Length');
//   res.header('Access-Control-Allow-Headers', req.header('Access-Control-Request-Headers'));
//   if (req.method === 'OPTIONS') {
//       return res.status(200).send();
//   } else {
//       return next();
//   }
// });

/**
 * @swagger
 * /:
 *  get:
 *    summary: Home Endpoint
 *    description: TEST DESCRIPTION
 *    responses:
 *      '200':
 *        description: A successful hello world!
 */
app.get('/', (req, res) => {
  res.send('Hello World!')
})

  /**
 * @swagger
 * /user:
 *  post:
 *    summary: Creates a new user
 *    parameters:
 *      - in: body
 *        name: user
 *        description: The user to create.
 *        schema:
 *          type: object
 *          required:
 *            - email
 *            - password
 *          properties:
 *            email:
 *              type: string
 *            password:
 *              type: string
 *    responses:
 *      '200':
 *        description: Get an ID back with the user..
 */
app.post("/user", async (req, res) => {
    console.log(req.body)

    if(req.body.email === null || req.body.password == null) {
      res.status(400).send("Provide an email and password")
      return
    }
    if (!validator.validate(req.body.email)) {
      res.status(400).send("Please provide a valid email")
      return
    }

    if (!schema.validate(req.body.password)) {
      res.status(400).send("Please provide a password > 8 characters and < than 100")
      return
    }

    hashedPassword = await argon2.hash(req.body.password);
    req.body.password = hashedPassword
    users.push(req.body)
    res.statusCode = 401

    id = shortUUID.generate();
    res.status(200).send({id: id})
})


  /**
 * @swagger
 * /auth:
 *  post:
 *    summary: Gets a JWT for a user
 *    parameters:
 *      - in: body
 *        name: user
 *        description: The user to create.
 *        schema:
 *          type: object
 *          required:
 *            - email
 *            - password
 *          properties:
 *            email:
 *              type: string
 *            password:
 *              type: string
 *    responses:
 *      '200':
 *        description: Get an auth token (JWT) that must be sent in future requests
 */
app.post("/auth", async (req, res) => {
  if(req.body && req.body.email && req.body.password) {
    let user = users.filter((value) => {
      if(value.email === req.body.email) {
        return true
      }
      return false
    })
    if(user && user.length === 1) {
      user = user[0]
      console.log(user)
      let passwordHash = user.password;
      if (await argon2.verify(passwordHash, req.body.password)) {
          req.body = {
              userId: user._id,
              email: user.email,
              provider: 'email',
          };
          try {
            let salt = crypto.randomBytes(16).toString('base64');
            req.body.refreshKey = salt;
            let token = jwt.sign(req.body, jwtSecret, {expiresIn: 1000000000000000000});
            return res.status(201).send({accessToken: token});
          } catch (err) {
            return res.status(500).send(err);
          }
      } else {
          res.status(400).send({errors: `Invalid e-mail and/or password`});
      }
    } else {
      res.status(400).send({errors: `User not found`});
    }
  } else {
    res.status(400).send({error: 'Missing body fields: email, password'});
  }
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})