import * as React from "react";
import {Badge, Container, Nav, Navbar} from "react-bootstrap";

export default class NavBar extends React.Component <{}> {
    render() {
        return (
            <Navbar bg="light" expand="lg">
                <Container>
                    <Navbar.Brand>
                        <img
                            alt=""
                            src="https://pic.onlinewebfonts.com/svg/img_443619.png"
                            width="30"
                            height="30"
                            className="d-inline-block align-top"
                        />{' '}
                        CDC distributed file system {' '}
                        <Badge pill bg="success">New UI !</Badge>
                    </Navbar.Brand>
                    <Navbar.Toggle aria-controls="basic-navbar-nav" />
                    <Navbar.Collapse id="basic-navbar-nav">
                        <Nav className="me-auto">
                            <Nav.Link href="http://localhost:3000" target="_blank">Frontend</Nav.Link>
                            <Nav.Link href="http://localhost:8080" target="_blank">Backend</Nav.Link>
                        </Nav>
                    </Navbar.Collapse>
                </Container>
            </Navbar>
    );
    }
}