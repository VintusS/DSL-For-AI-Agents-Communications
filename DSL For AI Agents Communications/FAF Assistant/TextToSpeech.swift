//
//  SwiftUIView.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 03.05.2024.
//

import AVFoundation

class TextToSpeechConverter: ObservableObject {
    private let speechSynthesizer = AVSpeechSynthesizer()

    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }
}
