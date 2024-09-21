//
//  DictionaryDrawerView.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//

import SwiftUI

struct DictionaryDrawerView: View {
    let selectedText: String
    @ObservedObject var dictionaryViewModel: DictionaryViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            // Pull-to-dismiss indicator
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.5))
                .padding(.top, 8)

            // Selected word
            Text(selectedText)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 8)

            // Definition content
            if dictionaryViewModel.isLoading {
                Spacer()
                ProgressView("Fetching definition...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                Spacer()
            } else if let definition = dictionaryViewModel.definition {
                ScrollView {
                    Text(definition)
                        .padding()
                }
            } else if let errorMessage = dictionaryViewModel.errorMessage {
                Spacer()
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else {
                Spacer()
                Text("No definition found.")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }

            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            dictionaryViewModel.fetchDefinition(for: selectedText)
        }
        .onDisappear {
            dictionaryViewModel.reset()
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}
