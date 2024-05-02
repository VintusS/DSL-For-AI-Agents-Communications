//
//  MainMenuView.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 02.05.2024.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Chat", destination: ChatView())
                NavigationLink("Settings", destination: SettingsView())
            }
            .navigationTitle("Main Menu")
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}

