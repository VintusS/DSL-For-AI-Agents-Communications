//
//  SpeechToTextManager.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 03.05.2024.
//

import Speech

class SpeechToTextManager: NSObject, ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    @Published var isRecording = false

    override init() {
        super.init()
        speechRecognizer.delegate = self
        checkSpeechAuthorization()
    }

    func startRecording(completion: @escaping (String?) -> Void) throws {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
            print("Existing recognition task was cancelled.")
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        print("Audio session started successfully.")

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode
        recognitionRequest?.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { result, error in
            var isFinal = false

            if let result = result {
                completion(result.bestTranscription.formattedString)
                print("Partial transcription: \(result.bestTranscription.formattedString)")
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.isRecording = false
                print("Speech recognition task completed.")
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        print("Audio input node is now capturing audio.")

        audioEngine.prepare()
        try audioEngine.start()
        print("Audio engine started.")

        isRecording = true
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        isRecording = false
        print("Recording stopped and audio engine has been reset.")
    }
    
    func checkSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized.")
            case .denied:
                print("Speech recognition authorization denied.")
            case .restricted:
                print("Speech recognition authorization restricted.")
            case .notDetermined:
                print("Speech recognition authorization not determined.")
            @unknown default:
                print("Unknown speech recognition authorization status.")
            }
        }
    }


}

extension SpeechToTextManager: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            stopRecording()
        }
    }
}

