import React from 'react'
import {getAllFiles, stopNodes} from "../services/FilesServices";


export const InputPart = ({onChange, apiGetFiles, apiSetFiles}) => {


    return (
        <div className="container">
            <div className="row">
                <div className="col-md-7 mrgnbtm">
                    <h2>User</h2>
                    <form>
                        <div className="row">
                            <div className="form-group col-md-6">
                                <label htmlFor="exampleInputUsername1">Username</label>
                                <input type="text" onChange={(e) => onChange(e)} className="form-control"
                                       name="username" id="username" aria-describedby="usernameHelp"
                                       placeholder="User Name"/>
                            </div>
                        </div>

                        <div className="row">
                            <div className="form-group col-md-12">
                                <label htmlFor="exampleInputFileName">File name</label>
                                <input type="text" onChange={(e) => onChange(e)} className="form-control" name="filename" id="filename" aria-describedby="filenameHelp" placeholder="File Name" />
                            </div>
                        </div>
                        <button type="button" onClick={(e) => apiGetFiles()} className="btn btn-danger">Get all files</button>
                        <button type="button" onClick={(e) => apiSetFiles()} className="btn btn-danger">Post new file</button>
                        {/*<button type="button" onClick={(e) => stopNodes()} className="btn btn-danger">stop nodes</button>*/}
                    </form>
                </div>
            </div>
        </div>
    )
}

export default InputPart