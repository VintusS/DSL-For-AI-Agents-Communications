//
//  SettingsView.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 02.05.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("apiKey") private var apiKey = ""
    @AppStorage("voiceEnabled") private var voiceEnabled = true
    @AppStorage("voicePitch") private var voicePitch = 1.0 

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("API Settings")) {
                    TextField("API Key", text: $apiKey)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Speech Settings")) {
                    Toggle("Enable Voice", isOn: $voiceEnabled)
                    Slider(value: $voicePitch, in: 0.5...1.5, step: 0.1) {
                        Text("Voice Pitch")
                    }
                    Text("Pitch: \(voicePitch, specifier: "%.2f")")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSettings()
                    }
                }
            }
        }
    }
    
    private func saveSettings() {
        print("Settings saved.")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

