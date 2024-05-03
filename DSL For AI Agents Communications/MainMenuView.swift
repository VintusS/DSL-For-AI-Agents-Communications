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
                        NavigationLink("Assistant", destination: AssistantView())
                        NavigationLink("Image Wizard", destination: ChatView())
                    } header: {
                        Text("Main menu")
                    }
                    Section {
                        NavigationLink("Credentials", destination: CreditsView())
                    } header: {
                        Text("Something additional")
                    }
                    Section {
                        NavigationLink("Settings", destination: SettingsView())
                    } header: {
                        Text("YOLO")
                    }
                }
                Spacer()
                Section {
                    Text("©Team 3 DSL")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color(.systemBackground))
                }
            }
            .navigationTitle("FAF HUB")
        }
    }
}



struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}

