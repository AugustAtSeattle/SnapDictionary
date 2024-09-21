//
//  OCRViewModel.swift
//  SnapDictionary
//
//  Created by Sailor on 9/21/24.
//

import Foundation
import Vision
import UIKit

class OCRViewModel: ObservableObject {
    @Published var recognizedText: [RecognizedText] = []
    @Published var isProcessing = false
    @Published var errorMessage: String?

    func performOCR(on image: UIImage) {
        isProcessing = true
        recognizedText = []
        errorMessage = nil

        guard let cgImage = image.cgImage else {
            errorMessage = "Invalid image."
            isProcessing = false
            return
        }

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

            let recognizedTexts = observations.compactMap { observation -> RecognizedText? in
                guard let topCandidate = observation.topCandidates(1).first else { return nil }
                return RecognizedText(string: topCandidate.string, boundingBox: observation.boundingBox)
            }

            DispatchQueue.main.async {
                self?.recognizedText = recognizedTexts
                self?.isProcessing = false
            }
        }

        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en"] // Adjust as needed
        request.usesLanguageCorrection = true

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
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
