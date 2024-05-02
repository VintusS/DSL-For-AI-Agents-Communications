//
//  SpeechManager.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 02.05.2024.
//

import Foundation
import Speech
import AVFoundation

class SpeechManager {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // Adding a callback property
    var onRecognizedText: ((String) -> Void)?

    func startListening(completion: @escaping (String?, Error?) -> Void) {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        // Direct access to inputNode, as it's not optional
        let inputNode = audioEngine.inputNode
        recognitionRequest?.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { result, error in
            if let result = result {
                completion(result.bestTranscription.formattedString, nil)
            } else if let error = error {
                completion(nil, error)
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine didn't start due to an error: \(error)")
            completion(nil, error)
        }
    }


    func stopListening() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
    }
}

