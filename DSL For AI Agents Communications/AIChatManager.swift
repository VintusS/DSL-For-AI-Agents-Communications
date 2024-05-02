//
//  AIChatManager.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 02.05.2024.
//

import Foundation

class AIChatManager {
    private let apiKey = "your-api-key-here"
    private let apiURL = URL(string: "https://api.openai.com/v1/engines/davinci/completions")!

    func sendMessage(_ message: String, completion: @escaping (String) -> Void) {
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "prompt": message,
            "max_tokens": 150,
            "temperature": 0.9
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending message to AI: \(error)")
                completion("Failed to get response from AI")
                return
            }
            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = jsonResponse["choices"] as? [[String: Any]],
                  let text = choices.first?["text"] as? String else {
                print("Error parsing response from AI")
                completion("Failed to parse AI response")
                return
            }
            DispatchQueue.main.async {
                completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        task.resume()
    }

}

