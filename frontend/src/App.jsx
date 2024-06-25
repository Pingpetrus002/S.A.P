import React, { useEffect, useState } from 'react';
import { GetUrlArgs } from './utils/Utilities';
import PageComposer from './pages/PageComposer';
import './App.css';
import Navbar from "./components/Navbar.jsx";


function App() {

    const [page, setPage] = useState("DefaultPage");


    useEffect(() => {
        const args = GetUrlArgs();
        if ("page" in args) {
            console.log(args);
            setPage(args["page"]);
        }
    }, []);

    return (
        <div className="App">
            <Navbar/>
            <PageComposer page={page} />
        </div>
    );
    
}

export default App;
