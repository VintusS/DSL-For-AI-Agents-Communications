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
            DispatchQueue.main.async {
                self?.sendText(recognizedText)
            }
        }
    }

    func sendText(_ text: String) {
        guard !text.isEmpty else { return }
        let newMessage = ChatMessage(text: text, isFromUser: true)
        messages.append(newMessage)
        fetchResponse(for: text)
    }

    private func fetchResponse(for text: String) {
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
        speechManager.startListening { [weak self] (recognizedText, error) in
            if let error = error {
                print("Error during speech recognition: \(error)")
                return
            }
            
            guard let recognizedText = recognizedText, !recognizedText.isEmpty else {
                print("No speech was detected or the recognized text is empty.")
                return
            }
            
            DispatchQueue.main.async {
                self?.sendText(recognizedText)
            }
        }
    }
}
