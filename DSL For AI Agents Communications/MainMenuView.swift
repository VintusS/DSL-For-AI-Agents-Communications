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
            VStack {
                List {
                    Section {
                        NavigationLink("Chat", destination: ChatView())
                        NavigationLink("Settings", destination: SettingsView())
                        NavigationLink("Assistant", destination: AssistantView())
                    } header: {
                        Text("Main menu")
                    }
                }
                Spacer()
                Section {
                    Text("©Team 3 DSL")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color(.systemBackground))
                }
            }
            .navigationTitle("FAF Chat")
        }
    }
}



struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}

