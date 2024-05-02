//
//  jsonReader.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 02.05.2024.
//

import Foundation

struct ChatPrompt: Codable {
    var input: String
    var output: String
}

struct PromptCollection: Codable {
    var prompts: [ChatPrompt]
}


