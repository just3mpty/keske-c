// src/components/Layout.tsx
import { Outlet } from "react-router-dom";
import Sidenav from "./sidenav/Sidenav";
import PrintableReport from "./systeminfos/PrintableReport";

const Layout = () => {
    return (
        <main className="container">
            <Sidenav />
            <section className="content">
                <Outlet />
                <PrintableReport />
            </section>
        </main>
    );
};

export default Layout;
