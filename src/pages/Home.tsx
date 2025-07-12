// src/pages/Home.tsx
import { useEffect, useState } from "react";
import { invoke } from "@tauri-apps/api/core";
import Card from "../components/systeminfos/Card";
import "../App.css";

type CardProps = {
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

const Home = () => {
    const [data, setData] = useState<CardProps[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        invoke("systeminfo")
            .then((res) => setData(res as CardProps[]))
            .catch((err) => console.error(err))
            .finally(() => setLoading(false));
    }, []);

    return loading ? (
        <div className="chargement">
            <div className="loader" />
            <p>Chargement des infos...</p>
        </div>
    ) : (
        <>
            {data.map((card, i) => (
                <Card key={i} {...card} />
            ))}
        </>
    );
};

export default Home;
