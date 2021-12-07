import React, {useState, useEffect} from 'react';
//import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css';
import {Header} from './components/Header'
import {UsersFiles} from './components/FilesTable'
import InputPart from './components/InputPart'
import {getAllFiles, setFileForUser} from './services/FilesServices'

function App() {
    const [user, setUser] = useState("");
    const [filename, setFilename] = useState("");
    const [files, setFiles] = useState([])

    const handleUsernameChange = (e) => {
        if (e.target.name === 'filename') {
            setFilename(e.target.value);
        } else if (e.target.name === 'username') {
            setUser(e.target.value);
        }
    };

    const getFiles = async (e) => {
        await getAllFiles(user)
            .then(files => {
                setFiles(files);
            });
    }
    const postFile = async (e) => {
        await setFileForUser(user,filename)
    }

    useEffect((e) => {
        getAllFiles(e)
    }, [])

    return (
        <div className="App">
            <Header/>

            <InputPart
                onChange={handleUsernameChange}
                apiGetFiles={getFiles}
                apiSetFiles={postFile}
            />


            <div className="row mrgnbtm">
                <UsersFiles files={files}/>
            </div>
        </div>
    );
}

export default App;