use std::process::Command;

pub fn launch_stress_test() -> Result<String, String> {
    let script_path = "./src/scripts/stress-test.ps1";

    Command::new("powershell")
        .args([
            "-ExecutionPolicy", "Bypass",
            "-File", script_path,
        ])
        .spawn()
        .map_err(|e| format!("Erreur lors de l’exécution du stress test : {}", e))?;

    Ok("✅ Stress test lancé en arrière-plan.".into())
}
