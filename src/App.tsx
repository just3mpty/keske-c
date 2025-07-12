import { useEffect, useState } from "react";
import "./App.css";
import Sidenav from "./components/sidenav/Sidenav";
import { invoke } from "@tauri-apps/api/core";
import Card from "./components/systeminfos/Card";

type CardPRops = {
    title: string;
    props: [
        {
            property: string;
            value: string;
        }
    ];
    slots?: [
        {
            number: string;
            props: [
                {
                    property: string;
                    value: string;
                }
            ];
        }
    ];
};

function App() {
    const [systemData, setSystemData] = useState<CardPRops[]>([]);
    const [loadingData, setLoadingData] = useState<boolean>(false);

    useEffect(() => {
        setLoadingData(true);
        invoke("systeminfo")
            .then((response) => {
                setSystemData(response as CardPRops[]);
            })
            .catch((err) => {
                console.error(
                    "Erreur lors de la récupération des données système :",
                    err
                );
            });
        setLoadingData(false);
    }, []);

    return (
        <main className="container">
            <Sidenav />
            <section className="system-infos">
                {loadingData ? (
                    <p>Chargement des informations système ...</p>
                ) : (
                    systemData.map((card, index) => (
                        <Card key={index} {...card} />
                    ))
                )}
            </section>
        </main>
    );
}

export default App;
