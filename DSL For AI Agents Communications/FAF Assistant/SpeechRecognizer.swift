//
//  SpeechRecognizer.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 03.05.2024.
//

import Speech

class SpeechRecognizer: ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    @Published var recognizedText = ""

    func startRecording() throws {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorized.")
                    self.setupAudioEngineAndStartRecognition()
                default:
                    print("Speech recognition not authorized.")
                }
            }
        }
    }

    private func setupAudioEngineAndStartRecognition() {
        do {
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
                self.recognitionRequest?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()

            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { result, error in
                if let result = result {
                    DispatchQueue.main.async {
                        let text = result.bestTranscription.formattedString
                        self.recognizedText = text
                        print("Partial Recognized Text: \(text)")
                        if result.isFinal {
                            print("Final Recognized Text: \(text)")
                            self.stopRecording()
                        }
                    }
                } else if let error = error {
                    print("Recognition error: \(error)")
                }
            }
        } catch {
            print("Audio engine setup error: \(error)")
        }
    }

    func stopRecording() {
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.finish()

        audioEngine.stop()
        recognitionRequest = nil
        recognitionTask = nil
        print("Stopped recording.")
    }

}
