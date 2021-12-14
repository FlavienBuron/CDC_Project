import * as React from "react";
import {Button, ButtonGroup, Container, OverlayTrigger, Popover, Table, Toast} from "react-bootstrap";
import {updateFilePerm} from "../services/restCalls";


export default class FilesTable extends React.Component <{inputfiles: any[], username: any}> {

    constructor(props: any) {
        super(props);
        this.renderFileRow = this.renderFileRow.bind(this);
    };

    renderFileRow(file:any, index:any) {
            return (
                <tr key={index}>
                    <td>{index}</td>
                    <td>{file.filename}</td>
                    <td>{file.created_by}</td>
                    <td>{file.created_on}</td>
                    <td>{file.modified_on}</td>
                    <td>
                        <ButtonGroup>
                            <Button onClick={() => updateFilePerm(file.filename, this.props.username)}
                                    variant="outline-secondary">Update</Button>
                            <Button variant="outline-secondary">Delete</Button>
                        </ButtonGroup>
                    </td>
                </tr>
            )
    }


    render() {
        return (
            <Container >
                <Table striped bordered hover>
        <thead>
            <tr>
                <th>#</th>
        <th>File Name</th>
        <th>Owner</th>
        <th>Created on</th>
        <th>Modified on</th>
        <th>Edit</th>
        </tr>
        </thead>
        <tbody>
        {this.props.inputfiles.map(this.renderFileRow)}
        </tbody>
        </Table>
        </Container>
    );
    }
}
