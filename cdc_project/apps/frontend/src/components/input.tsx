import * as React from "react";
import {Button, ButtonGroup, Col, Container, FloatingLabel, Form, Row, Table} from "react-bootstrap";

import {
    getAllFiles,
    getFileByName,
    getFileForUser,
    setFileForUser,
    updateFilePerm
} from "../services/restCalls";
import FilesTable from "./filesTable";

export default class InputForm extends React.Component <{}, { [key: string]: any }> {
    constructor(props: any) {
        super(props);
        this.state = {
            result: {},
            username: '',
            filename: '',
            showComponent: false,
        };

        this.handleChangeUsername = this.handleChangeUsername.bind(this);
        this.handleChangeFile = this.handleChangeFile.bind(this);
        this.getAllButtonState = this.getAllButtonState.bind(this);
        this.getFileButtonState = this.getFileButtonState.bind(this);
        this.getFileUserButtonState = this.getFileUserButtonState.bind(this);
        this.postFileUserButtonState = this.postFileUserButtonState.bind(this);
        this.updateFilePermFunction = this.updateFilePermFunction.bind(this);

    };


    handleChangeUsername(event: any) {
        this.setState({username: event.target.value});
    }

    handleChangeFile(event: any) {
        this.setState({filename: event.target.value});
    }

    getAllButtonState = () => {
        getAllFiles().then(result => {
            this.setState({result: result,showComponent: true})
        });
    };

    getFileButtonState = () => {
        getFileByName(this.state.filename).then(result => {
            this.setState({result: result,showComponent: true});
        });
    };

    getFileUserButtonState = () => {
        getFileForUser(this.state.username).then(result => {
            this.setState({result: result,showComponent: true});
        });
    };

    postFileUserButtonState = () => {
        setFileForUser(this.state.username, this.state.filename).then(result => {
            this.setState({result: result,showComponent: true});
        });
    };

    updateFilePermFunction = (filename: any, username: any) => {
        updateFilePerm(filename, username).then(result => {
            this.setState({result: result,showComponent: true});
        });
    }


    renderRows() {
        if (this.state.result == null || this.state.result.files === undefined) {
            return null;
        }
        console.log("This result ", this.state.result)
        return this.state.result.files.map(
            (file: any, index: any) => {
                return (
                    <tr key={index}>
                        <td>{index}</td>
                        <td>{file.filename}</td>
                        <td>{file.created_by}</td>
                        <td>{file.created_on}</td>
                        <td>{file.modified_on}</td>
                        <td>
                            <ButtonGroup>
                                <Button variant="outline-secondary"
                                        onClick={() => updateFilePerm(file.filename, this.state.username)}>Update</Button>
                                <Button variant="outline-secondary">Delete</Button>
                            </ButtonGroup>
                        </td>
                    </tr>
                );
            });
    }

    render() {
        return (
            <Container>
                <Form>
                    <Form.Group className="mb-3" controlId="formUsername">
                        <FloatingLabel controlId="floatingUsername" label="Username" className="mb-3">
                            <Form.Control type="text" placeholder="Alice" value={this.state.username}
                                          onChange={this.handleChangeUsername}/>
                        </FloatingLabel>
                    </Form.Group>

                    <Form.Group className="mb-3" controlId="formBasicFileName">
                        <FloatingLabel controlId="floatingFileName" label="Filename" className="mb-3">
                            <Form.Control type="text" placeholder="test.txt" value={this.state.filename}
                                          onChange={this.handleChangeFile}/>
                        </FloatingLabel>
                    </Form.Group>

                    <Row className="align-items-center">
                        <Col sm={3} className="my-1" xs="auto">
                            <Button variant="primary" onClick={this.getAllButtonState}>Get all files</Button>
                        </Col>
                        <Col sm={3} className="my-1" xs="auto">
                            <Button variant="primary" onClick={this.getFileButtonState}>Get file</Button>
                        </Col>
                        <Col sm={3} className="my-1" xs="auto">
                            <Button variant="primary" onClick={this.getFileUserButtonState}>Get files for user</Button>
                        </Col>
                        <Col sm={3} className="my-1" xs="auto">
                            <Button variant="primary" onClick={this.postFileUserButtonState}>Upload file for
                                user</Button>
                        </Col>
                    </Row>

                </Form>

                {this.state.showComponent ?
                    <FilesTable inputfiles={this.state.result} username={this.state.username}/> :
                    null}


            </Container>

        );
    }
}