//
//  DictionaryViewModel.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//

import Foundation
import Combine

class DictionaryViewModel: ObservableObject {
    @Published var definition: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func fetchDefinition(for word: String) {
        isLoading = true
        definition = nil
        errorMessage = nil

        DictionaryService.shared.fetchDefinition(for: word)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] definition in
                self?.definition = definition
            })
            .store(in: &cancellables)
    }

    func reset() {
        definition = nil
        errorMessage = nil
        isLoading = false
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
