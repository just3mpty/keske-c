// src/components/Layout.tsx
import { Outlet } from "react-router-dom";
import Sidenav from "./sidenav/Sidenav";

const Layout = () => {
    return (
        <main className="container">
            <Sidenav />
            <section className="content">
                <Outlet />
            </section>
        </main>
    );
};

export default Layout;
