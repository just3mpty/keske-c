pub fn get_system_data() -> Result<serde_json::Value, String> {
    use std::process::Command;
    let output = Command::new("powershell")
        .args([
            "-NoProfile",
            "-ExecutionPolicy", "Bypass",
            "-File",
            "src/scripts/system_info.ps1"
        ])
        .output()
        .map_err(|e| e.to_string())?;

    if output.status.success() {
        let json = String::from_utf8_lossy(&output.stdout);
        serde_json::from_str(&json).map_err(|e| format!("Erreur JSON: {}", e))
    } else {
        Err(String::from_utf8_lossy(&output.stderr).to_string())
    }
}