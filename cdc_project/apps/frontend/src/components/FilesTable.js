import React from 'react'
import {updateFile} from "../services/FilesServices";
export const UsersFiles = ({files}) => {
    if (files.length === 0) return null

    function sayDelete() {
        alert('This function is not implemented yet');
    }


    const FilesRow = (file, index) => {
        return (
            <tr key={index} className={index % 2 === 0 ? 'odd' : 'even'}>
                <td>{index + 1}</td>
                <td>{file.filename}</td>
                <td>{file.created_on}</td>
                <td>{file.modified_on}</td>
                <td>{file.created_by}</td>
                <td><button onClick={updateFile(file.filename)} >Update file</button><button onClick={sayDelete}>Delete file</button></td>

            </tr>
        )

    }
    const filesTable = files.files.map((file, index) => FilesRow(file, index))

    return (
        <div className="container">
            <h2>Files</h2>
            <table className="table table-bordered">
                <thead>
                <tr>
                    <th>Files ID</th>
                    <th>Filename</th>
                    <th>Created on</th>
                    <th>Modified on</th>
                    <th>Owner</th>
                    <th>Edit</th>
                </tr>
                </thead>
                <tbody>
                {filesTable}
                </tbody>
            </table>
        </div>
    )
}