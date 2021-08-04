import { useEffect, useState } from "react";
import { Container, Form, Button } from "react-bootstrap";
import Accordion from "react-bootstrap/Accordion";
import { CodeBlock, dracula } from "react-code-blocks";

async function getFortunes(token, searchString) {
  console.log(token);

  let url = "http://localhost:3000/fortunes";
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

async function deleteFortune(id, token) {
  let url = `http://localhost:3000/fortune/${id}`;
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

export default function FortuneList({ token }) {
  const [fortunes, setFortunes] = useState([]);
  const [search, setSearch] = useState("");
  async function searchFor(string) {
    setSearch(string);
    let fortunes = await getFortunes(token, string);
    setFortunes(fortunes);
  }

  async function deleteThing(id, token) {
    try {
      await deleteFortune(id, token);
      await searchFor(search);
    } catch (e) {
      console.log(e);
    }
  }

  useEffect(() => {
    async function userAPICall() {
      let fortunes = await getFortunes(token);
      console.log(fortunes);
      setFortunes(fortunes);
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
          placeholder="Find fortunes"
          onChange={(e) => searchFor(e.target.value)}
        />
      </Form.Group>
      <Accordion>
        {fortunes.map((element) => {
          return (
            <Accordion.Item key={element._id} eventKey={element._id}>
              <Accordion.Header>{element.message}</Accordion.Header>
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
