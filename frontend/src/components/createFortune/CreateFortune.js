import { useState } from "react";
import { Form, Button, Row, Col } from "react-bootstrap";

async function createFortune(body, token) {
  console.log(body);
  return fetch("http://localhost:3000/fortune", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer " + token,
    },
    body: JSON.stringify(body),
  }).then(async (data) => {
    if (Math.floor(data.status / 100) !== 2) {
      let text = await data.text();
      console.log("failed");
      return Promise.reject(text);
    }
    console.log("succeeded");
    console.log(data);
    return data;
  });
}

export default function CreateFortune({ token }) {
  const [rules, setRules] = useState([]);
  const [errorMessage, setError] = useState();
  const [message, setMessage] = useState("");
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

  function getErrorDiv() {
    console.log(errorMessage);
    if (errorMessage) {
      return <div style={{ color: "red" }}>{errorMessage}</div>;
    }
    return undefined;
  }

  async function verifyFortune() {
    console.log("verify");
    var bracketCount = (message.match(/{/g) || []).length;
    var otherBracketCount = (message.match(/}/g) || []).length;
    if (bracketCount !== otherBracketCount) {
      setError("Invalid Message");
      return;
    }
    let re = new RegExp(/\{(.*?)\}/, "g");
    try {
      message.replace(re, (match) => {
        match = match.slice(1, -1);
        if (
          ![...dateKeys, ...booleanKeys, ...stringKeys, ...numKeys].includes(
            match
          )
        ) {
          throw "Invalid Message";
        }
        return match;
      });
    } catch (err) {
      setError(err);
      return;
    }

    for (var i = 0; i < rules.length; i++) {
      if (rules[i].operation === "RULE") {
        setError("Ensure All Rules Filled Out");
        return;
      }
    }
    setError(undefined);
    try {
      let thing = await createFortune({ message, buckets: rules }, token);
    } catch (e) {
      setError(e);
    }
    console.log("success");
  }
  function getCol(rule) {
    if (stringKeys.includes(rule.key)) {
      return (
        <Col>
          <Form.Control
            type="text"
            placeholder="value"
            value={rule.value}
            onChange={function (event) {
              rule.value = event.target.value;

              setRules([...rules]);
            }}
          />
        </Col>
      );
    }
    if (numKeys.includes(rule.key)) {
      return (
        <Col>
          <Form.Control
            type="number"
            placeholder="number"
            value={rule.value}
            onChange={function (event) {
              rule.value = event.target.value;

              setRules([...rules]);
            }}
          />
        </Col>
      );
    }
    if (dateKeys.includes(rule.key)) {
      return (
        <Col>
          <Form.Control
            type="date"
            placeholder="date"
            value={rule.value}
            onChange={function (event) {
              rule.value = event.target.value;

              setRules([...rules]);
            }}
          />
        </Col>
      );
    }
    return undefined;
  }

  function getRules(key) {
    let array = stringRuleChoices;
    if (booleanKeys.includes(key)) {
      array = boolRuleChoices;
    }
    if (numKeys.includes(key)) {
      array = numberRuleChoices;
    }
    if (dateKeys.includes(key)) {
      array = dateRuleChoices;
    }
    return array.map((string) => {
      return (
        <option key={string} value={string}>
          {string}
        </option>
      );
    });
  }

  return (
    <div>
      <h1>Create Fortune</h1>
      <Form style={{ textAlign: "left" }}>
        <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
          <Form.Label>Message</Form.Label>
          <Form.Control
            type="text"
            placeholder="Anyone named {first_name} can have a great day!"
            onChange={function (event) {
              setMessage(event.target.value);
            }}
          />
        </Form.Group>

        <Form.Group>
          <Form.Label>Target</Form.Label>
          {rules.map((rule, index) => {
            return (
              <Row key={index}>
                <Col>
                  <Form.Select
                    aria-label="Default select example"
                    index={index}
                    value={rule.key}
                    onChange={function (event) {
                      rule.key = event.target.value;
                      rule.value = "";
                      rule.operation = "RULE";
                      setRules([...rules]);
                    }}
                  >
                    <option>KEY</option>
                    {numKeys.map((string) => {
                      return (
                        <option key={string} value={string}>
                          {string}
                        </option>
                      );
                    })}
                    {stringKeys.map((string) => {
                      return (
                        <option key={string} value={string}>
                          {string}
                        </option>
                      );
                    })}
                    {booleanKeys.map((string) => {
                      return (
                        <option key={string} value={string}>
                          {string}
                        </option>
                      );
                    })}
                    {dateKeys.map((string) => {
                      return (
                        <option key={string} value={string}>
                          {string}
                        </option>
                      );
                    })}
                  </Form.Select>
                </Col>
                <Col>
                  <Form.Select
                    aria-label="Default select example"
                    value={rule.operation}
                    onChange={function (event) {
                      rule.operation = event.target.value;

                      setRules([...rules]);
                    }}
                  >
                    <option>RULE</option>
                    {getRules(rule.key)}
                  </Form.Select>
                </Col>
                {getCol(rule)}
                <Col xs={1}>
                  <Button
                    variant="danger"
                    onClick={function () {
                      rules.splice(index, 1);
                      setRules([...rules]);
                    }}
                  >
                    delete
                  </Button>
                </Col>
              </Row>
            );
          })}
          <div style={{ textAlign: "center" }}>
            <Button
              variant="primary"
              onClick={function () {
                setRules([
                  ...rules,
                  { key: "first_name", operation: "CONTAINS", value: "" },
                ]);
              }}
            >
              Add Rule
            </Button>
          </div>
        </Form.Group>
        <div className="d-grid gap-2">
          {getErrorDiv(errorMessage)}
          <Button variant="primary" size="lg" onClick={verifyFortune}>
            Add Fortune
          </Button>
        </div>
      </Form>
    </div>
  );
}
