//
//  LocalDictionaryService.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//

import Foundation
import Combine
import UIKit

class LocalDictionaryService: DictionaryServiceProtocol {
    func fetchWordInfo(for word: String) async throws -> [DictionaryEntry] {
        return []
    }
    
    
    static let shared = LocalDictionaryService()

    private init() {}

//    func fetchDefinition(for word: String) -> AnyPublisher<DictionaryEntry, Error> {
//        return Future { promise in
//            DispatchQueue.global(qos: .userInitiated).async {
//                let hasDefinition = UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word)
//                
//                if hasDefinition {
//                    DispatchQueue.main.async {
//                        let referenceVC = UIReferenceLibraryViewController(term: word)
//                        let definition = "Definition available. Please use the presented dictionary view to see it."
//                        
//                        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
//                            topViewController.present(referenceVC, animated: true, completion: nil)
//                        }
//                        
////                        promise(.success(definition))
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        promise(.failure(NSError(domain: "LocalDictionary", code: 404, userInfo: [NSLocalizedDescriptionKey: "No definition found for '\(word)'"])))
//                    }
//                }
//            }
//        }.eraseToAnyPublisher()
//    }
}
