//
//  OCRViewModel.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//
import Vision
import UIKit

class OCRViewModel: ObservableObject {
    @Published var recognizedText: [RecognizedText] = []
    @Published var isProcessing = false
    @Published var errorMessage: String?
    @Published var selectedText: RecognizedText?
    func performOCR(on image: UIImage) {
        isProcessing = true
        recognizedText = []
        errorMessage = nil

        guard let cgImage = image.cgImage else {
            errorMessage = "Invalid image."
            isProcessing = false
            return
        }

        // Convert UIImage orientation to CGImagePropertyOrientation
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)

        let request = VNRecognizeTextRequest { [weak self] (request, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "OCR Error: \(error.localizedDescription)"
                    self?.isProcessing = false
                }
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No text found."
                    self?.isProcessing = false
                }
                return
            }

            let recognizedTexts = observations.compactMap { observation -> [RecognizedText]? in
                guard let topCandidate = observation.topCandidates(1).first else { return nil }
                guard !topCandidate.string.isEmpty else { return nil }

                // Get the string (which might be a full sentence or multiple words)
                let fullString = topCandidate.string

                // Split the string into individual words
                let words = fullString.split(separator: " ")

                // Prepare to collect individual word bounding boxes and strings
                var recognizedWords = [RecognizedText]()

                // Iterate over each word and extract its bounding box
                var searchStartIndex = fullString.startIndex
                for word in words {
                    // Find the range of the word in the full string
                    if let wordRange = fullString.range(of: String(word), range: searchStartIndex..<fullString.endIndex) {
                        // Use the `boundingBox(for:)` with the `Range<String.Index>`
                        if let wordBoundingBoxObservation = try? topCandidate.boundingBox(for: wordRange) {
                            // Extract the `CGRect` from `VNRectangleObservation`
                            let wordBoundingBox = wordBoundingBoxObservation.boundingBox
                            
                            // Create the RecognizedText with the word and its bounding box
                            let recognizedWord = RecognizedText(string: String(word), boundingBox: wordBoundingBox)
                            recognizedWords.append(recognizedWord)
                        }

                        // Move the search start index forward to avoid finding the same word again
                        searchStartIndex = wordRange.upperBound
                    }
                }

                return recognizedWords.isEmpty ? nil : recognizedWords
            }

            DispatchQueue.main.async {
                self?.recognizedText = recognizedTexts.flatMap { $0 }
                self?.isProcessing = false
            }
        }

        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en"] // Adjust as needed
        request.usesLanguageCorrection = true

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: cgOrientation, options: [:])

        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try requestHandler.perform([request])
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.errorMessage = "Failed to perform OCR: \(error.localizedDescription)"
                    self?.isProcessing = false
                }
            }
        }
    }
}

// Helper function to convert UIImageOrientation to CGImagePropertyOrientation
extension CGImagePropertyOrientation {
    init(_ uiImageOrientation: UIImage.Orientation) {
        switch uiImageOrientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
