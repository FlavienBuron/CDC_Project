import React, {useState, useEffect} from 'react';
//import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css';
import {Header} from './components/Header'
import {UsersFiles} from './components/FilesTable'
import InputPart from './components/InputPart'
import {getFileForUser,setFileForUser} from './services/FilesServices'

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
        await getFileForUser(user)
            .then(files => {
                setFiles(files);
            });
    }
    const setFilesBis = async (e) => {
        console.log("filename ",filename)
        await setFileForUser(user,filename)
    }

    useEffect(async (e) => {
        await getFileForUser(e)
    }, [])

    return (
        <div className="App">
            <Header/>

            <InputPart
                onChange={handleUsernameChange}
                apiGetFiles={getFiles}
                apiSetFiles={setFilesBis}
            />


            <div className="row mrgnbtm">
                <UsersFiles files={files}/>
            </div>
        </div>
    );
}

export default App;