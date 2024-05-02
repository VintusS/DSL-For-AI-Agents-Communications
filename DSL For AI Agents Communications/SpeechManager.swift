//
//  SpeechManager.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 02.05.2024.
//

import Foundation
import Speech
import AVFoundation

class SpeechManager: NSObject, ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    private let synthesizer = AVSpeechSynthesizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @Published var isListening = false
    var onRecognizedText: ((String) -> Void)?

    override init() {
        super.init()
        speechRecognizer?.delegate = self
    }

    func startListening() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.startRecording()
                } else {
                    print("Speech recognition authorization was denied")
                }
            }
        }
    }

    private func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session for recording: \(error)")
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode  // Direct access

        recognitionRequest?.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!, resultHandler: { result, error in
            if let result = result, result.isFinal {
                DispatchQueue.main.async {
                    self.onRecognizedText?(result.bestTranscription.formattedString)
                    self.stopListening()
                }
            } else if let error = error {
                print("There was a speech recognition error: \(error.localizedDescription)")
                self.stopListening()
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine failed to start: \(error)")
        }

        isListening = true
    }


    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest = nil
        recognitionTask = nil
        isListening = false
    }

    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
}

extension SpeechManager: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            stopListening()
            print("Speech recognition is not currently available")
        }
    }
}
