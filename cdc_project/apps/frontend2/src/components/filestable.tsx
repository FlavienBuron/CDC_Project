import * as React from "react";
import {Button, ButtonGroup, Container, Table} from "react-bootstrap";


export default class FilesTable extends React.Component <{inputfiles: any[]}> {
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
                        <Button variant="outline-secondary">Update</Button>
                        <Button variant="outline-secondary">Delete</Button>
                    </ButtonGroup>
                </td>
            </tr>
        )
    }



    render() {
        return (
                <Container>
                    <Table striped bordered hover >
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
