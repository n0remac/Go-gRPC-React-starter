import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import Login from './pages/user/Login';
import Register from './pages/user/Register';

export default function App() {
    return (
        <Router>
            <div>
                <nav>
                    <ul style={{ listStyleType: 'none', margin: 0, padding: 0, overflow: 'hidden', backgroundColor: '#333' }}>
                        <li style={{ float: 'right' }}>
                            <Link to="/login" style={{ display: 'block', color: 'white', textAlign: 'center', padding: '14px 16px', textDecoration: 'none' }}>Login</Link>
                        </li>
                        <li style={{ float: 'right' }}>
                            <Link to="/register" style={{ display: 'block', color: 'white', textAlign: 'center', padding: '14px 16px', textDecoration: 'none' }}>Register</Link>
                        </li>
                        
                    </ul>
                </nav>

                <Routes>
                    <Route path="/login" element={< Login />} />
                    <Route path="/register" element={< Register />} />
                </Routes>
            </div>
        </Router>
    );
}
