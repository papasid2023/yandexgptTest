//
//  requestBody.swift
//  aitest
//
//  Created by Руслан Сидоренко on 27.05.2024.
//

import Foundation

struct requestObject: Codable {
    let modelUri: String
    let completionOptions: CompletionOptions
    let messages: [Message]
}

struct CompletionOptions: Codable {
    let stream: Bool
    let temperature: Double
    let maxTokens: Int
}

struct Message: Codable {
    let role: String
    let text: String
}
