//
//  DictionaryDrawerView.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//

import SwiftUI

struct DictionaryDrawerView: View {
    let selectedText: String
    @ObservedObject var viewModel: DictionaryViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isPlayingAudio = false

    var body: some View {
        VStack(spacing: 16) {
            // Pull-to-dismiss indicator
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.secondary)
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            // Selected word
            Text(selectedText)
                .font(.title)
                .fontWeight(.bold)

            if viewModel.isLoading {
                ProgressView()
            } else if !viewModel.entries.isEmpty {
                ScrollView {
                    ForEach(viewModel.entries, id: \.word) { entry in
                        EntryView(entry: entry, viewModel: viewModel)
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                #if DEBUG
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                #else
                Text("Oops! We couldn't find a definition for that word. Please try another one.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                #endif
            } else {
                Text("No definition found")
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .shadow(radius: 5)
        .onAppear {
            viewModel.fetchWordInfo(for: selectedText)
        }
        .onDisappear {
            viewModel.reset()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct EntryView: View {
    let entry: DictionaryEntry
    @ObservedObject var viewModel: DictionaryViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // Phonetics
            if let phonetic = entry.phonetic {
                Text(phonetic)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Audio
            if let audio = entry.phonetics.first(where: { $0.audio != nil })?.audio, !audio.isEmpty {
                Button(action: {
                    viewModel.playAudioSample(for: audio)
                }) {
                    Image(systemName: "speaker.wave.2")
                        .foregroundColor(.blue)
                }
            }
        }
        
        VStack(alignment: .leading, spacing: 16) {
            // Origin
            if let origin = entry.origin {
                Text("Origin: \(origin)")
                    .font(.subheadline)
            }

            // Meanings
            ForEach(entry.meanings, id: \.partOfSpeech) { meaning in
                MeaningView(meaning: meaning)
            }
        }
    }
}

struct MeaningView: View {
    let meaning: Meaning

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(meaning.partOfSpeech)
                .font(.headline)

            ForEach(meaning.definitions.indices, id: \.self) { index in
                DefinitionView(definition: meaning.definitions[index], index: index + 1)
            }

            if !meaning.synonyms.isEmpty {
                Text("Synonyms: \(meaning.synonyms.joined(separator: ", "))")
                    .font(.subheadline)
            }

            if !meaning.antonyms.isEmpty {
                Text("Antonyms: \(meaning.antonyms.joined(separator: ", "))")
                    .font(.subheadline)
            }
        }
    }
}

struct DefinitionView: View {
    let definition: Definition
    let index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(index). \(definition.definition)")

            if let example = definition.example {
                Text("Example: \"\(example)\"")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    Group {
       DictionaryDrawerView(selectedText: "Hello", viewModel: DictionaryViewModel(dictionaryService: DictionaryService()))
//        DictionaryDrawerView(selectedText: "World", dictionaryViewModel: DictionaryViewModel(dictionaryService: LocalDictionaryService.shared))
    }
}


// Add this extension to apply corner radius to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
