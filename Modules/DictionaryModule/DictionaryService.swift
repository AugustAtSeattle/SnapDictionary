//
//  DictionaryService.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//

import Foundation
import Combine

class DictionaryService: DictionaryServiceProtocol {
    static let shared = DictionaryService()

    private init() {}

    func fetchDefinition(for word: String) -> AnyPublisher<String, Error> {
        // Use a public dictionary API, such as dictionaryapi.dev
        let language = "en"
        let encodedWord = word.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? word
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/\(language)/\(encodedWord)"

        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> String in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                // Parse the definition from the data
                return try self.parseDefinition(from: data)
            }
            .eraseToAnyPublisher()
    }

    private func parseDefinition(from data: Data) throws -> String {
        struct APIResponse: Codable {
            struct Meaning: Codable {
                struct Definition: Codable {
                    let definition: String
                }
                let definitions: [Definition]
            }
            let meanings: [Meaning]
        }

        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode([APIResponse].self, from: data)

        if let firstMeaning = apiResponse.first?.meanings.first,
           let firstDefinition = firstMeaning.definitions.first?.definition {
            return firstDefinition
        } else {
            throw NSError(domain: "No definition found", code: -1, userInfo: nil)
        }
    }
}
