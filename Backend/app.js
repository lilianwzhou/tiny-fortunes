
const express = require('express')
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
app.use("/docs", swaggerUi.serve, swaggerUi.setup(swaggerDocs));


/**
 * @swagger
 * /:
 *  get:
 *    description: TEST DESCRIPTION
 *    responses:
 *      '200':
 *        description: A successful hello world!
 */
app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.get('/user', (req, res) => {
    res.send({
        name: "terry cruz"
    })
    console.log(req.query)
  })

app.post("/user", (req, res) => {
    console.log(req.body)
    res.send("yay")
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})