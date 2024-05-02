//
//  ImageGenerator.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 02.05.2024.
//

import Foundation
import UIKit

class ImageGenerator {
    private let apiKey = "your-api-key-here"
    private let apiURL = URL(string: "https://api.openai.com/v1/images/generations")!

    func generateImage(from prompt: String, completion: @escaping (UIImage?) -> Void) {
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "prompt": prompt,
            "n": 1,  // Number of images to generate
            "size": "256x256"  // Size of the generated image
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to request image generation: \(String(describing: error))")
                completion(nil)
                return
            }

            do {
                let jsonResponse = try JSONDecoder().decode(ImageResponse.self, from: data)
                if let imageData = Data(base64Encoded: jsonResponse.data[0].url), let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    print("Failed to decode image data")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("Error decoding response: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }

    struct ImageResponse: Codable {
        var data: [ImageData]
    }

    struct ImageData: Codable {
        var url: String
    }
}

