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
    let synthesizer = AVSpeechSynthesizer()
    var speechManager = SpeechManager()
    
    init() {
        speechManager.onRecognizedText = { [weak self] recognizedText in
            self?.sendText(recognizedText)
        }
    }

    func sendText(_ text: String) {
        guard !text.isEmpty else { return }
        let newMessage = ChatMessage(text: text, isFromUser: true)
        messages.append(newMessage)
        fetchResponse(for: text)
    }

    private func fetchResponse(for text: String) {
        // Simulate AI response, you might replace this with an actual API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = ChatMessage(text: "Echo: \(text)", isFromUser: false)
            self.messages.append(response)
            self.speakText(response.text)
        }
    }

    func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }

    func speechToText() {
        speechManager.startListening()
    }

    func generateImage(from text: String) {
        // Call to an image generation API should be implemented here
        // Example:
        // Send a request to an external API like OpenAI's DALL-E to generate an image based on the text.
    }
}
