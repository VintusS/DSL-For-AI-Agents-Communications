//
//  jsonDecoder.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 03.05.2024.
//

import Foundation

struct NewsArticle: Decodable {
    var Article: String
    var Image: String
    var Title: String
    var Subtitle: String
    var Description: String
}

struct ChatPrompt: Codable {
    var input: String
    var output: String
}

func loadPrompts() -> [ChatPrompt] {
    guard let url = Bundle.main.url(forResource: "TrainingPrompts", withExtension: "json") else {
        fatalError("JSON file not found")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let prompts = try decoder.decode([ChatPrompt].self, from: data)
        return prompts
    } catch {
        fatalError("Failed to decode JSON: \(error)")
    }
}
