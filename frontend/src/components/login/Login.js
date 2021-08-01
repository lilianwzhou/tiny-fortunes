import React, { useState } from "react";
import Form from "react-bootstrap/Form";
import Button from "react-bootstrap/Button";
import "./Login.css";
import PropTypes from "prop-types";

async function loginUser(credentials) {
  console.log(credentials);
  return fetch("http://localhost:3000/auth?isAdmin=true", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(credentials),
  }).then(async (data) => {
    if (Math.floor(data.status / 100) !== 2) {
      let text = await data.text();
      console.log("TEXT");
      console.log(text);
      return Promise.reject(text);
    }
    return data.json();
  });
}

export default function Login({ setToken }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const [error, setError] = useState("");
  function validateForm() {
    return email.length > 0 && password.length > 0;
  }

  async function handleSubmit(event) {
    event.preventDefault();
    try {
      const token = await loginUser({ email, password });
      setToken(token.accessToken);
    } catch (error) {
      console.log(error);
      setError(error);
    }
  }

  let errorView = <div></div>;

  if (error) {
    errorView = <p style={{ color: "red" }}>{error}</p>;
  }
  return (
    <div className="Login">
      <Form onSubmit={handleSubmit}>
        <Form.Group size="lg" controlId="email">
          <Form.Label>Email</Form.Label>
          <Form.Control
            autoFocus
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </Form.Group>
        <Form.Group size="lg" controlId="password">
          <Form.Label>Password</Form.Label>
          <Form.Control
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </Form.Group>
        <Button block size="lg" type="submit" disabled={!validateForm()}>
          Login
        </Button>
        {errorView}
      </Form>
    </div>
  );
}

Login.propTypes = {
  setToken: PropTypes.func.isRequired,
};
