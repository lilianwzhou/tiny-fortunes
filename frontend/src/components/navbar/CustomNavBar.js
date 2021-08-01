import { Navbar, Container, Button } from "react-bootstrap";
import NavbarCollapse from "react-bootstrap/esm/NavbarCollapse";
export default function CustomNavBar({ setToken }) {
  function handleSubmit(event) {
    setToken(undefined);
  }
  return (
    <Navbar bg="light">
      <Container>
        <Navbar.Brand href="/">Cookies</Navbar.Brand>
        <Button variant="danger" onClick={handleSubmit}>
          Logout
        </Button>
      </Container>
    </Navbar>
  );
}
