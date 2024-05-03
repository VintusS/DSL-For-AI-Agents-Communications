//
//  FAFAssistant.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 03.05.2024.
//

import SwiftUI
import AVFoundation

struct AssistantView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @StateObject private var textToSpeechConverter = TextToSpeechConverter()
    @State private var isListening = false
    @State private var isSpeaking = false
    @State private var pulse = false
    let data: [ChatPrompt] = loadPrompts()

    var body: some View {
        VStack {
            Text("Introducing FAF Assistant")
                .font(.custom("BalooBhai-regular", size: 50))
                .bold()
                .multilineTextAlignment(.center)
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 200, height: 200)
                    .overlay(
                        Circle()
                            .stroke(Color.blue, lineWidth: 10)
                            .scaleEffect(pulse ? 1.1 : 1)
                            .opacity(pulse ? 0 : 1)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulse)
                    )
                    .onAppear { pulse.toggle() }
                    .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                        if pressing {
                            isListening = true
                            pulse = true
                            configureAudioSession()
                            try? speechRecognizer.startRecording()
                        } else {
                            isListening = false
                            pulse = false
                            speechRecognizer.stopRecording()
                            processText(speechRecognizer.recognizedText)
                        }
                    }, perform: {})
                
                Text(isListening ? "Listening..." : "Hold and Speak")
                    .multilineTextAlignment(.center)
                    .frame(width: 170)
                    .lineLimit(4)
                    .foregroundColor(.white)
                    .animation(.easeInOut, value: isListening)
                    .font(.custom("BalooBhai-regular", size: 20))
            }
            Spacer()
        }
    }
    
    private func configureAudioSession() {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers])
                try audioSession.setActive(true)
            } catch {
                print("Failed to configure audio session: \(error)")
            }
        }

    private func processText(_ text: String) {
        let response = data.first(where: { data in
            let charsToRemove: CharacterSet = CharacterSet(charactersIn: ".,")
            let filteredInput = data.input.components(separatedBy: charsToRemove).joined()
            
            return text.localizedCaseInsensitiveContains(filteredInput)
        })?.output ?? (text.isEmpty ? "I don't quite understand." : "Can you repeat please?")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.textToSpeechConverter.speak(text: response)
        }
    }


}

#Preview {
    AssistantView()
}
