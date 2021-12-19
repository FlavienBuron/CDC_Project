import React from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'react-bootstrap-table-next/dist/react-bootstrap-table2.min.css';
import './App.css';
import NavBar from "./components/navbar";
import InputForm from "./components/input";

function App() {
  return (
    <div className="App">
        <NavBar/>
        <InputForm/>
    </div>
  );
}

export default App;
