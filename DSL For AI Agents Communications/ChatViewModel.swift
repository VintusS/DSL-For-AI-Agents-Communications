//
//  ChatViewModel.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 02.05.2024.
//

import Foundation
import SwiftUI
import AVFoundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private var promptResponses: [ChatPrompt] = []
    var speechManager = SpeechManager()

    init() {
        loadPromptData()
        speechManager.onRecognizedText = { [weak self] recognizedText in
                    self?.sendText(recognizedText)
                }
    }

    func loadPromptData() {
        let filename = "TrainingPrompts.json"
        if let url = Bundle.main.url(forResource: filename, withExtension: nil) {
            do {
                let data = try Data(contentsOf: url)
                self.promptResponses = try JSONDecoder().decode([ChatPrompt].self, from: data)
            } catch {
                print("Failed to load or decode the prompt data: \(error)")
            }
        } else {
            print("Failed to find \(filename) in bundle.")
        }
    }

    func response(for input: String) -> String {
        if let response = promptResponses.first(where: { $0.input.lowercased() == input.lowercased() }) {
            return response.output
        } else {
            return "Sorry, I do not understand."
        }
    }

    func sendText(_ text: String) {
        guard !text.isEmpty else { return }
        let newMessage = ChatMessage(text: text, isFromUser: true)
        messages.append(newMessage)
        let responseText = response(for: text)
        let responseMessage = ChatMessage(text: responseText, isFromUser: false)
        messages.append(responseMessage)
    }
    func speechToText() {
            speechManager.startListening { [weak self] (recognizedText, error) in
                guard let self = self, let text = recognizedText, error == nil else {
                    print("Error or no text recognized: \(String(describing: error))")
                    return
                }
                DispatchQueue.main.async {
                    self.sendText(text)
                }
            }
        }
}
