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
    
    func sanitizeInput(_ input: String) -> String {
        let punctuationCharacters = CharacterSet(charactersIn: ".,!?;:'")
        return input.components(separatedBy: punctuationCharacters).joined()
    }

    func response(for input: String) -> String {
        let sanitizedInput = sanitizeInput(input.lowercased())
        if let response = promptResponses.first(where: { sanitizeInput($0.input.lowercased()) == sanitizedInput }) {
            return response.output
        } else {
            return "Sorry, I do not understand."
        }
    }
    
    func sendText(_ text: String) {
        guard !text.isEmpty else { return }
        let newMessage = ChatMessage(text: text, isFromUser: true)
        messages.append(newMessage)
        
        if text.lowercased() == "image" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let typingMessage = ChatMessage(text: "…", isFromUser: false, isTyping: true)
                self.messages.append(typingMessage)

                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    if let index = self.messages.firstIndex(where: { $0.isTyping }) {
                        self.messages.remove(at: index)
                    }
                    self.sendImageMessage(imageUrl: "https://imgur.com/a/WJWxIPv")
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let typingMessage = ChatMessage(text: "…", isFromUser: false, isTyping: true)
                self.messages.append(typingMessage)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    if let index = self.messages.firstIndex(where: { $0.isTyping }) {
                        self.messages.remove(at: index)
                    }
                    let responseText = self.response(for: text)
                    let responseMessage = ChatMessage(text: responseText, isFromUser: false)
                    self.messages.append(responseMessage)
                }
            }
        }
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
    func sendImageMessage(imageUrl: String) {
        let imageMessage = ChatMessage(text: nil, imageUrl: imageUrl, isFromUser: false)
        messages.append(imageMessage)
    }
}

struct ChatMessage: Identifiable {
    var id = UUID()
    var text: String?
    var imageUrl: String?
    var isFromUser: Bool
    var isTyping: Bool = false
}

