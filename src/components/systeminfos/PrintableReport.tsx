import { useSystemInfo } from "../../context/SystemInfoContext";
import "./PrintableReport.css";

const PrintableReport = () => {
    const { systemData } = useSystemInfo();

    if (!systemData) return null;

    return (
        <div className="print-only">
            <h1>🖥️ Rapport Système - Keske.c</h1>

            {systemData.map((section, index) => (
                <div key={index} className="print-card">
                    <h2>{section.title}</h2>

                    {section.props && (
                        <ul>
                            {section.props.map((prop, i) => (
                                <li key={i}>
                                    <strong>{prop.property} :</strong>{" "}
                                    {prop.value}
                                </li>
                            ))}
                        </ul>
                    )}

                    {section.slots && (
                        <div className="slots">
                            {section.slots.map((slot, i) => (
                                <div key={i}>
                                    <h3>{slot.number}</h3>
                                    <ul>
                                        {slot.props.map((prop, j) => (
                                            <li key={j}>
                                                <strong>
                                                    {prop.property} :
                                                </strong>{" "}
                                                {prop.value}
                                            </li>
                                        ))}
                                    </ul>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            ))}
        </div>
    );
};

export default PrintableReport;
