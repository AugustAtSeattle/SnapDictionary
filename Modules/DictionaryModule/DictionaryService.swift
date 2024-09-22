//
//  DictionaryService.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//

import Foundation

struct DictionaryEntry: Codable {
    let word: String
    let phonetic: String?
    let phonetics: [Phonetic]
    let origin: String?
    let meanings: [Meaning]
}

struct Phonetic: Codable {
    let text: String?
    let audio: String?
}

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
    let synonyms: [String]
    let antonyms: [String]
}

struct Definition: Codable {
    let definition: String
    let example: String?
    let synonyms: [String]
    let antonyms: [String]
}

protocol DictionaryServiceProtocol {
    func fetchWordInfo(for word: String) async throws -> [DictionaryEntry]
}

class DictionaryService: DictionaryServiceProtocol {
    private let baseURL = "https://api.dictionaryapi.dev/api/v2/entries/en/"
    
    func fetchWordInfo(for word: String) async throws -> [DictionaryEntry] {
        guard let url = URL(string: baseURL + word) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([DictionaryEntry].self, from: data)
    }
}
