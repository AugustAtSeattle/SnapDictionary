//
//  DictionaryViewModel.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//

import Foundation
import Combine
import AVFoundation

@MainActor
class DictionaryViewModel: ObservableObject {
    private let dictionaryService: DictionaryServiceProtocol
    private var audioPlayer: AVAudioPlayer?

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var entries: [DictionaryEntry] = []

    init(dictionaryService: DictionaryServiceProtocol) {
        self.dictionaryService = dictionaryService
    }

    func fetchWordInfo(for word: String) {
        Task {
            isLoading = true
            errorMessage = nil
            entries = []

            // Parse the word: remove spaces and take the first part
            let parsedWord = word.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .whitespaces).first ?? ""

            do {
                entries = try await dictionaryService.fetchWordInfo(for: parsedWord)
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }

    func playAudioSample(for audioURL: String) {
        guard let url = URL(string: audioURL) else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer?.play()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
    }

    func reset() {
        isLoading = false
        errorMessage = nil
        entries = []
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
