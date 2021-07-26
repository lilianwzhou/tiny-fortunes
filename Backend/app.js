
const express = require('express')
const helmet = require('helmet');
const bodyParser = require('body-parser');
const swaggerJsDoc = require("swagger-jsdoc");
const swaggerUi = require("swagger-ui-express");
const app = express()
const port = 3000

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

app.use(bodyParser.json({limit: '5mb'}));
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
 * /users:
 *  get:
 *    summary: Get's all the users in the db
 *    responses:
 *      '200':
 *        description: All users with name, email, password, etc.
 *  post:
 *    summary: Creates a new user
 *    responses:
 *      '200':
 *        description: Get an ID back with the user..
 */
app.get('/users', (req, res) => {
    res.send({
        name: "terry cruz"
    })
    console.log(req.query)
  })

app.post("/user", (req, res) => {
    console.log(req.body)

    // WRITE TO THE DB with the new user
    // FIRST CHECK IF EMAIL already exists
    //if it does, do a res.send("erromessage")
    res.statusCode = 401
    res.send("Here")
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})