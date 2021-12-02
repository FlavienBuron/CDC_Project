import React from 'react'

export const UsersFiles = ({files}) => {
    if (files.length === 0) return null
    const UserRow = (user,index) => {
        return(
            <tr key = {index} className={index%2 === 0?'odd':'even'}>
                <td>{index + 1}</td>
                <td>{user.user}</td>
                <td>{user.permissions}</td>
                <td>{user.owner}</td>
            </tr>
        )
    }

    //const userTable = files.users.map((user,index) => UserRow(user,index))

    const FilesRow = (file,index) => {
        return(
            <tr key = {index} className={index%2 === 0?'odd':'even'}>
                <td>{index + 1}</td>
                <td>{file.filename}</td>
                <td>{file.created_on}</td>
                <td>{file.modified_on}</td>
                <td>{files.users}</td>

            </tr>
        )

    }
    const filesTable = files.map((file,index) => FilesRow(file,index))

    return(
        <div className="container">
            <h2>Files</h2>
            <table className="table table-bordered">
                <thead>
                <tr>
                    <th>Files ID</th>
                    <th>Filename</th>
                    <th>Created on</th>
                    <th>modified on</th>
                    <th>User</th>
                    <th>permissions</th>
                    <th>owner</th>
                </tr>
                </thead>
                <tbody>
                {filesTable}
                </tbody>
            </table>
        </div>
    )
}