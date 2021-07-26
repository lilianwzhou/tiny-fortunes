
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
 
// Add properties to it
schema
.is().min(8)                                    // Minimum length 8
.is().max(100)                                  // Maximum length 100
// .has().uppercase()                              // Must have uppercase letters
// .has().lowercase()                              // Must have lowercase letters
// .has().digits(2)                                // Must have at least 2 digits
// .has().not().spaces()                           // Should not have spaces
// .is().not().oneOf(['Passw0rd', 'Password123']); // Blacklist these values
 

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

app.use(function (req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Credentials', 'true');
  res.header('Access-Control-Allow-Methods', 'GET,HEAD,PUT,PATCH,POST,DELETE');
  res.header('Access-Control-Expose-Headers', 'Content-Length');
  res.header('Access-Control-Allow-Headers', req.header('Access-Control-Request-Headers'));
  if (req.method === 'OPTIONS') {
      return res.status(200).send();
  } else {
      return next();
  }
});

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
app.post("/user", (req, res) => {
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

    hashedPassword = argon2.hash(req.body.password);
    res.statusCode = 401

    id = shortUUID.generate();
    res.status(200).send({id: id})
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})