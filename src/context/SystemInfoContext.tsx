import { createContext, useContext, useEffect, useState } from "react";
import { invoke } from "@tauri-apps/api/core";
import { CardProps } from "../types/CardProps";

type SystemInfoContextType = {
    systemData: CardProps[] | null;
    loading: boolean;
};

const SystemInfoContext = createContext<SystemInfoContextType>({
    systemData: null,
    loading: false,
});

export const useSystemInfo = () => useContext(SystemInfoContext);

export const SystemInfoProvider = ({
    children,
}: {
    children: React.ReactNode;
}) => {
    const [systemData, setSystemData] = useState<CardProps[] | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        invoke("systeminfo")
            .then((response) => {
                setSystemData(response as CardProps[]);
                setLoading(false);
            })
            .catch((err) => {
                console.error("Erreur de récupération systeminfo:", err);
                setLoading(false);
            });
    }, []);

    return (
        <SystemInfoContext.Provider value={{ systemData, loading }}>
            {children}
        </SystemInfoContext.Provider>
    );
};
