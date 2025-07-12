import { invoke } from "@tauri-apps/api/core";
import tests from "../../assets/tests.json";
import "./header.css";

const Header = () => {
    const launchScript = (script: string) => {
        invoke(script);
    };

    return (
        <section className="header">
            {tests.map((cat, idx) => (
                <div key={idx} className="category">
                    <h2>{cat.category}</h2>
                    <div className="buttons">
                        {cat.scripts.map((script, idx) => (
                            <button
                                style={{ backgroundColor: cat.color }}
                                key={idx}
                                onClick={() => launchScript(script.scriptCmd)}>
                                {script.name}
                            </button>
                        ))}
                    </div>
                </div>
            ))}
        </section>
    );
};

export default Header;
