import { useEffect, useState } from "react";
import { Container, Form, Button } from "react-bootstrap";
import Accordion from "react-bootstrap/Accordion";
import { CodeBlock, dracula } from "react-code-blocks";

async function getUsers(token, searchString) {
  console.log(token);

  let url = `${process.env.REACT_APP_BASE_URL}/users`;
  if (searchString) {
    url = url + "?search=" + searchString;
  }
  return fetch(url, {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  }).then(async (data) => {
    return data.json();
  });
}

async function deleteUser(id, token) {
  let url = `${process.env.REACT_APP_BASE_URL}/user/${id}`;
  return fetch(url, {
    method: "DELETE",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  }).then(async (data) => {
    return data.text();
  });
}

export default function UserList({ token }) {
  const [users, setUsers] = useState([]);
  const [search, setSearch] = useState("");
  async function searchFor(searchQuery) {
    let users = await getUsers(token, searchQuery);
    setSearch(searchQuery);
    setUsers(users);
  }

  async function deleteThing(id, token) {
    try {
      await deleteUser(id, token);
      await searchFor(search);
    } catch (e) {
      console.log(e);
    }
  }

  useEffect(() => {
    async function userAPICall() {
      let users = await getUsers(token, undefined);
      console.log(users);
      setUsers(users);
    }
    userAPICall();
  }, []);

  let text = `
  var sys = require("sys");
  sys.puts("Hello World");
  `;
  return (
    <Container fluid>
      <Form.Group className="mb-3" controlId="formBasicEmail">
        <Form.Control
          type="search"
          placeholder="Find users"
          onChange={(e) => search(e.target.value)}
        />
      </Form.Group>
      <Accordion>
        {users.map((element) => {
          return (
            <Accordion.Item key={element._id} eventKey={element._id}>
              <Accordion.Header>{element.email}</Accordion.Header>
              <Accordion.Body style={{ textAlign: "left" }}>
                <CodeBlock
                  text={JSON.stringify(element, null, "\t")}
                  language="javascript"
                  wrapLines={true}
                  codeBlock
                ></CodeBlock>

                <div></div>
                <Button
                  variant="danger"
                  onClick={async function () {
                    await deleteThing(element._id, token);
                  }}
                >
                  Delete
                </Button>
              </Accordion.Body>
            </Accordion.Item>
          );
        })}
      </Accordion>
    </Container>
  );
}
