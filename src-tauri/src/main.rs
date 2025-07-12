// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod utils;
use utils::get_system_info::get_system_data;

#[tauri::command]
fn systeminfo() -> Result<serde_json::Value, String> {
  get_system_data()
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![systeminfo])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
