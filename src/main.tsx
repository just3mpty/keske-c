import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Layout from "./components/Layout";
import Home from "./pages/Home";
import Diagnostic from "./pages/Diagnostic";
import Contribute from "./pages/Contribute";
import { SystemInfoProvider } from "./context/SystemInfoContext";

ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
    <React.StrictMode>
        <SystemInfoProvider>
            <BrowserRouter>
                <Routes>
                    <Route path="/" element={<Layout />}>
                        <Route index element={<Home />} />
                        <Route path="/diagnostic" element={<Diagnostic />} />
                        <Route path="/contribute" element={<Contribute />} />
                    </Route>
                </Routes>
            </BrowserRouter>
        </SystemInfoProvider>
    </React.StrictMode>
);
