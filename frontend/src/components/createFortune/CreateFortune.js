import { useState } from "react";
import { Form, Button, Row, Col } from "react-bootstrap";

export default function CreateFortune({ token }) {
  const [rules, setRules] = useState([]);
  const [message, setMessage] = useState("");
  let stringRuleChoices = ["CONTAINS", "EQUALS", "!CONTAINS", "!EQUALS"];

  return (
    <div>
      <h1>Create Fortune</h1>
      <Form style={{ textAlign: "left" }}>
        <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
          <Form.Label>Message</Form.Label>
          <Form.Control
            type="email"
            placeholder="Anyone named {first_name} can have a great day!"
          />
        </Form.Group>

        <Form.Group>
          <Form.Label>Target</Form.Label>
          <Row>
            <Col>
              <Form.Select aria-label="Default select example">
                <option>KEY</option>
                <option value="1">One</option>
                <option value="2">Two</option>
                <option value="3">Three</option>
              </Form.Select>
            </Col>
            <Col>
              <Form.Select aria-label="Default select example">
                <option>RULE</option>
                {stringRuleChoices.map((string) => {
                  return <option value={string}>{string}</option>;
                })}
              </Form.Select>
            </Col>
            <Col>
              <Form.Control
                type="email"
                placeholder="Anyone named {first_name} can have a great day!"
              />
            </Col>
          </Row>
          <Button variant="primary">Add Rule</Button>
        </Form.Group>
        <Button variant="primary">Add Fortune</Button>
      </Form>
    </div>
  );
}
