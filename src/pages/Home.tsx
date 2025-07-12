import Card from "../components/systeminfos/Card";
import "../App.css";
import { useSystemInfo } from "../context/SystemInfoContext";

const Home = () => {
    const { systemData, loading } = useSystemInfo();

    return loading ? (
        <div className="chargement">
            <div className="loader" />
            <p>Chargement des infos...</p>
        </div>
    ) : (
        <>
            {systemData?.map((card, i) => (
                <Card key={i} {...card} />
            ))}
        </>
    );
};

export default Home;
