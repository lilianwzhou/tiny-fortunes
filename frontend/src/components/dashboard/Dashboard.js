import React from "react";
import { Link } from "react-router-dom";

import Card from "react-bootstrap/Card";
import Button from "react-bootstrap/Button";
import { Container, Row } from "react-bootstrap";
export default function Dashboard() {
  return (
    <div>
      <h1>Cookies Admin Dashboard</h1>
      <Container fluid>
        <Row className="justify-content-md-center">
          {getCard(
            "Create Fortune",
            "Add a new fortune to the database",
            "Add Fortune",
            "/fortune/create"
          )}
          {getCard(
            "Manage Users",
            "Check out the users in the DB",
            "Users",
            "/users"
          )}
          {getCard(
            "Manage Fortunes",
            "Check out the fortunes in the DB",
            "Fortunes",
            "/fortunes"
          )}
        </Row>
      </Container>
    </div>
  );
}

function getCard(title, text, buttonTitle, link) {
  return (
    <Card style={{ width: "18rem" }}>
      <Card.Body>
        <Card.Title>{title}</Card.Title>
        <Card.Text>{text}</Card.Text>
        <Link to={link}>
          <Button variant="primary">{buttonTitle}</Button>
        </Link>
      </Card.Body>
    </Card>
  );
}
